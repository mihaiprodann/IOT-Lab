// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: FirstRoute()));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('Welcome to Home Screen'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(224, 0, 183, 255),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(30.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginRoute()),
                );
              },
              child: const Text('Go to login screen')
            ),
            Expanded(
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1,
                ),
                children: [
                  Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text('First', style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                  ),
                  Container(
                    color: Colors.orange,
                    child: const Center(
                      child: Text('Second', style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                  ),
                  Container(
                    color: Colors.yellow,
                    child: const Center(
                      child: Text('Third', style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                  ),
                  Container(
                    color: Colors.green,
                    child: const Center(
                      child: Text('Fourth', style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                  ),
                  Container(
                    color: Colors.blue,
                    child: const Center(
                      child: Text('Fifth', style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                  ),
                  Container(
                    color: Colors.purple,
                    child: const Center(
                      child: Text('Sixth', style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(225, 219, 0, 115)
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondRoute()),
                );
              },
              child: const Text('Second Route'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginRoute extends StatelessWidget {
  LoginRoute({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('Welcome to Login Screen'),
            const Padding(
              padding: EdgeInsets.all(10.0)
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(224, 0, 183, 255),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                padding: const EdgeInsets.all(30.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go back to Home Screen')
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10.0)
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0)
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0)
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(224, 0, 183, 255),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(30.0),
                    ),
                    onPressed: () async {
                      // Register functionality
                      try {
                        final email = emailController.text;
                        final password = passwordController.text;
                        if (!email.contains("@")) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text('Please enter a valid email address.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Success'),
                            content: const Text('You have registered successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        String message;
                        if (e.code == 'weak-password') {
                          message = 'The password provided is too weak.';
                        } else if (e.code == 'email-already-in-use') {
                          message = 'The account already exists for that email.';
                        } else {
                          print(e.code);
                          message = 'Registration failed. Please try again. Error code: ${e.code}';
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text(message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0)
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(224, 0, 183, 255),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(30.0),
                    ),
                    onPressed: () async {
                      // Login functionality
                      final email = emailController.text;
                      final password = passwordController.text;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomePage(email: email)),
                        );
                      } on FirebaseAuthException catch (e) {
                        String message;
                        if (e.code == 'invalid-credential') {
                          message = 'Wrong email password combination, please try again.';
                        } else {
                          message = 'Login failed. Please try again. (Debug: ${e.code})';
                        }
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text(message),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String email;

  const WelcomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Text('Hello, $email', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Screen'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Text field',
              ),
            ),
            Image.network(
              'https://i.imgur.com/S8W6RFy.jpeg',
              width: 500,
              height: 300,
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: 300,
                  height: 300,
                  color: Colors.pinkAccent,
                  child: const Center(
                    child: Text(
                      'Top Widget',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 120,
                    height: 40,
                    color: Colors.orange,
                    child: const Center(
                      child: Text(
                        'Bottom Widget',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 120,
                  top: 0,
                  child: Container(
                    width: 120,
                    height: 40,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'Middle Widget',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.pink,
                  ),
                  child: const Text('Row 1', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: const Text('Row 2', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.purple,
                  ),
                  child: const Text('Row 3', style: TextStyle(color: Colors.white, fontSize: 20)),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
