import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';

class LegendWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;
  final bool active;

  const LegendWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
    required this.active,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            Icons.fiber_manual_record,
            size: 16.0,
            color: active ? color : kLightTextColor,
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: active ? kMainTextColor : kLightTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
