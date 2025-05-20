import 'package:flutter/material.dart';

void main() {
  runApp(const EestiEcoApp());
}

class EestiEcoApp extends StatelessWidget {
  const EestiEcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EestiECO',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/create': (context) => const CreateAccountScreen(),
        '/map': (context) => EstoniaMapScreen(), // already created
      },
    );
  }
}
