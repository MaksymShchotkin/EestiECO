import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
