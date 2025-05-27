import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/position_selection_screen.dart';

class AuthProvider with ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(BuildContext context) async {
    message = '';
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _registerUserIfNotExists(); // 🔹 로그인 후 Firestore 등록

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
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _registerUser(); // 🔹 회원가입 시 Firestore 등록

      _goNext(context);
    } on FirebaseAuthException catch (e) {
      message = e.code == 'email-already-in-use'
          ? '이미 사용 중인 이메일입니다'
          : '회원가입 실패: ${e.message ?? e.code}';
      notifyListeners();
    }
  }

  /// 🔹 Firestore에 유저 등록 (회원가입 시)
  Future<void> _registerUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🔹 Firestore에 유저 미존재 시 등록 (로그인 시)
  Future<void> _registerUserIfNotExists() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = _firestore.collection('users').doc(user.uid);
      final snapshot = await doc.get();
      if (!snapshot.exists) {
        await _registerUser();
      }
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
