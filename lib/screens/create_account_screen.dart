import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();
  String errorMessage = '';

  void _register() async {
    try {
      await _authService.register(emailController.text, passwordController.text);
      Navigator.pushReplacementNamed(context, '/map');
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message ?? 'Registration failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFE6),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.appTitle,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.green),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.email, filled: true, fillColor: Colors.grey[200]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: AppLocalizations.of(context)!.password, filled: true, fillColor: Colors.grey[200]),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _register, child: Text(AppLocalizations.of(context)!.createAccount)),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
