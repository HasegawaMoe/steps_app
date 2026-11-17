import 'package:flutter/material.dart';
import 'package:steps_app/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '歩数アプリ',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
        // textTheme: TextTheme(bodyMedium: TextStyle(color: Color.fromRGBO(70, 75, 70, 1)))
        ),
      home: const MainScreen(),
    );
  }
}
