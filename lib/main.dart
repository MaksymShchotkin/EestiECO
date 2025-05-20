import 'package:flutter/material.dart';
import 'package:eesti_eco/map_screen.dart'; // make sure path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estonia Map Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EstoniaMapScreen(),
    );
  }
}
