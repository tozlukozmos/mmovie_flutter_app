import 'package:flutter/material.dart';

import '../widgets/app_buttons.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButtons.appOutlinedButton(
                name: "Log in",
                onPressed: () {
                  Navigator.pushNamed(context, 'login_screen');
                },
              ),
              AppButtons.appElevatedButton(
                name: "Sign up",
                onPressed: () {
                  Navigator.pushNamed(context, 'signup_screen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
