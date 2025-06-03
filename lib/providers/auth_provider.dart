import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/group/add_teammates_screen.dart';
import '../screens/main_screen.dart';
import '../screens/position_selection_screen.dart';
import '../screens/push_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await _registerUserIfNotExists(); // Firestore에 users 등록
      await _checkGroupAndNavigate(context); // 그룹 여부 확인 후 이동

    } on FirebaseAuthException catch (e) {
      message = '로그인 실패: ${e.message ?? e.code}';
      notifyListeners();
    }
  }

  Future<void> _checkGroupAndNavigate(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final groups = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContains: uid)
        .limit(1)
        .get();

    if (groups.docs.isNotEmpty) {
      final doc = groups.docs.first;
      final teamId = doc.id;
      final userId = FirebaseAuth.instance.currentUser!.uid;

      // ✅ teamStatus 초기화 여부 확인
      final data = doc.data();
      final initialized = data['teamStatusInitialized'] == true;

      if (!initialized) {
        await initTeamStatus(teamId);
        // ✅ Firestore에 초기화 플래그 true로 저장
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(teamId)
            .update({'teamStatusInitialized': true});
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PushScreen(teamId: teamId, userId: userId),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PositionSelectionScreen()),
      );
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

Future<void> initTeamStatus(String teamId) async {
  final firestore = FirebaseFirestore.instance;
  final rtdbRef = FirebaseDatabase.instance.ref();

  try {
    // Firestore에서 팀 멤버 목록 가져오기
    final teamDoc = await firestore.collection('groups').doc(teamId).get();
    final members = List<String>.from(teamDoc['members']);

    // Realtime Database에 상태 초기화
    for (final uid in members) {
      await rtdbRef.child('teamStatus/$teamId/members/$uid').set('none');
    }

    print('✅ teamStatus 초기화 완료');
  } catch (e) {
    print('🔥 teamStatus 초기화 실패: $e');
  }
}