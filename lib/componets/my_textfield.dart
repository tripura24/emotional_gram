import 'package:flutter/material.dart';

class MYTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;

  const MYTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
