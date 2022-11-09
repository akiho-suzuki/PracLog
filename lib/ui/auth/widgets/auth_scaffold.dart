import 'package:flutter/material.dart';
import 'package:praclog/ui/theme/custom_colors.dart';

class AuthScaffold extends StatelessWidget {
  final Widget body;
  const AuthScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0.0,
        foregroundColor: CustomColors.mainTextColor,
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child:
            Image(image: AssetImage('assets/splash_screen.png'), height: 40.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: body,
      ),
    );
  }
}
