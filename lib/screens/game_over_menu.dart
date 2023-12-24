import '../constants/globals.dart';
import '../screens/main_menu.dart';

import '../games/fit_fighter_game.dart';
import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);
  final FitFighterGame gameRef;

  static const String ID = "GameOverMenu";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    AssetImage('assets/images/${Globals.backgroundSprite}'))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Game Over",
                style: TextStyle(fontSize: 50.0),
              ),
              Text(
                "Score: ${gameRef.score}",
                style: const TextStyle(fontSize: 50.0),
              ),
              Text(
                "(Protein Bonus: ${gameRef.proteinBonus})",
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 200.0),
              SizedBox(
                width: 200.0,
                height: 50.0,
                child: ElevatedButton(
                    onPressed: () {
                      gameRef.overlays.remove(GameOverMenu.ID);
                      gameRef.reset();
                      gameRef.resumeEngine();
                    },
                    child: const Text(
                      "Play Again ?",
                      style: TextStyle(fontSize: 25.0),
                    )),
              ),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 50.0,
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(GameOverMenu.ID);
                    gameRef.reset();
                    gameRef.resumeEngine();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainMenu()));
                  },
                  child: const Text(
                    "Main Menu",
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
