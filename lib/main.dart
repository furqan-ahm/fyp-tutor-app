import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/models/user_model.dart';
import 'package:tutor_app/providers/auth_provider.dart';
import 'package:tutor_app/providers/session_provider.dart';
import 'package:tutor_app/providers/tutorship_provider.dart';
import 'package:tutor_app/providers/user_state_provider.dart';
import 'package:tutor_app/screens/auth/sign_in_screen.dart';
import 'package:tutor_app/screens/getting_started/education_level_screen.dart';
import 'package:tutor_app/screens/tutor/tutor_dashboard_screen.dart';

import 'firebase_options.dart';
import 'screens/student/student_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<UserStateProvider>(
          create: (context) => UserStateProvider(),
        ),
        ChangeNotifierProvider<TutorshipProvider>(
          create: (context) => TutorshipProvider(),
        ),
        ChangeNotifierProvider<SessionProvider>(
          create: (context) => SessionProvider(), lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'TutorUs',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInScreen(),
      ),
    );
  }
}
