import 'package:flutter/material.dart';
import 'Gemini/mock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'cv',
      ),
      home: const MockBot(),
    );
  }
}
