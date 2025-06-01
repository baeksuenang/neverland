// app_lifecycle_observer.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neverlandv1/screens/SleepLockScreen.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey;

  AppLifecycleObserver(this.navigatorKey);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final prefs = await SharedPreferences.getInstance();
      final isLocked = prefs.getBool('isLocked') ?? false;

      if (isLocked) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const SleepLockScreen(),
            fullscreenDialog: true,
          ),
        );
      }
    }
  }
}
