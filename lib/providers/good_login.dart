import 'package:flutter/material.dart';
import '../screens/group_screen.dart'; // 그룹 화면 import

class GoodLoginProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      // 로그인 성공시
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GroupScreen()),
      );
    } catch (e) {
      message = '로그인 실패: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> register() async {
    // 회원가입 로직
  }
}
