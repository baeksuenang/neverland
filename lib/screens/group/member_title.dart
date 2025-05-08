import 'package:flutter/material.dart';
import 'package:neverlandv1/models/group.dart';

class MemberTitle extends StatelessWidget {
  final Member member;
  final VoidCallback onExpel;

  const MemberTitle({
    required this.member,
    required this.onExpel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member.nickname),
      subtitle: Text("상태: ${member.status}"),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle_outline),
        onPressed: onExpel,
      ),
    );
  }
}
