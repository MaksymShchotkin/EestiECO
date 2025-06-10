import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFE6),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App name
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

              // Status text
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

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CC66), // green
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Log in'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CC66), // same green
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/create'),
                  child: const Text('Create an account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
