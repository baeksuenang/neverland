import 'dart:math';
import 'package:flutter/material.dart';

class AddTeammatesScreen extends StatefulWidget {
  const AddTeammatesScreen({super.key});

  @override
  State<AddTeammatesScreen> createState() => _AddTeammatesScreenState();
}

class _AddTeammatesScreenState extends State<AddTeammatesScreen> {
  final TextEditingController _idController = TextEditingController();
  final Map<String, String> _profileMap = {};
  final List<String> _addedIds = [];
  final Random _random = Random();

  void _onConfirm() {
    final id = _idController.text.trim();

    if (id.isNotEmpty && !_addedIds.contains(id)) {
      _profileMap.putIfAbsent(id, () {
        int idx = _random.nextInt(4) + 1; // 1 ~ 4 중 하나
        return 'assets/people$idx.png';   // PNG 경로로 수정
      });

      setState(() {
        _addedIds.add(id);
        _idController.clear();
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
              ..._addedIds.map((id) => Container(
                decoration: shadowStyle,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        _profileMap[id]!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        id,
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}
