import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 80,
              right: 0, // 오른쪽 끝으로 붙이기
              child: Image.asset(
                'assets/intro_logo.png',
                height: 280, // 크기 키움
              ),
            ),
            Positioned(
              top: 340,
              left: 40,
              right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'We still grow in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/neverland.png',
                    height: 50,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 140,
              left: 40,
              right: 40,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 버튼 누를 때 동작 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_forward, color: Colors.white),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 40,
              right: 40,
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account?\n",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '         Resister now!',
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
