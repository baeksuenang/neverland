import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/position_selection_screen.dart';

class AuthProvider with ChangeNotifier {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login(BuildContext context) async {
    message = '';
    notifyListeners();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email:    emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _goNext(context);
    } on FirebaseAuthException catch (e) {
      message = '로그인 실패: ${e.message ?? e.code}';
      notifyListeners();
    }
  }

  Future<void> register(BuildContext context) async {
    message = '';
    notifyListeners();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email:    emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      _goNext(context);
    } on FirebaseAuthException catch (e) {
      message = e.code == 'email-already-in-use'
          ? '이미 사용 중인 이메일입니다'
          : '회원가입 실패: ${e.message ?? e.code}';
      notifyListeners();
    }
  }

  void _goNext(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PositionSelectionScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
