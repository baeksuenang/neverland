import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../sleeptime/sleep_time_screen.dart';

class AddTeammatesScreen extends StatefulWidget {
  const AddTeammatesScreen({super.key});

  @override
  State<AddTeammatesScreen> createState() => _AddTeammatesScreenState();
}

class _AddTeammatesScreenState extends State<AddTeammatesScreen> {
  final TextEditingController _idController = TextEditingController();
  String? _searchResultId;
  final List<String> _addedIds = [];
  String? _selectedToRemove;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _getProfileImage(String id) {
    final idx = (id.hashCode.abs() % 4) + 1;
    return 'assets/people$idx.png';
  }

  Future<void> _search() async {
    final input = _idController.text.trim();
    if (input.isEmpty || _addedIds.contains(input) || _addedIds.length >= 3) return;

    try {
      final doc = await _firestore.collection('users').doc(input).get();

      if (doc.exists) {
        setState(() {
          _searchResultId = input;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('해당 ID는 존재하지 않습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 중 오류 발생: $e')),
      );
    }
  }

  void _addMember(String id) {
    if (_addedIds.contains(id) || _addedIds.length >= 3) return;
    setState(() {
      _addedIds.add(id);
      _searchResultId = null;
      _idController.clear();
    });
  }

  void _toggleRemoveMode(String id) {
    setState(() {
      _selectedToRemove = _selectedToRemove == id ? null : id;
    });
  }

  void _removeMember(String id) {
    setState(() {
      _addedIds.remove(id);
      if (_selectedToRemove == id) {
        _selectedToRemove = null;
      }
    });
  }

  Future<void> _onFinish() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    final List<String> members = [currentUser.uid, ..._addedIds];

    final groupData = {
      'leaderId': currentUser.uid,
      'members': members,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final groupRef = await _firestore.collection('groups').add(groupData);
      final groupId = groupRef.id;



      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SleepTimeScreen(groupId: groupId),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('팀이 성공적으로 저장되었습니다!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(child: Image.asset('assets/neverland.png', height: 60)),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Add your tripmates',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _idController,
                onSubmitted: (_) => _search(),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Write ID',
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 팀원 프로필 박스
              if (_addedIds.isNotEmpty)
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _addedIds.map((id) {
                        final isSelected = _selectedToRemove == id;
                        return GestureDetector(
                          onTap: () => _toggleRemoveMode(id),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: ClipOval(
                                  child: Image.asset(
                                    _getProfileImage(id),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeMember(id),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              // 검색 결과
              if (_searchResultId != null &&
                  !_addedIds.contains(_searchResultId) &&
                  _addedIds.length < 3)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          _getProfileImage(_searchResultId!),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _searchResultId!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addMember(_searchResultId!),
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Finish 버튼
              if (_addedIds.length == 3)
                ElevatedButton(
                  onPressed: _onFinish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(140, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Finish',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
