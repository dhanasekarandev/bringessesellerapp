import 'dart:async';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
// import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferenceHelper sharedPreferenceHelper;
  final RemoteConfigService remoteConfigService = RemoteConfigService();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    sharedPreferenceHelper = SharedPreferenceHelper();
    await sharedPreferenceHelper.init();

    // Step 1: Check Play Store version first
    final playStoreUpdate = await playstoreVersionUpdate();

    // Step 2: If no update found in Play Store, then check Firebase Remote Config
    bool firebaseUpdate = false;
    if (!playStoreUpdate) {
      try {
        await remoteConfigService.init();
        firebaseUpdate = await _checkForUpdate();
      } catch (e) {
        debugPrint("Firebase Remote Config init failed: $e");
      }
    }

    // Step 3: If no updates required, go to next screen
    if (!playStoreUpdate && !firebaseUpdate && mounted) {
      _navigateNext();
    }
  }

  String? referCode;
  Future<void> initReferrerDetails() async {
    String referrerDetailsString;
    String? referralCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      ReferrerDetails referrerDetails =
          await PlayInstallReferrer.installReferrer;

      referrerDetailsString = referrerDetails.installReferrer.toString();

      final uri = Uri.parse("https://dummy.com/?" + referrerDetailsString);
      referralCode = uri.queryParameters['referral_code'];
    } catch (e) {
      referrerDetailsString = 'Failed to get referrer details: $e';
    }

    if (!mounted) return;

    setState(() {
      referCode = referralCode;
      print('setstate refercode--------$referCode');
    });
  }

  /// ✅ Step 1: Check Play Store version
  Future<bool> playstoreVersionUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final packageName = packageInfo.packageName;

      final latestVersion = await PlayStoreVersionService()
          .getLatestVersionFromPlayStore(packageName);

      if (latestVersion != null &&
          PlayStoreVersionService()
              .isVersionNewer(latestVersion, currentVersion)) {
        if (mounted) {
          _showUpdateDialog(
              "https://play.google.com/store/apps/details?id=$packageName");
        }
        return true;
      }
    } catch (e) {
      debugPrint("Play Store version check failed: $e");
    }
    return false;
  }

  /// ✅ Step 2: Check Firebase Remote Config (if no Play Store update)
  Future<bool> _checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (remoteConfigService.isUpdateRequired(currentVersion)) {
        if (mounted) {
          _showUpdateDialog(remoteConfigService.updateUrl);
        }
        return true;
      }
    } catch (e) {
      debugPrint("Firebase version check failed: $e");
    }
    return false;
  }

  /// ✅ Common update dialog (used by both Firebase and Play Store)
  void _showUpdateDialog(String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Update Available")),
        content: SizedBox(
          width: 300,
          height: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Update img-bringesse.png',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),
              const Text(
                "You're using an older version of the app. Please update now to continue using all features smoothly.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CustomButton(
            title: "Update Now",
            onPressed: () async {
              final uri = Uri.parse(updateUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _navigateNext() async {
    print('skssk${referCode}');
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboard_seen') ?? false;
    final loginSeen = prefs.getBool('login_seen') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      context.go('/onboarding', extra: {'refcode': referCode});
    } else if (loginSeen) {
      //  context.go('/approve');
      context.go('/dashboard');
    } else {
      context.go('/welcome', extra: {'refcode': referCode});
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/splash_screen.png'),
        ),
      ),
    );
  }
}

/// ✅ Firebase Remote Config Service
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.fetchAndActivate();
  }

  bool isUpdateRequired(String currentVersion) {
    final latestVersion = _remoteConfig.getString('latest_version');
    final updateRequired = _remoteConfig.getBool('update_required');

    if (!updateRequired) return false;
    return _isVersionNewer(latestVersion, currentVersion);
  }

  String get updateUrl => _remoteConfig.getString('update_url');

  bool _isVersionNewer(String remote, String local) {
    try {
      List<int> r = remote.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      List<int> l = local.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      while (r.length < 3) r.add(0);
      while (l.length < 3) l.add(0);

      for (int i = 0; i < 3; i++) {
        if (r[i] > l[i]) return true;
        if (r[i] < l[i]) return false;
      }
    } catch (e) {
      debugPrint("Version parse error: $e");
    }
    return false;
  }
}

/// ✅ Play Store Fallback Service
class PlayStoreVersionService {
  Future<String?> getLatestVersionFromPlayStore(String packageName) async {
    try {
      final url = Uri.parse(
          "https://play.google.com/store/apps/details?id=$packageName&hl=en");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final exp = RegExp(r'\[\[\["([0-9]+\.[0-9]+\.[0-9]+)"\]\]');
        final match = exp.firstMatch(response.body);
        if (match != null) {
          return match.group(1);
        }
      }
    } catch (e) {
      debugPrint("Error fetching Play Store version: $e");
    }
    return null;
  }

  bool isVersionNewer(String remote, String local) {
    try {
      final r = remote.split('.').map(int.parse).toList();
      final l = local.split('.').map(int.parse).toList();
      for (int i = 0; i < r.length; i++) {
        if (r[i] > l[i]) return true;
        if (r[i] < l[i]) return false;
      }
    } catch (e) {
      debugPrint("Version parse error: $e");
    }
    return false;
  }
}
