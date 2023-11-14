import 'package:flutter/material.dart';

/// Padding defaults to `EdgeInsets.all(7.0)`
class RoundedWhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const RoundedWhiteCard({
    Key? key,
    required this.child,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.only(top: 4.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(7.0),
        child: child,
      ),
    );
  }
}
