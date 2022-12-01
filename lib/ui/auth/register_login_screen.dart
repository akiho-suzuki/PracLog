import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/ui/auth/auth_texts.dart';
import 'package:praclog/ui/auth/forgot_password_screen.dart';
import 'package:praclog/ui/auth/widgets/auth_scaffold.dart';
import 'package:praclog/ui/auth/widgets/auth_textfield.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/utils/show_dialog.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:provider/provider.dart';

class RegisterLogInScreen extends StatefulWidget {
  /// Log in screen if true, register screen if false
  final bool login;
  const RegisterLogInScreen({
    Key? key,
    required this.login,
  }) : super(key: key);

  @override
  State<RegisterLogInScreen> createState() => _RegisterLogInScreenState();
}

class _RegisterLogInScreenState extends State<RegisterLogInScreen> {
  late bool _loading;
  String? _errorMsg;

  // For the form
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get titleText => widget.login ? 'Log in' : 'Register';

  // Called when user presses submit button ('register' or 'log in').
  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Warning about data export only being available to Google accounts (only for register)
      if (!widget.login) {
        var response = await showConfirmPopup(context,
            message:
                'Data export function is currently only available to users that register with a Google account. Do you wish to continue?',
            title: 'Warning!',
            confirmButtonText: 'Proceed');
        if (response == null || response == false) {
          return;
        }
      }

      // Check email address
      String email = _emailController.text.trim();
      if (!widget.login) {
        bool validated = EmailValidator.validate(email);
        if (!validated) {
          setState(() {
            _errorMsg = 'Invalid email address';
          });
          return;
        }
      }

      setState(() {
        _loading = true;
      });

      if (mounted) {
        AuthManager authManager = context.read<AuthManager>();
        FirebaseAuthException? result;

        // Login
        if (widget.login) {
          result = await authManager.logInWithEmailAndPassword(
              email: email, password: _passwordController.text.trim());
        } else {
          // Register
          result = await authManager.registerWithEmailAndPassword(
            email: email,
            password: _passwordController.text.trim(),
          );
        }

        // If there is an error, show error message
        if (result != null) {
          setState(() {
            _loading = false;
            _errorMsg = result!.message;
          });
        } else {
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    }
  }

// Called when user presses on "Sign in with Google" button
  Future onGoogleSign() async {
    AuthManager authManager = context.read<AuthManager>();
    await authManager.signInWithGoogle();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget showErrorMessage() {
    if (_errorMsg != null && _errorMsg!.isNotEmpty) {
      return Text(_errorMsg!);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Scaffold(body: LoadingWidget())
        : AuthScaffold(
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Main form
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 8.0),
                          child: Text(titleText,
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.primaryColor)),
                        ),
                        // Email field
                        AuthTextField(
                            controller: _emailController,
                            errorMessage: blankEmailErrorMsg,
                            emailMode: true,
                            hintText: emailHint),
                        // Password field
                        AuthTextField(
                            controller: _passwordController,
                            obscureText: true,
                            errorMessage: blankPasswordErrorMsg,
                            hintText: widget.login
                                ? passwordLoginHint
                                : passwordRegisterHint),
                        // Error message
                        showErrorMessage(),
                        const SizedBox(height: 15.0),
                        // Submit button
                        MainButton(
                            onPressed: () {
                              onSubmit();
                            },
                            text: titleText),
                        // Forgot password button (login only)
                        widget.login
                            ? TextButton(
                                child: (const Text('Forgot password?')),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen())))
                            : const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: const [
                              Expanded(
                                  child: Divider(
                                      color: CustomColors.lightTextColor,
                                      thickness: 1.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text('OR',
                                    style: TextStyle(
                                        color: CustomColors.lightTextColor)),
                              ),
                              Expanded(
                                  child: Divider(
                                      color: CustomColors.lightTextColor,
                                      thickness: 1.5)),
                            ],
                          ),
                        ),
                        MainButton(
                          reverseColor: true,
                          text: '$titleText with Google',
                          icon: Image.asset(
                            'assets/btn_google_signin_light_normal_xxxhdpi.9.png',
                            width: 30.0,
                          ),
                          onPressed: () {
                            onGoogleSign();
                          },
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
