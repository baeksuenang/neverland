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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLocked = prefs.getBool('isLocked') ?? false;

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
        title: 'Neverland App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: RootController(isLocked: isLocked),
      ),
    );
  }
}

class RootController extends StatelessWidget {
  final bool isLocked;
  const RootController({super.key, required this.isLocked});

  Future<String> _checkSleepOrWakeStatus(String teamId) async {
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

    if (now.isAfter(sleepTime) && now.isBefore(wakeTime)) {
      return 'sleep';
    } else if (now.isAfter(wakeTime)) {
      return 'wake';
    } else {
      return 'none';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const IntroScreen(); // 로그인 전
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
          future: _checkSleepOrWakeStatus(teamId),
          builder: (context, snapshot2) {
            if (!snapshot2.hasData) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
              );
            }

            final status = snapshot2.data!;
            if (status == 'sleep' && !isLocked) {
              // 자동으로 잠금 처리
              final dbRef = FirebaseDatabase.instance.ref();
              dbRef.child('teamStatus/$teamId/members/$userId').set('sleeping');
              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool('isLocked', true);
              });
              Future.delayed(Duration.zero, () => SystemNavigator.pop());
              return const SizedBox(); // pop() 이후 반환용
            }

            if (status == 'wake' || isLocked) {
              return PushMorningScreen(teamId: teamId, userId: userId);
            }

            return PushScreen(teamId: teamId, userId: userId);
          },
        );
      },
    );
  }
}
