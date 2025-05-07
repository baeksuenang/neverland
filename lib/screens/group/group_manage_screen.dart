class GroupManageScreen extends StatelessWidget {
  final Group group;

  GroupManageScreen({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("그룹 관리")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: group.members.length,
              itemBuilder: (context, index) {
                final member = group.members[index];
                return MemberTile(
                  member: member,
                  onExpel: () {
                    // 1일 1회 제한 등 로직 추가 가능
                    print('${member.nickname} 추방');
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // 그룹 규칙 설정 화면으로 이동
            },
            child: Text("그룹 규칙 설정"),
          ),
        ],
      ),
    );
  }
}
