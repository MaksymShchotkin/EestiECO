import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFE6),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'EestiECO',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'As of today:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '4',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('monitors online'),
            const SizedBox(height: 8),
            const Text(
              '10',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('fresh measurements'),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('Log in'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create'),
              child: const Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
