import 'package:flutter/material.dart';
import 'package:neverlandv1/models/group.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  final VoidCallback onExpel;

  MemberTile({required this.member, required this.onExpel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member.nickname),
      subtitle: Text('상태: ${member.status}'),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle, color: Colors.red),
        onPressed: onExpel,
      ),
    );
  }
}
