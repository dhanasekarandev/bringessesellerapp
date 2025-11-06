import 'dart:async';
import 'package:bringessesellerapp/config/constant/sharedpreference_helper.dart';
import 'package:bringessesellerapp/presentation/widget/custome_button.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    _init(); // ✅ Make sure we call this
  }

  Future<void> _init() async {
    sharedPreferenceHelper = SharedPreferenceHelper();
    await sharedPreferenceHelper.init();
    await remoteConfigService.init();

    // Wait for remote config and version check before navigation
    final shouldShowUpdate = await _checkForUpdate();

    if (!shouldShowUpdate && mounted) {
      _navigateNext(); // only navigate if no update dialog shown
    }
  }

  Future<bool> _checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (remoteConfigService.isUpdateRequired(currentVersion)) {
      if (mounted) {
        _showUpdateDialog();
      }
      return true;
    }
    return false;
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Update Available")),
        content: SizedBox(
          width: 300, // fixed width
          height: 250, // fixed height
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/Update img-bringesse.png',
                height: 150, // adjust as needed
                width: 150, // adjust as needed
                fit: BoxFit.contain,
              ),
              Text(
                "You're using an older version of the app. Please update now to continue using all features smoothly.",
                style: Theme.of(context).textTheme.titleLarge,
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
              final url = remoteConfigService.updateUrl;
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboard_seen') ?? false;
    final loginSeen = prefs.getBool('login_seen') ?? false;

    // ✅ Delay for splash image
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      context.go('/onboarding');
    } else if (loginSeen) {
      context.go('/dashboard');
    } else {
      context.go('/welcome');
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
    print(
        "ldjbfskd$currentVersion , ${_remoteConfig.getString('latest_version')}");
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
