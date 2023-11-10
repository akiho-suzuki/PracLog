import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

class StatsTile extends StatelessWidget {
  final IconData iconData;
  final String data;
  final String text;

  const StatsTile(
      {Key? key,
      required this.iconData,
      required this.data,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(
          iconData,
          //   color: CustomColors.lightTextColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(text, style: const TextStyle(color: kLightTextColor)),
      ]),
    );
  }
}
