import 'package:flutter/material.dart';
import 'push_morning.dart'; // 새 화면 import

class PushScreen extends StatelessWidget {
  const PushScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 상단 Z 로고 + 톱니바퀴
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset('assets/z.png', height: 60),
              ),
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

            // 본문 내용
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // morning.png
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

                  // PUSH 버튼 → push_morning.dart로 이동
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PushMorningScreen(),
                        ),
                      );
                    },
                    child: Image.asset('assets/push.png', width: 200),
                  ),

                  const SizedBox(height: 40),

                  // 페이지 인디케이터
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
