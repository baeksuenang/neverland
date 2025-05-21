import 'package:flutter/material.dart';
import 'invite/no_invite_screen.dart';
import 'group/add_teammates_screen.dart'; // ✅ 이 화면으로 이동할 거임

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
              Image.asset('assets/neverland.png', height: 60),
              const SizedBox(height: 24),
              const Text(
                'select your position',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 20,
                children: [
                  // ───────── manager 버튼 (수정됨) ─────────
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTeammatesScreen(), // ✅ 이걸로 수정!
                        ),
                      );
                    },
                    style: _btnStyle,
                    child: const Text('manager'),
                  ),

                  // ───────── member 버튼 ─────────
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NoInviteScreen(),
                        ),
                      );
                    },
                    style: _btnStyle,
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

  // 버튼 스타일 공통 부분
  ButtonStyle get _btnStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.tealAccent,
    foregroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
