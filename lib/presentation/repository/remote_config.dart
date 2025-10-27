
import 'package:firebase_remote_config/firebase_remote_config.dart';


class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  bool isUpdateRequired(String currentVersion) {
    final latestVersion = _remoteConfig.getString('latest_version');
    final updateRequired = _remoteConfig.getBool('update_required');

    if (!updateRequired) return false;

    
    return _isVersionNewer(latestVersion, currentVersion);
  }

  String get updateMessage => _remoteConfig.getString('update_message');
  String get updateUrl => _remoteConfig.getString('update_url');

  bool _isVersionNewer(String remote, String local) {
    List<int> r = remote.split('.').map(int.parse).toList();
    List<int> l = local.split('.').map(int.parse).toList();
    for (int i = 0; i < r.length; i++) {
      if (r[i] > l[i]) return true;
      if (r[i] < l[i]) return false;
    }
    return false;
  }
}
