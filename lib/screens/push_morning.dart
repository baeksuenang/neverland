import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'call_screen.dart';

class PushMorningScreen extends StatefulWidget {
  final String teamId;
  final String userId;

  const PushMorningScreen({
    super.key,
    required this.teamId,
    required this.userId,
  });

  @override
  State<PushMorningScreen> createState() => _PushMorningScreenState();
}

class _PushMorningScreenState extends State<PushMorningScreen> {
  late DatabaseReference membersRef;
  Map<String, dynamic> memberStates = {};

  @override
  void initState() {
    super.initState();
    membersRef = FirebaseDatabase.instance
        .ref('teamStatus/${widget.teamId}/members');

    membersRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        setState(() {
          memberStates = Map<String, dynamic>.from(data);
        });
      }
    });
  }

  Future<void> _wakeUp() async {
    final dbRef = FirebaseDatabase.instance.ref();

    // 1. 나의 상태를 awake으로 설정
    await dbRef
        .child('teamStatus/${widget.teamId}/members/${widget.userId}')
        .set('awake');

    // 2. 전체 상태 확인
    final snapshot =
    await dbRef.child('teamStatus/${widget.teamId}/members').get();
    final members = snapshot.value as Map?;

    bool allAwake = members?.values.every((v) => v == 'awake') ?? false;

    if (allAwake) {
      await dbRef.child('teamStatus/${widget.teamId}/isEveryoneAwake').set(true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLocked', false);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CallScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allAwake =
        memberStates.isNotEmpty && memberStates.values.every((v) => v == 'awake');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 상단 Z 로고 + 설정
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

            // 본문
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/morning.png',
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 팀원 상태 표시
                  Text(
                    '팀원 상태',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: memberStates.entries.map((entry) {
                        final status = entry.value;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: status == 'awake'
                                    ? Colors.tealAccent
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 기상 버튼
                  GestureDetector(
                    onTap: _wakeUp,
                    child: Image.asset('assets/push.png', width: 200),
                  ),

                  const SizedBox(height: 20),

                  // 전체 기상 메시지
                  if (allAwake)
                    const Text(
                      '🎉 모든 팀원이 기상했어요!',
                      style: TextStyle(color: Colors.tealAccent, fontSize: 16),
                    ),

                  const SizedBox(height: 20),
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
