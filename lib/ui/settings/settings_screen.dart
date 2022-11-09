import 'package:flutter/material.dart';
import 'package:praclog/ui/settings/account_details.dart';
import 'package:praclog/ui/settings/data_export_screen.dart';
import 'package:praclog/ui/settings/widgets/action_tile.dart';
import 'package:praclog/ui/utils/show_snackbar.dart';
import 'package:praclog/ui/utils/user_feedback.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../services/auth_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future _launchEmail(bool bugReport) async {
    bool result = await launchEmail(bugReport);
    if (!result && mounted) {
      showSnackBar(context, 'Error. Please try again later.');
    }
  }

  Future _onPressExportData(AuthManager authManager) async {
    if (authManager.signedInWithGoogle) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DataExportScreen()));
    } else {
      showSnackBar(context,
          'This function is currently only available to Google accounts. Sorry for the inconvenience.');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthManager authManager = context.watch<AuthManager>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Headers(text: 'Account options'),
          RoundedWhiteCard(
            child: Column(
              children: [
                ActionTile(
                  icon: Icons.manage_accounts,
                  text: 'My account',
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountDetailsScreen())),
                ),
                const Divider(),
                ActionTile(
                  icon: Icons.table_chart,
                  text: 'Export my data as CSV',
                  onPressed: () => _onPressExportData(authManager),
                ),
                const Divider(),
                ActionTile(
                  icon: Icons.logout,
                  text: 'Log out',
                  onPressed: () {
                    authManager.signOut();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 7.0),
          const Headers(text: 'App support'),
          RoundedWhiteCard(
            child: Column(
              children: [
                ActionTile(
                  icon: Icons.comment,
                  text: 'Send feedback',
                  onPressed: () => _launchEmail(false),
                ),
                const Divider(),
                ActionTile(
                  icon: Icons.bug_report,
                  text: 'Report a bug',
                  onPressed: () => _launchEmail(true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
