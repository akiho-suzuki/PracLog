import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:praclog/ui/auth/register_login_screen.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/main_button.dart';

const String _pictureName = 'assets/undraw_compose_music_re_wpiw.svg';
const String _logoName = 'assets/splash_screen.png';
const Widget _text = Center(
    child: Text('Track and improve your practice',
        style: TextStyle(fontSize: 16.0, color: CustomColors.lightTextColor)));

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          AppBar(backgroundColor: CustomColors.backgroundColor, elevation: 0.0),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 0.0, bottom: 30.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Image(image: AssetImage(_logoName), height: 60.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(_pictureName),
                        _text,
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MainButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterLogInScreen(
                            login: false,
                          ),
                        ),
                      );
                    },
                    text: 'Register',
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: MainButton(
                    reverseColor: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterLogInScreen(
                            login: true,
                          ),
                        ),
                      );
                    },
                    text: 'Log in',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
