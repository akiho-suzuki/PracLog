import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/ui/auth/auth_texts.dart';
import 'package:praclog/ui/auth/widgets/auth_scaffold.dart';
import 'package:praclog/ui/auth/widgets/auth_textfield.dart';
import 'package:praclog/ui/utils/show_snackbar.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  late bool _loading;

  @override
  void initState() {
    _loading = false;
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      String email = _controller.text.trim();
      bool validated = EmailValidator.validate(email);
      if (!validated) {
        showSnackBar(context, 'Invalid email address');
        return;
      }
      AuthManager authManager = context.read<AuthManager>();
      setState(() {
        _loading = true;
      });
      FirebaseException? error =
          await authManager.sendResetPasswordEmail(email);
      setState(() {
        _loading = false;
      });
      if (error != null && mounted) {
        showSnackBar(context, error.message ?? 'Error');
      } else {
        showSnackBar(context,
            'Reset password link has been sent to your email address.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Scaffold(body: LoadingWidget())
        : AuthScaffold(
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Please enter your email address:'),
                  const SizedBox(height: 15.0),
                  AuthTextField(
                    controller: _controller,
                    errorMessage: blankEmailErrorMsg,
                    hintText: emailHint,
                    emailMode: true,
                  ),
                  MainButton(
                    text: 'Reset password',
                    onPressed: () => _onSubmit(),
                  ),
                ],
              ),
            ),
          );
  }
}
