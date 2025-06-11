import 'package:flutter/material.dart';
import '../utils/lock_helper.dart'; // 실제 경로에 맞게 수정

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

    // ✅ 앱이 잠금 화면에 들어오면 즉시 폰 잠금 시도
    LockHelper.lockPhone();
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
        isLocked = true; // 앱 복귀 시 잠금 유지
        LockHelper.lockPhone(); // 복귀 시에도 다시 잠금 시도
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock, size: 80, color: Colors.tealAccent),
            SizedBox(height: 20),
            Text(
              '현재 잠금 상태입니다',
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              '기상 버튼을 눌러야 해제됩니다',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
