import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'call_screen.dart';

class PushMorningScreen extends StatefulWidget {
  final String teamId;
  final String userId;

  const PushMorningScreen({
    super.key,
    required this.teamId,
    required this.userId,
  });

  @override
  State<PushMorningScreen> createState() => _PushMorningScreenState();
}

class _PushMorningScreenState extends State<PushMorningScreen> {
  late DatabaseReference membersRef;
  Map<String, dynamic> memberStates = {};
  bool alreadyAwake = false;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    membersRef = FirebaseDatabase.instance
        .ref('teamStatus/${widget.teamId}/members');

    membersRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        setState(() {
          memberStates = Map<String, dynamic>.from(data);
          alreadyAwake = memberStates[widget.userId] == 'awake';
        });
      }
    });
  }

  Future<void> _wakeUp() async {
    if (alreadyAwake) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이미 기상한 상태입니다.")),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref();

    await dbRef
        .child('teamStatus/${widget.teamId}/members/${widget.userId}')
        .set('awake');

    final snapshot =
    await dbRef.child('teamStatus/${widget.teamId}/members').get();
    final members = snapshot.value as Map?;

    bool allAwake = members?.values.every((v) => v == 'awake') ?? false;

    if (allAwake) {
      await dbRef.child('teamStatus/${widget.teamId}/isEveryoneAwake').set(true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLocked', false);
    }

    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final allAwake =
        memberStates.isNotEmpty && memberStates.values.every((v) => v == 'awake');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            _buildMainContent(context, allAwake),
            const CallScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool allAwake) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(child: Image.asset('assets/z.png', height: 60)),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.tealAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.black, size: 20),
              onPressed: () {},
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/morning.png',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                '팀원 상태',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: memberStates.entries.map((entry) {
                    final status = entry.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == 'awake'
                                ? Colors.tealAccent
                                : Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _wakeUp,
                child: Image.asset('assets/push.png', width: 200),
              ),
              const SizedBox(height: 20),
              if (allAwake)
                const Text(
                  '🎉 모든 팀원이 기상했어요! 🎉',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 16),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(isActive: _currentPage == 0),
                  const SizedBox(width: 8),
                  _dot(isActive: _currentPage == 1),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot({required bool isActive}) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.tealAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
