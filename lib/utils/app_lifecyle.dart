import 'package:flutter/widgets.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('🔄 App state changed: $state');

    if (state == AppLifecycleState.resumed) {
      print('📱 App is visible (foreground)');
    } else if (state == AppLifecycleState.paused) {
      print('🌙 App moved to background');
    } else if (state == AppLifecycleState.detached) {
      print('💀 App killed or detached');
    }
  }
}
