import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print('🔄 App state changed: $state');
    }

    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) {
        print('📱 App is visible (foreground)');
      }
    } else if (state == AppLifecycleState.paused) {
      if (kDebugMode) {
        print('🌙 App moved to background');
      }
    } else if (state == AppLifecycleState.detached) {
      if (kDebugMode) {
        print('💀 App killed or detached');
      }
    }
  }
}
