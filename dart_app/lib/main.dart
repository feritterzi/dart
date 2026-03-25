import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DartApp());
}

class DartApp extends StatelessWidget {
  const DartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kutup Dart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}