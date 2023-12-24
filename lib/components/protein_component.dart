import 'dart:async';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';

import '../components/components.dart';
import '../constants/globals.dart';
import 'package:flame/collisions.dart';

import '../games/fit_fighter_game.dart';
import 'package:flame/components.dart';

class ProteinComponent extends SpriteComponent
    with HasGameRef<FitFighterGame>, CollisionCallbacks {
  final double _spriteHeight = 80.0;
  final Vector2 startPosition;
  ProteinComponent({required this.startPosition});

  late Vector2 _velocity;
  double speed = 300.0;
  Vector2 moveSprite() {
    // Generate a random angle
    final randomAngle = Random().nextDouble() * 2 * pi;
    // calculate the sine and cosine of the the angle
    final sinAngle = sin(randomAngle);
    final cosAngle = cos(randomAngle);

    final double vx = cosAngle * speed;
    final double vy = sinAngle * speed;
    return Vector2(vx, vy);
  }

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite(Globals.proteinSprite);
    height = width = _spriteHeight;
    position = startPosition;
    anchor = Anchor.center;
    _velocity = moveSprite();
    add(CircleHitbox());
    return await super.onLoad();
  }

  @override
  void update(double dt) {
    position += _velocity * dt;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox) {
      final Vector2 collisionPoint = intersectionPoints.first;
      if (collisionPoint.x == 0) {
        //at the very left
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionPoint.x >= gameRef.size.x - 60.0) {
        //at the very right
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionPoint.y == 0) {
        //at the very top
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
      if (collisionPoint.y >= gameRef.size.y) {
        //at the very bottom
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }
    if (other is PlayerComponent) {
      removeFromParent();
      int randomBonusScore = Random().nextInt(9);
      gameRef.score += randomBonusScore;
      FlameAudio.play(Globals.proteinSound);
      gameRef.proteinTimer.stop();
      gameRef.proteinBonus = randomBonusScore;
    }
    super.onCollision(intersectionPoints, other);
  }
}
