import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // flutterfire configure가 만든 파일
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/group/group_create_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        theme: ThemeData(primarySwatch: Colors.blue),
        home: GroupCreateScreen(),
      ),
    );
  }
}

