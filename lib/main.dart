import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/home.dart';
import 'pages/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(SkillConnectApp());
}

class SkillConnectApp extends StatelessWidget {
  const SkillConnectApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillConnect',
      theme: ThemeData(
        // SkillConnect Color Scheme
        primaryColor: Color(0xFF304D6D),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF304D6D),
          secondary: Color(0xFF63ADF2),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
        '/services': (context) => SelectService(),
        //'/job-posting': (context) => JobPostingPage(),
        //'/worker-profile': (context) => WorkerProfilePage(),
        //'/chat': (context) => ChatPage(),
        //'/job-tracking': (context) => JobTrackingPage(),
      },
    );
  }
}
