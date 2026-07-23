import 'package:flutter/material.dart';
import 'package:flutter_starter/models/interview_session.dart';
import 'package:flutter_starter/screens/home_screen.dart';
import 'package:flutter_starter/screens/interview_screen.dart';
import 'package:flutter_starter/screens/dashboard_screen.dart';

void main() {
  runApp(const PrepAIApp());
}

class PrepAIApp extends StatefulWidget {
  const PrepAIApp({super.key});

  @override
  State<PrepAIApp> createState() => _PrepAIAppState();
}

class _PrepAIAppState extends State<PrepAIApp> {
  final InterviewSession _session = InterviewSession();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrepAI Interviewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5), // Indigo base
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(session: _session),
        '/interview': (context) => InterviewScreen(session: _session),
        '/dashboard': (context) => DashboardScreen(session: _session),
      },
    );
  }
}
