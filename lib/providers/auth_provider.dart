import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      message = '로그인 성공!';
    } on FirebaseAuthException catch (e) {
      message = '로그인 실패: [${e.code}] ${e.message}';
    } catch (e) {
      message = '로그인 실패: $e';
    } finally {
      notifyListeners();  // 항상 UI 업데이트
    }
  }

  Future<void> register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      message = '회원가입 성공!';
    } on FirebaseAuthException catch (e) {
      message = '회원가입 실패: [${e.code}] ${e.message}';
    } catch (e) {
      message = '회원가입 실패: $e';
    } finally {
      notifyListeners();  // 항상 UI 업데이트
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
