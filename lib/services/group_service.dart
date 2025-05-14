// lib/services/group_service.dart
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  static final _firestore = FirebaseFirestore.instance;

  static String generateGroupCode({int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  static Future<String?> createGroup(String groupName) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || groupName.isEmpty) return null;

    final code = generateGroupCode();

    await _firestore.collection('groups').doc(code).set({
      'name': groupName,
      'leaderUid': uid,
      'memberUids': [uid],
      'createdAt': Timestamp.now(),
    });

    return code;
  }

  static Future<String> joinGroup(String code) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || code.isEmpty) return '로그인 필요 또는 코드 누락';

    final doc = await _firestore.collection('groups').doc(code).get();
    if (!doc.exists) return '그룹이 존재하지 않습니다.';

    final members = List<String>.from(doc['memberUids']);
    if (!members.contains(uid)) {
      members.add(uid);
      await doc.reference.update({'memberUids': members});
    }

    return '그룹 참여 완료!';
  }
}
