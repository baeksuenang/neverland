// sleep_lock_screen.dart
import 'package:flutter/material.dart';

class SleepLockScreen extends StatefulWidget {
  const SleepLockScreen({super.key});

  @override
  State<SleepLockScreen> createState() => _SleepLockScreenState();
}

class _SleepLockScreenState extends State<SleepLockScreen> with WidgetsBindingObserver {
  bool isLocked = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        isLocked = true; // 다시 앱으로 돌아오면 잠금상태 유지
      });
    }
  }

  void _unlock() {
    setState(() {
      isLocked = false;
    });
    Navigator.pop(context); // 이전 화면으로 되돌아감
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: isLocked
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '잠금 상태입니다',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _unlock,
              child: const Text('기상하기'),
            ),
          ],
        )
            : const SizedBox(),
      ),
    );
  }
}
