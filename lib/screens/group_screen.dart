// lib/screens/group_screen.dart
import 'package:flutter/material.dart';
import '../services/group_service.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _joinCodeController = TextEditingController();
  String statusMessage = '';

  Future<void> handleCreateGroup() async {
    final groupName = _groupNameController.text.trim();
    final code = await GroupService.createGroup(groupName);

    setState(() {
      statusMessage = code == null
          ? '그룹 생성 실패 (이름 확인 혹은 로그인 필요)'
          : '그룹 생성 성공! 초대 코드: $code';
    });
  }

  Future<void> handleJoinGroup() async {
    final code = _joinCodeController.text.trim();
    final result = await GroupService.joinGroup(code);

    setState(() {
      statusMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('그룹 관리')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('그룹 생성', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _groupNameController, decoration: const InputDecoration(labelText: '그룹 이름')),
            ElevatedButton(onPressed: handleCreateGroup, child: const Text('그룹 생성')),
            const Divider(height: 40),
            const Text('초대 코드로 참여', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _joinCodeController, decoration: const InputDecoration(labelText: '초대 코드')),
            ElevatedButton(onPressed: handleJoinGroup, child: const Text('그룹 참여')),
            const SizedBox(height: 20),
            Text(statusMessage),
          ],
        ),
      ),
    );
  }
}
