// app_lifecycle_observer.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neverlandv1/screens/SleepLockScreen.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey;

  AppLifecycleObserver(this.navigatorKey);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final prefs = await SharedPreferences.getInstance();
    final isLocked = prefs.getBool('isLocked') ?? false;

    if (state == AppLifecycleState.resumed && isLocked) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SleepLockScreen()),
            (_) => false,
      );
    }
  }
}

