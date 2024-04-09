import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:api/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLASSROOM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 61, 58, 61),
          
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      // home: const PinLoginPage(),
      home: HomePage(),
    );
  }
}
