import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../helpers/null_empty_helpers.dart';

class DurationEditPopup extends StatefulWidget {
  final int initialDuration;
  const DurationEditPopup({
    Key? key,
    required this.initialDuration,
  }) : super(key: key);

  @override
  State<DurationEditPopup> createState() => _DurationEditPopupState();
}

class _DurationEditPopupState extends State<DurationEditPopup> {
  String? _durationInString;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit practice duration'),
      content: TextFormField(
        initialValue: widget.initialDuration.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        onChanged: (value) {
          _durationInString = value;
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              int? duration;
              if (_durationInString.isNotNullOrEmpty) {
                duration = int.parse(_durationInString!);
              }
              Navigator.pop(context, duration ?? widget.initialDuration);
            },
            child: const Text('Confirm'))
      ],
    );
  }
}
