import 'dart:async';

import '../components/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';

import '../constants/globals.dart';

import '../games/fit_fighter_game.dart';
import 'package:flame/components.dart';

class PlayerComponent extends SpriteComponent
    with HasGameRef<FitFighterGame>, CollisionCallbacks {
  final double _spriteHeight = 100;
  final double _speed = 500;
  JoystickComponent joystick;
  PlayerComponent({required this.joystick});

  late double _rightBound;
  late double _leftBound;
  late double _upBound;
  late double _downBound;

  late Sprite playerSkinny;
  late Sprite playerFever;
  late Sprite playerFit;
  late Sprite playerMuscular;
  bool _virusAttacked = false;
  bool isVaccinated = false;
  final Timer _timer = Timer(3.0);

  void _freezePlayer() {
    if (!_virusAttacked) {
      FlameAudio.play(Globals.virusSound); //play sound at collision
      _virusAttacked = true;
      playerSprite(); //change the sprite image
      if (gameRef.score > 0) {
        gameRef.score -= 1;
      }
      _timer.start();
    }
  }

  void _unfreezePlayer() {
    _virusAttacked = false;
    playerSprite();
  }

  void playerSprite() {
    if (_virusAttacked) {
      sprite = playerFever;
    } else if (gameRef.score > 5 && gameRef.score <= 10) {
      sprite = playerFit;
    } else if (gameRef.score > 10) {
      sprite = playerMuscular;
    } else {
      sprite = playerSkinny;
    }
  }

  @override
  void update(double dt) {
    if (!_virusAttacked) {
      if (joystick.direction == JoystickDirection.idle) {
        return;
      }
      playerSprite();
      // if not idle then check not out of boundaries
      if (x >= _rightBound) {
        x = _rightBound;
      } else if (x <= _leftBound) {
        x = _leftBound;
      } else if (y <= _upBound) {
        y = _upBound;
      } else if (y >= _downBound) {
        y = _downBound;
      }

      position.add(joystick.relativeDelta * _speed * dt);
    } else {
      _timer.update(dt);
      if (_timer.finished) {
        _unfreezePlayer();
      }
    }

    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() async {
    playerSkinny = await gameRef.loadSprite(Globals.playerSkinnySprite);
    playerFever = await gameRef.loadSprite(Globals.playerFeverSprite);
    playerFit = await gameRef.loadSprite(Globals.playerFitSprite);
    playerMuscular = await gameRef.loadSprite(Globals.playerMuscularSprite);

    playerSprite();
    position = gameRef.size / 2;
    height = width = _spriteHeight;
    anchor = Anchor.center;

    _rightBound = gameRef.size.x - 60.0;
    _leftBound = 60.0; //x start with 0
    _upBound = 60.0; //y start with 0
    _downBound = gameRef.size.y - 60.0;
    add(RectangleHitbox());
    return await super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is VirusComponent) {
      if (!isVaccinated) {
        _freezePlayer();
      }
    }

    if (other is VaccineComponent) {
      injectVaccine();
    }
    super.onCollision(intersectionPoints, other);
  }

  void injectVaccine() {
    // don't execute if the player is freezed by virus
    if (!_virusAttacked) {
      isVaccinated = true;
      FlameAudio.play(Globals.vaccineSound);
      gameRef.vaccineTimer.start();
    }
  }

  void removeVaccine() {
    isVaccinated = false;
  }
}
