import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neverlandv1/screens/sleeptime/sleep_time_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/push_screen.dart';
import 'screens/intro_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NeverlandApp());
}

class NeverlandApp extends StatelessWidget {
  const NeverlandApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Neverland App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const IntroScreen(),


        // ✅ 여기에 route 등록!
        routes: {
          '/push': (context) => const PushScreen(),
        },
      ),
    );
  }
}

