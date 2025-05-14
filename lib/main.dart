import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
<<<<<<< HEAD
import 'screens/intro_screen.dart';
=======
import 'screens/login_screen.dart';
import 'screens/group_screen.dart'; // 그룹 화면
>>>>>>> 9d4d424583149ba99b24415d18565d4891626572

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
<<<<<<< HEAD
        home: const IntroScreen(), // 여기 IntroScreen으로 변경
      ),
    );
  }
}
=======
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/group_create': (context) => const GroupScreen(),
        },
      ),
    );
  }
}
>>>>>>> 9d4d424583149ba99b24415d18565d4891626572
