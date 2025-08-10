import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/home.dart';

void main() {
  runApp(SkillConnectApp());
}

class SkillConnectApp extends StatelessWidget {
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
      // Start with login screen instead of home
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
        //'/job-posting': (context) => JobPostingPage(),
        //'/worker-profile': (context) => WorkerProfilePage(),
        //'/chat': (context) => ChatPage(),
        //'/job-tracking': (context) => JobTrackingPage(),
      },
    );
  }
}
