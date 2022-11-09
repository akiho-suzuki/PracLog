import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/ui/auth/reauth_screen.dart';
import 'package:praclog/ui/auth/update_password_screen.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/settings/widgets/action_tile.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/utils/show_dialog.dart';
import 'package:praclog/ui/utils/show_snackbar.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../helpers/datetime_helpers.dart';
import '../../helpers/null_empty_helper.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late bool _loading;

  @override
  void initState() {
    _loading = false;
    super.initState();
  }

  Widget _buildVerifyEmail(AuthManager authManager) {
    return ActionTile(
      icon: Icons.email,
      onPressed: () async {
        String? result = await authManager.sendEmailVerification();
        if (result.isNotNullOrEmpty && mounted) {
          showSnackBar(context, result!);
        }
      },
      text: 'Send verification email',
    );
  }

  Widget _buildResetPassword(AuthManager authManager) {
    return ActionTile(
      icon: Icons.password,
      text: 'Reset password',
      onPressed: () => _onPressResetPassword(authManager),
    );
  }

  Future _onPressDeleteAccount(
      BuildContext context, AuthManager authManager) async {
    // Confirm with user that they want to delete account
    bool? response = await showConfirmPopup(context,
        message:
            'Are you sure that you want to delete your account? This action cannot be undone and your data will be permanently deleted.',
        title: 'Delete account?',
        confirmButtonText: 'Delete');

    // Delete account
    if (response == true && mounted) {
      setState(() {
        _loading = true;
      });

      FirebaseException? result;
      if (authManager.signedInWithGoogle) {
        result = await authManager.deleteAccount(null, googleUser: true);
      } else {
        String? password = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ReAuthScreen(),
          ),
        );
        if (password.isNotNullOrEmpty) {
          result = await authManager.deleteAccount(password);
        }
      }

      // Show error if there is one
      if (result != null && mounted) {
        setState(() {
          _loading = false;
        });
        showSnackBar(context, result.message ?? 'Error');
      } else {
        Navigator.pop(context);
      }
    }
  }

  Future _onPressResetPassword(AuthManager authManager) async {
    List<String>? password = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdatePasswordScreen(),
      ),
    );

    if (password.isNotNullOrEmpty) {
      setState(() {
        _loading = true;
      });

      FirebaseException? result =
          await authManager.updatePassword(password!.first, password.last);

      setState(() {
        _loading = false;
      });
      // Show error if there is one
      if (result != null && mounted) {
        showSnackBar(context, result.message ?? 'Error');
      } else {
        showSnackBar(context, 'Password updated.');
      }
    }
  }

// TODO delete data
// Future _onPressDeleteData() async {}

  @override
  Widget build(BuildContext context) {
    AuthManager authManager = context.watch<AuthManager>();
    return _loading
        ? const Scaffold(body: LoadingWidget())
        : CustomScaffold(
            appBarTitle: 'My account',
            body: ListView(
              children: [
                const Headers(text: 'Account details'),
                // Name
                RoundedWhiteCard(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoText(
                        text: authManager.currentUser.displayName!,
                        label: 'Name',
                        topMargin: false,
                      ),
                      const Divider(),
                      // Email address
                      _InfoText(
                          text: authManager.currentUser.email!, label: 'Email'),
                      const Divider(),
                      // Joined date
                      _InfoText(
                          text:
                              authManager.accountCreationDate?.getDateOnly() ??
                                  'Unknown',
                          label: 'Joined'),
                      const Divider(),
                      // Email verification status
                      _InfoText(
                        text: authManager.userEmailVerified ? 'Yes' : 'No',
                        label: 'Email verified?',
                        bottomMargin: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7.0),
                const Headers(text: 'Account options'),
                // Button to change password
                RoundedWhiteCard(
                  child: Column(
                    children: [
                      // If email is not verified, button to send verification email
                      authManager.userEmailVerified
                          ? const SizedBox.shrink()
                          : _buildVerifyEmail(authManager),
                      authManager.userEmailVerified
                          ? const SizedBox.shrink()
                          : const Divider(),
                      // Button to reset password
                      authManager.signedInWithGoogle
                          ? const SizedBox.shrink()
                          : _buildResetPassword(authManager),
                      authManager.signedInWithGoogle
                          ? const SizedBox.shrink()
                          : const Divider(),
                      // TODO: add button to delete data
                      // Button to delete account
                      ActionTile(
                        icon: Icons.delete,
                        text: 'Delete account',
                        onPressed: () =>
                            _onPressDeleteAccount(context, authManager),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class _InfoText extends StatelessWidget {
  final String label;
  final String text;
  final bool topMargin;
  final bool bottomMargin;

  const _InfoText({
    Key? key,
    required this.text,
    required this.label,
    this.topMargin = true,
    this.bottomMargin = true,
  }) : super(key: key);

  double margin(bool include) => include ? 8.0 : 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: margin(topMargin), bottom: margin(bottomMargin)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kMainButtonTextStyle),
          const SizedBox(height: 7.0),
          Text(text,
              style: const TextStyle(color: CustomColors.lightTextColor)),
        ],
      ),
    );
  }
}


// class _InfoText extends StatelessWidget {
//   final String label;
//   final String text;
//   const _InfoText({
//     Key? key,
//     required this.text,
//     required this.label,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(label),
//       subtitle: Text(text),
//     );
//   }
// }
