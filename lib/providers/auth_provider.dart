import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      message = '로그인 성공!';
      notifyListeners();  // UI 업데이트
    } catch (e) {
      message = '로그인 실패: $e';
      notifyListeners();  // UI 업데이트
    }
  }

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      message = '회원가입 성공!';
      notifyListeners();
    } catch (e) {
      message = '회원가입 실패: $e';
      notifyListeners();
    }
  }
}
