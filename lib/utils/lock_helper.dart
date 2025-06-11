// lib/utils/lock_helper.dart
import 'package:flutter/services.dart';

class LockHelper {
  static const MethodChannel _channel = MethodChannel('com.example.neverland/lock');

  static Future<void> lockPhone() async {
    try {
      await _channel.invokeMethod('lockPhone');
    } on PlatformException catch (e) {
      print('🔒 기기 잠금 실패: ${e.message}');
    }
  }
}
