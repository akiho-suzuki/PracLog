import 'package:flutter/material.dart';
import 'package:praclog/helpers/shared_pref_refs.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shows user a warning about the fact that the number of movements cannot be changed later.
///
/// Returns `true` if user wishes to proceed with creating a new piece, and returns `false` is user cancels.
///
/// The alert dialog should only be shown after checking the shared preferences, to see if the user has not previously ticked "Do not show this again" box.
class MovementAlertDialog extends StatefulWidget {
  const MovementAlertDialog({Key? key}) : super(key: key);

  @override
  State<MovementAlertDialog> createState() => _MovementAlertDialogState();
}

class _MovementAlertDialogState extends State<MovementAlertDialog> {
  late bool? _tickBoxValue;

  @override
  void initState() {
    _tickBoxValue = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
              'You cannot change the number of movements after saving a piece. Do you wish to proceed?'),
          CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Don\'t show this again'),
              value: _tickBoxValue,
              onChanged: (v) {
                setState(() {
                  _tickBoxValue = v;
                });
              })
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (_tickBoxValue == true) {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool(SharedPrefRefs.noShowMvtWarning, true);
            }
            if (mounted) {
              Navigator.pop(context, true);
            }
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
