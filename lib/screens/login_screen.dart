import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/neverland.png', // 경로 체크
                height: 60,
              ),
              const SizedBox(height: 24),
              const Text(
                'make your account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: authProvider.emailController,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Write ID',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: authProvider.passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Write password',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => authProvider.register(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Confirm'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                authProvider.message,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
