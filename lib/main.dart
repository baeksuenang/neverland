import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:neverlandv1/providers/auth_provider.dart' as my_provider;
import 'screens/push_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/push_morning.dart';
import 'screens/SleepLockScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'app_lifecycle_observer.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLocked = prefs.getBool('isLocked') ?? false;

  WidgetsBinding.instance.addObserver(AppLifecycleObserver(navigatorKey));

  runApp(NeverlandApp(isLocked: isLocked));
}

class NeverlandApp extends StatelessWidget {
  final bool isLocked;

  const NeverlandApp({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => my_provider.AuthProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Neverland App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: RootController(forceSleepLock: isLocked),
      ),
    );
  }
}

class RootController extends StatelessWidget {
  final bool? forceSleepLock;
  const RootController({super.key, this.forceSleepLock});

  Future<String> _checkSleepOrWakeStatus(String teamId, String userId) async {
    final now = DateTime.now();
    final doc = await FirebaseFirestore.instance.collection('groups').doc(teamId).get();
    final data = doc.data();

    if (data == null || !data.containsKey('sleepTime') || !data.containsKey('wakeTime')) {
      return 'none';
    }

    final sleepHour = data['sleepTime']['hour'];
    final sleepMinute = data['sleepTime']['minute'];
    final wakeHour = data['wakeTime']['hour'];
    final wakeMinute = data['wakeTime']['minute'];

    final today = DateTime(now.year, now.month, now.day);
    final sleepTime = today.add(Duration(hours: sleepHour, minutes: sleepMinute));
    final wakeTime = today.add(Duration(hours: wakeHour, minutes: wakeMinute));
    final preSleepStart = sleepTime.subtract(const Duration(hours: 2));
    final postWakeEnd = wakeTime.add(const Duration(hours: 2));

    final prefs = await SharedPreferences.getInstance();
    final dbRef = FirebaseDatabase.instance.ref();

    // wake 상태
    if (now.isAfter(wakeTime) && now.isBefore(postWakeEnd)) {
      return 'wake';
    }

    // 상태 초기화는 여기서 하지 않음 → 앱 시작 시에 한 번만 관리 (RootController에서 수행하지 않음)
    // 수면 시간대
    if (now.isAfter(sleepTime) && now.isBefore(wakeTime)) {
      final userStatusSnapshot = await dbRef.child('teamStatus/$teamId/members/$userId').get();
      if (userStatusSnapshot.value != 'sleeping') {
        await dbRef.child('teamStatus/$teamId/members/$userId').set('sleeping');
      }
      await prefs.setBool('isLocked', true);
      return 'sleep';
    }

    // 수면 준비 시간
    if (now.isAfter(preSleepStart) && now.isBefore(sleepTime)) {
      return 'prepareToSleep';
    }

    // 기상 2시간 이후이거나 취침 2시간 전 이전인 경우에만 상태 초기화
    if (now.isBefore(preSleepStart) || now.isAfter(postWakeEnd)) {
      // 단, 현재 유저 상태가 none이 아닌 경우에만
      final userSnapshot = await dbRef.child('teamStatus/$teamId/members/$userId').get();
      if (userSnapshot.exists && userSnapshot.value != 'none') {
        await dbRef.child('teamStatus/$teamId/members/$userId').set('none');
        await prefs.setBool('isLocked', false);
      }
    }

    return 'none';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const IntroScreen();
    }

    final userId = currentUser.uid;

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('groups')
          .where('members', arrayContains: userId)
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
          );
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const IntroScreen();

        final teamId = docs.first.id;

        return FutureBuilder(
          future: _checkSleepOrWakeStatus(teamId, userId),
          builder: (context, snapshot2) {
            if (!snapshot2.hasData) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
              );
            }

            final status = snapshot2.data!;

            if (forceSleepLock == true && status != 'wake') {
              return const SleepLockScreen();
            }

            if (status == 'sleep') {
              return const SleepLockScreen();
            }

            if (status == 'wake') {
              return PushMorningScreen(teamId: teamId, userId: userId);
            }

            if (status == 'prepareToSleep') {
              return PushScreen(teamId: teamId, userId: userId);
            }

            return const IntroScreen();
          },
        );
      },
    );
  }
}
