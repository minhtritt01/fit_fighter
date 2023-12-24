import '../constants/globals.dart';
import '../screens/game_play.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/${Globals.backgroundSprite}',
                ),
                fit: BoxFit.cover)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0),
              child: Text(
                'Fit Fighter',
                style: TextStyle(fontSize: 50.0),
              ),
            ),
            const SizedBox(
              height: 200.0,
            ),
            SizedBox(
              width: 200.0,
              height: 50.0,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GamePlay()));
                  },
                  child: const Text(
                    'Play',
                    style: TextStyle(fontSize: 25.0),
                  )),
            )
          ],
        )),
      ),
    );
  }
}
