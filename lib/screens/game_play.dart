import '../screens/game_over_menu.dart';
import 'package:flame/game.dart';

import '../games/fit_fighter_game.dart';
import 'package:flutter/material.dart';

final FitFighterGame _fitFighterGame = FitFighterGame();

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: _fitFighterGame,
      overlayBuilderMap: {
        GameOverMenu.ID: (BuildContext context, FitFighterGame gameRef) =>
            GameOverMenu(gameRef: gameRef)
      },
    );
  }
}
