import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool reverseColor;
  final Widget? icon;

  const MainButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.reverseColor = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(
          reverseColor ? kPrimaryColor : Colors.white,
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            } else {
              return reverseColor ? Colors.white : kPrimaryColor;
            }
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: customBorderRadius,
            //side: const BorderSide(color: CustomColors.primaryColor),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: (icon == null)
            ? const EdgeInsets.symmetric(vertical: 10.0)
            : const EdgeInsets.symmetric(vertical: 5.0),
        child: icon == null
            ? Text(text, style: kMainButtonTextStyle)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon!,
                  Text(text, style: kMainButtonTextStyle),
                  const SizedBox(width: 30.0),
                ],
              ),
      ),
    );
  }
}
