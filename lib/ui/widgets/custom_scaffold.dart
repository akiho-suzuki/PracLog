import 'package:flutter/material.dart';

/// Just an ordinary scaffold with a padding of 15.0 (all) around the body.
class CustomScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? appBarTrailing;
  final Widget body;
  const CustomScaffold({
    Key? key,
    this.appBarTitle,
    this.appBarTrailing,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle == null ? null : Text(appBarTitle!),
        actions: appBarTrailing,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: body,
      ),
    );
  }
}
