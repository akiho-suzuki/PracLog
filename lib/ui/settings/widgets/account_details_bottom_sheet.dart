import 'package:flutter/material.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/utils/show_snackbar.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import '../../../helpers/null_empty_helper.dart';
import '../../../helpers/datetime_helpers.dart';

class AccountDetailsBottomSheet extends StatefulWidget {
  final AuthManager authManager;
  const AccountDetailsBottomSheet({
    Key? key,
    required this.authManager,
  }) : super(key: key);

  @override
  State<AccountDetailsBottomSheet> createState() =>
      _AccountDetailsBottomSheetState();
}

class _AccountDetailsBottomSheetState extends State<AccountDetailsBottomSheet> {
  Widget _buildVerifyEmail() {
    return TextButton(
      onPressed: () async {
        String? result = await widget.authManager.sendEmailVerification();
        if (result.isNotNullOrEmpty && mounted) {
          Navigator.pop(context);
          showSnackBar(context, result!);
        }
      },
      child: const Text('Send verification email'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      color: CustomColors.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Account details', style: kBottomSheetTitle),
          const SizedBox(height: 20.0),
          RoundedWhiteCard(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoText(
                    text: widget.authManager.currentUser.displayName!,
                    label: 'Name'),
                const SizedBox(height: 15.0),
                _InfoText(
                    text: widget.authManager.currentUser.email!,
                    label: 'Email'),
                const SizedBox(height: 15.0),
                _InfoText(
                    text:
                        widget.authManager.accountCreationDate?.getDateOnly() ??
                            'Unknown',
                    label: 'Joined'),
                const SizedBox(height: 15.0),
                _InfoText(
                    text: widget.authManager.userEmailVerified ? 'Yes' : 'No',
                    label: 'Email verified?'),
                widget.authManager.userEmailVerified
                    ? const SizedBox.shrink()
                    : _buildVerifyEmail(),
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
  const _InfoText({
    Key? key,
    required this.text,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kSubheading),
        const SizedBox(height: 5.0),
        Text(text),
      ],
    );
  }
}
