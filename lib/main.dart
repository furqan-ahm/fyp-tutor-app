
import 'package:flutter/material.dart';
import 'package:tutor_app/models/user.dart';
import 'package:tutor_app/screens/auth/sign_in_screen.dart';
import 'package:tutor_app/screens/getting_started/education_level_screen.dart';
import 'package:tutor_app/screens/tutor/tutor_dashboard_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorUs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TutorDashboardScreen(),
    );
  }
}
