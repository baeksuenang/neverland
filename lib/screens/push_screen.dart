import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';


class PushScreen extends StatelessWidget {
  final String teamId;
  final String userId;

  const PushScreen({super.key, required this.teamId, required this.userId});

  Future<void> _lockAndExit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Firebase Realtime Database에 "sleeping" 기록
    final dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child('teamStatus/$teamId/members/$userId').set('sleeping');

    // 2. SharedPreferences에 잠금 상태 기록
    await prefs.setBool('isLocked', true);

    // 3. 푸시 알림 전송
    final notifications = FlutterLocalNotificationsPlugin();
    const androidDetails = AndroidNotificationDetails(
      'lock_channel', '수면잠금',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await notifications.show(
      0,
      '잠금 상태입니다',
      '수면시간입니다. 핸드폰 사용이 제한됩니다.',
      details,
    );

    // 4. 앱 종료 (홈으로 나감)
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(child: Image.asset('assets/z.png', height: 60)),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.tealAccent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black, size: 20),
                  onPressed: () {
                    // TODO: 설정 화면 이동
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/night.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => _lockAndExit(context),
                    child: Image.asset('assets/push.png', width: 200),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dot(isActive: false),
                      const SizedBox(width: 8),
                      _dot(isActive: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot({required bool isActive}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.tealAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
