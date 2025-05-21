import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddTeammatesScreen extends StatefulWidget {
  const AddTeammatesScreen({super.key});

  @override
  State<AddTeammatesScreen> createState() => _AddTeammatesScreenState();
}

class _AddTeammatesScreenState extends State<AddTeammatesScreen> {
  final TextEditingController _idController = TextEditingController();
  String? _foundId;

  // ID → 이미지 경로 매핑
  final Map<String, String> _profileMap = {};
  final Random _random = Random();

  void _onConfirm() {
    final id = _idController.text.trim();

    if (id.isNotEmpty) {
      // ID에 아직 프로필이 없으면 랜덤으로 하나 배정
      _profileMap.putIfAbsent(id, () {
        int idx = _random.nextInt(4) + 1; // 1~4
        return 'assets/people$idx.png';
      });

      setState(() {
        _foundId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadowStyle = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.tealAccent,
          offset: const Offset(2, 2),
          blurRadius: 0,
          spreadRadius: 1.5,
        ),
      ],
    );

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
              const SizedBox(height: 20),

              // 가운데 Confirm 버튼
              Center(
                child: ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Confirm', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 30),

              // 팀원 카드
              if (_foundId != null) ...[
                Container(
                  decoration: shadowStyle,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SvgPicture.asset(
                          _profileMap[_foundId]!, // ID별로 고정된 프로필
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _foundId!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Text(
                        '+',
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
