import 'package:flutter/material.dart';
import 'package:praclog/ui/constants.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String errorMessage;
  final String hintText;
  final bool obscureText;
  final bool emailMode;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.errorMessage,
    required this.hintText,
    this.obscureText = false,
    this.emailMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: emailMode ? TextInputType.emailAddress : null,
        decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: customBorderRadius,
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(borderRadius: customBorderRadius)),
        validator: (input) {
          if (input == null || input.isEmpty) {
            return errorMessage;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
