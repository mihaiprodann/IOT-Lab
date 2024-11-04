// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: WelcomeRoute()));
}

class WelcomeRoute extends StatelessWidget {
  const WelcomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    // create a welcome screen
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: const Center(
        child: 
         Text('Welcome to the app!'),
      ),
    );
  }
}