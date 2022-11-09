import 'package:flutter/material.dart';
import 'package:praclog/ui/auth/auth_texts.dart';
import 'package:praclog/ui/auth/widgets/auth_scaffold.dart';
import 'package:praclog/ui/auth/widgets/auth_textfield.dart';
import 'package:praclog/ui/widgets/main_button.dart';

class ReAuthScreen extends StatefulWidget {
  const ReAuthScreen({Key? key}) : super(key: key);

  @override
  State<ReAuthScreen> createState() => _ReAuthScreenState();
}

class _ReAuthScreenState extends State<ReAuthScreen> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Please enter your password:'),
            const SizedBox(height: 20.0),
            AuthTextField(
              controller: _controller,
              errorMessage: blankPasswordErrorMsg,
              hintText: passwordLoginHint,
              obscureText: true,
            ),
            MainButton(
              text: 'Delete account',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, _controller.text.trim());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
