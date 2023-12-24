import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fit_fighter/screens/main_menu.dart';
import 'package:flutter/material.dart';

class GameSplashScreen extends StatelessWidget {
  const GameSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/game_logo.png'),
      nextScreen: const MainMenu(),
      duration: 2000,
      splashIconSize: 250.0,
      backgroundColor: Colors.black,
      splashTransition: SplashTransition.scaleTransition,
    );
  }
}
