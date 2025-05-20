import 'package:flutter/material.dart';

class PositionSelectionScreen extends StatelessWidget {
  const PositionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/neverland.png',
                height: 60,
              ),
              const SizedBox(height: 24),
              const Text(
                'select your position',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 20,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // manager 역할 선택 시 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('manager'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // member 역할 선택 시 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('member'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
