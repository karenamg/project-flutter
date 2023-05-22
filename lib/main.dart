import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'models/infoscreen.dart';
import 'models/principalscreen.dart';
import 'models/singinscreen.dart';
import 'models/singupscreen.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // The route that the app will start on.
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/info': (context) => InfoScreen(),
        '/principal': (context) => PrincipalScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Bienvenido a Konie'),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
          // About button
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child: IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.pushNamed(context, '/info');
              },
            ),
          ),
        ],
      ),
    );
  }
}
