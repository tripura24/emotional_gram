import 'package:emotion_gram/componets/my_button.dart';
import 'package:emotion_gram/componets/my_textfield.dart';
import 'package:emotion_gram/componets/square_tile.dart';
import 'package:emotion_gram/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // check if password is confirmed
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        //error message
        showErrorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }

    // pop the loading circle
    Navigator.pop(context);
  }

  // show error message
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
        );
      },
    );
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("INCORRECT EMAIL"),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("INCORRECT PASSWORD"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/w.jpg', // Replace with your image path
              ),
              const SizedBox(height: 5.0),
              const Text(
                'Welcome to emotionalgram!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 25.0),
              MYTextfield(
                controller: emailController,
                hintText: "Email",
                obsecureText: false,
              ),

              const SizedBox(height: 16.0),

              MYTextfield(
                controller: passwordController,
                hintText: "PASSWORD",
                obsecureText: true,
              ),

              const SizedBox(height: 16.0),

              //confirm password
              MYTextfield(
                controller: confirmpasswordController,
                hintText: "CONFIRM PASSWORD",
                obsecureText: true,
              ),

              const SizedBox(height: 10.0),
              MyButton(
                onTap: signUserUp,
                text: 'Sign Up',
              ),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Or continue with "),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagepath: "assets/images/google.png"),
                  const SizedBox(
                    width: 10,
                  ),
                  SquareTile(
                      onTap: () {}, imagepath: "assets/images/apple.png"),
                ],
              ),
              const SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "LOGIN now",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
