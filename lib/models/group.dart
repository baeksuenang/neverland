class Group {
  final String id;
  final String name;
  final String inviteCode;
  final String leaderUid;
  final List<Member> members;

  Group({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.leaderUid,
    required this.members,
  });
}

class Member {
  final String uid;
  final String nickname;
  final String status; // 'active', 'pending', 'sleeping', etc.

  Member({
    required this.uid,
    required this.nickname,
    required this.status,
  });
}
