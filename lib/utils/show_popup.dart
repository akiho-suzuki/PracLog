import 'package:flutter/material.dart';

/// Shows an `AlertDialog` with `title` and `message`.
///
/// Returns `true` if user confirms, and `false` if user cancels.
///
/// If `confirmButtonText` is `null`, it defaults to the `title`.
Future<bool?> showConfirmPopup(BuildContext context,
    {required String message,
    required String title,
    String? confirmButtonText}) async {
  return await showDialog(
      context: context,
      builder: (context) => _ConfirmPopup(
            message: message,
            title: title,
            confirmButtonText: confirmButtonText,
          ));
}

const String kDeletePieceMsg =
    'Are you sure that you want to delete this piece? All logs associated with the piece will also be deleted. This acction cannot be undone.';

class _ConfirmPopup extends StatelessWidget {
  final String message;
  final String title;
  final String? confirmButtonText;

  const _ConfirmPopup({
    Key? key,
    required this.message,
    required this.title,
    this.confirmButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(confirmButtonText ?? title),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}
