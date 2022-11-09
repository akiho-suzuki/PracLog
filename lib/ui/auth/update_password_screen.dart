import 'package:flutter/material.dart';
import 'package:praclog/ui/auth/auth_texts.dart';
import 'package:praclog/ui/auth/widgets/auth_scaffold.dart';
import 'package:praclog/ui/auth/widgets/auth_textfield.dart';
import 'package:praclog/ui/widgets/main_button.dart';

/// Returns List<String> of [oldPassword, newPassword]
class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _ReAuthScreenState();
}

class _ReAuthScreenState extends State<UpdatePasswordScreen> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
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
            const Text('Please enter your current password:'),
            const SizedBox(height: 15.0),
            AuthTextField(
              controller: _oldPasswordController,
              errorMessage: blankPasswordErrorMsg,
              hintText: 'Current password',
              obscureText: true,
            ),
            const SizedBox(height: 15.0),
            const Text('Please enter your new password:'),
            const SizedBox(height: 15.0),
            AuthTextField(
              controller: _newPasswordController,
              errorMessage: blankPasswordErrorMsg,
              hintText: 'New password',
              obscureText: true,
            ),
            MainButton(
              text: 'Update password',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, [
                    _oldPasswordController.text.trim(),
                    _newPasswordController.text.trim()
                  ]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
