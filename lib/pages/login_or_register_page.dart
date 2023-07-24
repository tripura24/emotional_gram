import 'package:flutter/material.dart';
import 'package:emotion_gram/pages/login_screen.dart';
import 'package:emotion_gram/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initially show login page
  bool showLoginScreen = true;

  //toggle between login page and register page
  void togglepage() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(
        onTap: togglepage,
      );
    } else {
      return RegisterPage(
        onTap:togglepage ,
      );
    }
  }
}
