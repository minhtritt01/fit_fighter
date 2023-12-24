import 'dart:async';

import 'package:fit_fighter/constants/globals.dart';

import '../games/fit_fighter_game.dart';
import 'package:flame/components.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<FitFighterGame> {
  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
    return super.onLoad();
  }
}
