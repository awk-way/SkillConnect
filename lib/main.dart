import 'package:flutter/material.dart';
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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        //'/jobs': (context) => JobPostingPage(),
        //'/worker-profile': (context) => WorkerProfilePage(),
        //'/chat': (context) => ChatPage(),
        //'/job-tracking': (context) => JobTrackingPage(),
      },
    );
  }
}
