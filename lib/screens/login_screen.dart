import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── 로고 ─────────────────────────────
              Image.asset('assets/neverland.png', height: 60),
              const SizedBox(height: 24),

              // ── 제목 ─────────────────────────────
              const Text('welcome back',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(height: 32),

              // ── 이메일, 패스워드 입력 ───────────────
              _input(auth.emailController, 'Email'),
              const SizedBox(height: 20),
              _input(auth.passwordController, 'Password', obscure: true),
              const SizedBox(height: 40),

              // ── Login 버튼 ────────────────────────
              _wideBtn('Login', () => auth.login(context)),
              const SizedBox(height: 16),

              // ── Register 링크 자리만 확보 ───────────
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Register 화면은 다음 단계에서!')),
                ),
                child: const Text('Register now',
                    style: TextStyle(color: Colors.tealAccent)),
              ),
              const SizedBox(height: 10),

              // ── 에러 메시지 ────────────────────────
              Text(auth.message,
                  style: const TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── 헬퍼 위젯 ─────────
  Widget _input(TextEditingController c, String hint,
      {bool obscure = false}) {
    return TextField(
      controller: c,
      obscureText: obscure,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        enabledBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
      ),
    );
  }

  Widget _wideBtn(String text, VoidCallback onTap) => SizedBox(
    width: 180,
    height: 48,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(text),
    ),
  );
}
