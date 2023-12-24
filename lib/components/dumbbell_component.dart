import 'dart:async';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';

import '../components/components.dart';
import 'package:flame/collisions.dart';

import '../constants/globals.dart';
import '../games/fit_fighter_game.dart';
import 'package:flame/components.dart';

class DumbbellComponent extends SpriteComponent
    with HasGameRef<FitFighterGame>, CollisionCallbacks {
  final double _spriteHeight = 60.0;

  final Random _random = Random();

  Vector2 _getRandomPosition() {
    double x = _random.nextInt(gameRef.size.x.toInt()).toDouble();
    double y = _random.nextInt(gameRef.size.y.toInt()).toDouble();
    return Vector2(x, y);
  }

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite(Globals.dumbbellSprite);
    height = width = _spriteHeight;
    position = _getRandomPosition();
    anchor = Anchor.center;
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PlayerComponent) {
      FlameAudio.play(Globals.dumbbellSound);
      removeFromParent();
      gameRef.score += 1;
      gameRef.add(DumbbellComponent());
    }
    super.onCollision(intersectionPoints, other);
  }
}
