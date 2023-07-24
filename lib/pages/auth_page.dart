import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emotion_gram/pages/home_screen.dart';
// import 'package:emotion_gram/pages/login_screen.dart';

import 'login_or_register_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage(
      {Key? key}); // Corrected the syntax for the constructor parameter.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User logged in
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
