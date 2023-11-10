import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';

class ActionTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ActionTile({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      onTap: onPressed,
      trailing: Icon(
        icon,
        color: kLightTextColor,
      ),
    );
  }
}

class Headers extends StatelessWidget {
  final String text;

  const Headers({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: Text(text, style: kSubheading),
    );
  }
}
