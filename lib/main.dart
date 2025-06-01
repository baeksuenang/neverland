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
        home: isLocked ? const SleepLockScreen() : const RootController(forceSleepLock: null),
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

    final prefs = await SharedPreferences.getInstance();
    final dbRef = FirebaseDatabase.instance.ref();

    // wake 상태
    if (now.isAfter(wakeTime) && now.isBefore(wakeTime.add(const Duration(hours: 2)))) {
      return 'wake';
    }

    // wake 상태 종료 (2시간 경과) → 상태 초기화
    if (now.isAfter(wakeTime.add(const Duration(hours: 2))) &&
        now.isBefore(sleepTime.subtract(const Duration(hours: 2)))){
      final membersSnapshot = await dbRef.child('teamStatus/$teamId/members').get();
      if (membersSnapshot.exists) {
        final members = (membersSnapshot.value as Map).keys;
        for (var uid in members) {
          await dbRef.child('teamStatus/$teamId/members/$uid').set('none');
        }
        await dbRef.child('teamStatus/$teamId/isEveryoneAwake').set(false);
        await prefs.setBool('isLocked', false);
      }
      return 'none';
    }

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

            if (forceSleepLock == true || status == 'sleep') {
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
