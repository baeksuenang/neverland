import 'package:flutter/material.dart';
import '../../utils/invite_code_generator.dart';


class GroupCreateScreen extends StatefulWidget {
  @override
  _GroupCreateScreenState createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  String _inviteCode = '';

  @override
  void initState() {
    super.initState();
    _inviteCode = generateInviteCode(); // util 함수로 코드 생성
  }

  void _createGroup() {
    // 그룹 생성 로직 예: Firebase에 저장 + 유저를 팀장으로 등록
    final groupName = _groupNameController.text.trim();
    if (groupName.isEmpty) return;

    // 이후 group_service.dart에서 Firebase에 저장하도록 처리
    // ex) GroupService.createGroup(...)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('그룹이 생성되었습니다. 당신은 팀장입니다.')),
    );

    // 다음 화면 이동 or 종료
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("그룹 생성")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _groupNameController, decoration: InputDecoration(labelText: '그룹 이름')),
            SizedBox(height: 12),
            Text('초대코드: $_inviteCode'),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _createGroup, child: Text('그룹 생성하기'))
          ],
        ),
      ),
    );
  }
}
