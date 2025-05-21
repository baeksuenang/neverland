import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'group/group_screen.dart';

class AuthProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      message = '로그인 성공!';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GroupScreen()),
      );
    } on FirebaseAuthException catch (e) {
      message = '로그인 실패: [${e.code}] ${e.message}';
    } catch (e) {
      message = '로그인 실패: $e';
    } finally {
      notifyListeners();
    }
  }

  Future<void> register(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      message = '회원가입 성공!';

      // 회원가입 성공 시 자동 로그인 → 바로 GroupScreen 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GroupScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        message = 'This username is already taken';
      } else {
        message = '회원가입 실패: [${e.code}] ${e.message}';
      }
    } catch (e) {
      message = '회원가입 실패: $e';
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
