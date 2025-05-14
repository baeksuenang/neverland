import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: authProvider.emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: authProvider.passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => authProvider.login(context),
              child: const Text('로그인'),
            ),
            ElevatedButton(
              onPressed: authProvider.register,
              child: const Text('회원가입'),
            ),
            const SizedBox(height: 20),
            Text(authProvider.message),
          ],
        ),
      ),
    );
  }
}
