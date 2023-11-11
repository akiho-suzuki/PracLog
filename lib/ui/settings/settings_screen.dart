import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/services/data_import_export.dart';
import 'package:praclog_v2/ui/main_screen.dart';
import 'package:praclog_v2/ui/settings/widgets/action_tile.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';
import 'package:praclog_v2/utils/show_popup.dart';
import 'package:praclog_v2/utils/show_snackbar.dart';
import 'package:praclog_v2/utils/user_feedback.dart';

const String _deleteConfirmationMsg =
    "Are you sure that you want to delete ALL of your data? This will delete your pieces, your logs, and your stats. This action cannot be undone!";

class SettingsScreen extends StatefulWidget {
  final Isar isar;
  const SettingsScreen({Key? key, required this.isar}) : super(key: key);

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

  Future _exportData() async {
    bool response = await DataImportExport(isar: widget.isar).exportData();
    if (response && mounted) {
      showSnackBar(context, "Data shared successfully!");
    }
  }

  Future _onPressDeleteData() async {
    bool? response = await showConfirmPopup(context,
        message: _deleteConfirmationMsg,
        title: "Delete all data?",
        confirmButtonText: "Delete");
    if (response == true) {
      // Close Isar instance and delete all data
      await widget.isar.close(deleteFromDisk: true);

      // Open a new Isar instance
      final dir = await getApplicationSupportDirectory();
      final isar = await Isar.open([
        PieceSchema,
        LogSchema,
      ], directory: dir.path, inspector: true);

      // Go to the first homepage
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MainScreen(
                      isar: isar,
                    )),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Headers(text: 'My data'),
          RoundedWhiteCard(
            child: Column(
              children: [
                ActionTile(
                  icon: Icons.table_chart,
                  text: 'Export my data',
                  onPressed: () => _exportData(),
                ),
                const Divider(),
                ActionTile(
                  icon: Icons.delete_forever,
                  text: "Delete my data",
                  onPressed: () => _onPressDeleteData(),
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
