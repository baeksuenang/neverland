import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushScreen extends StatelessWidget {
  final String teamId;
  final String userId;

  const PushScreen({super.key, required this.teamId, required this.userId});

  Future<bool> _canSleepNow() async {
    final doc = await FirebaseFirestore.instance.collection('groups').doc(teamId).get();
    final sleepData = doc['sleepTime'];
    final int sleepHour = sleepData['hour'];
    final int sleepMinute = sleepData['minute'];

    final now = DateTime.now().toLocal();  // ✅ 한국 시간으로
    DateTime sleepTime = DateTime(now.year, now.month, now.day, sleepHour, sleepMinute);

    // 다음날로 넘어가는 경우 처리
    if (sleepTime.isBefore(now)) {
      sleepTime = sleepTime.add(const Duration(days: 1));
    }

    final thresholdTime = sleepTime.subtract(const Duration(hours: 2));

    print('✅ 현재시간: $now');
    print('✅ 수면시간: $sleepTime');
    print('✅ 수면가능시작시간(2시간전): $thresholdTime');

    return now.isAfter(thresholdTime) || now.isAtSameMomentAs(thresholdTime);
  }

  Future<void> _lockAndExit(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final dbRef = FirebaseDatabase.instance.ref();

    await dbRef.child('teamStatus/$teamId/members/$userId').set('sleeping');
    await prefs.setBool('isLocked', true);

    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _canSleepNow(),
      builder: (context, snapshot) {
        final canSleep = snapshot.data ?? false;

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
                      onPressed: () {},
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
                        onTap: canSleep
                            ? () => _lockAndExit(context)
                            : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('아직 수면 시간이 아닙니다'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
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
      },
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
