// sleep_time_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import '../push_screen.dart';

class SleepTimeScreen extends StatefulWidget {
  final String groupId;

  const SleepTimeScreen({super.key, required this.groupId});

  @override
  State<SleepTimeScreen> createState() => _SleepTimeScreenState();
}


class _SleepTimeScreenState extends State<SleepTimeScreen> {
  int? sleepHour, sleepMinute;
  int? wakeHour, wakeMinute;

  Future<void> _selectNumber({
    required int max,
    required Function(int) onSelected,
  }) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (_) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: max,
            itemBuilder: (_, index) {
              return ListTile(
                title: Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 24),
                  ),
                ),
                onTap: () {
                  onSelected(index);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeSlot({
    required int? hour,
    required int? minute,
    required Function() onTapHour,
    required Function() onTapMinute,
    required String iconPath,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: 40),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: onTapHour,
          child: _timeBox(hour),
        ),
        const SizedBox(width: 8),
        const Text(':', style: TextStyle(color: Colors.tealAccent, fontSize: 28)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTapMinute,
          child: _timeBox(minute),
        ),
      ],
    );
  }

  Widget _timeBox(int? number) {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.tealAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        number != null ? number.toString().padLeft(2, '0') : '__',
        style: const TextStyle(color: Colors.tealAccent, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(child: Image.asset('assets/neverland.png', height: 60)),
              const SizedBox(height: 30),
              const Text(
                'decide your trip time',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              _buildTimeSlot(
                hour: sleepHour,
                minute: sleepMinute,
                iconPath: 'assets/Moon.png',
                onTapHour: () => _selectNumber(max: 24, onSelected: (val) => setState(() => sleepHour = val)),
                onTapMinute: () => _selectNumber(max: 60, onSelected: (val) => setState(() => sleepMinute = val)),
              ),
              const SizedBox(height: 30),
              _buildTimeSlot(
                hour: wakeHour,
                minute: wakeMinute,
                iconPath: 'assets/Sun.png',
                onTapHour: () => _selectNumber(max: 24, onSelected: (val) => setState(() => wakeHour = val)),
                onTapMinute: () => _selectNumber(max: 60, onSelected: (val) => setState(() => wakeMinute = val)),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (sleepHour == null || sleepMinute == null || wakeHour == null || wakeMinute == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('모든 시간을 설정해주세요.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('groups')
                          .doc(widget.groupId)
                          .update({
                        'sleepTime': {
                          'hour': sleepHour,
                          'minute': sleepMinute,
                        },
                        'wakeTime': {
                          'hour': wakeHour,
                          'minute': wakeMinute,
                        }
                      });

                      // 저장 성공 후 다음 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PushScreen(
                            teamId: widget.groupId,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('오류 발생: $e'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },


                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
