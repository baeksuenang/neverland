import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login_screen.dart';

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
              right: 0,
              child: Image.asset(
                'assets/intro_logo.png',
                height: 280,
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
                  // 여긴 그냥 버튼 클릭 아무 동작 안해도 됨
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
                  text: TextSpan(
                    text: "Don't have an account?\n",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '         Resister now!',
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
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
