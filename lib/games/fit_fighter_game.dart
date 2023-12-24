import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/screens/game_over_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import 'package:fit_fighter/inputs/joystick.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class FitFighterGame extends FlameGame
    with DragCallbacks, HasCollisionDetection {
  int score = 0;
  late Timer _timer;
  int _remainingTime = 30;
  late TextComponent _scoreText;
  late TextComponent _timeText;
  late PlayerComponent playerComponent;

  // Vaccine
  final VaccineComponent _vaccineComponent =
      VaccineComponent(startPosition: Vector2(200.0, 200.0));
  int _vaccineImmunityTime = 4;
  late Timer vaccineTimer;
  late int _vaccineTimerAppearance;

  // Protein
  final ProteinComponent _proteinComponent =
      ProteinComponent(startPosition: Vector2(200.0, 200.0));
  int _proteinTimeLeft = 4; //Protein will automatically disappear after 4s
  late Timer proteinTimer;
  late int _proteinTimeAppearance; // Random time for the protein appearance
  int proteinBonus = 0;

  @override
  FutureOr<void> onLoad() async {
    _vaccineTimerAppearance =
        Random().nextInt(_remainingTime - 20) + 20; // first vaccine to appear
    _proteinTimeAppearance = Random().nextInt(_remainingTime - 5) +
        5; // Time should be between 5 and 30
    add(BackgroundComponent());
    playerComponent = PlayerComponent(joystick: joystick);
    add(playerComponent);
    add(DumbbellComponent());
    add(joystick);
    // debugMode = true;

    FlameAudio.audioCache.loadAll([
      Globals.dumbbellSound,
      Globals.virusSound,
      Globals.vaccineSound,
      Globals.proteinSound
    ]);

    add(VirusComponent(startPosition: Vector2(100.0, 150.0)));
    add(VirusComponent(startPosition: Vector2(size.x - 50, size.y - 200.0)));
    // Any collision on the bounds of the viewport
    add(ScreenHitbox());

    _timer = Timer(
      1,
      repeat: true,
      onTick: () {
        if (_remainingTime == 0) {
          pauseEngine();
          overlays.add(GameOverMenu.ID);
        } else if (_remainingTime == _vaccineTimerAppearance) {
          add(_vaccineComponent);
        } else if (_remainingTime == _proteinTimeAppearance) {
          add(_proteinComponent);
          proteinTimer.start();
        }
        _remainingTime -= 1;
      },
    );
    _timer.start();

    proteinTimer = Timer(1.0, repeat: true, onTick: () {
      if (_proteinTimeLeft == 0) {
        remove(_proteinComponent);
        _proteinTimeLeft = 4;
        proteinTimer.stop();
      } else {
        _proteinTimeLeft -= 1;
      }
    });

    vaccineTimer = Timer(1.0, repeat: true, onTick: () {
      if (_vaccineImmunityTime == 0) {
        playerComponent.removeVaccine();
        _vaccineImmunityTime = 4;
        _vaccineTimerAppearance = 0;
        vaccineTimer.stop();
      } else {
        _vaccineImmunityTime -= 1;
      }
    });
    _scoreText = TextComponent(
        text: "Score: $score",
        position: Vector2(40.0, 40.0),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: TextStyle(color: BasicPalette.black.color, fontSize: 25.0)));
    add(_scoreText);

    _timeText = TextComponent(
        text: "Time: $_remainingTime secs",
        position: Vector2(size.x - 40.0, 40),
        anchor: Anchor.topRight,
        textRenderer: TextPaint(
            style: TextStyle(color: BasicPalette.black.color, fontSize: 25.0)));
    add(_timeText);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (_proteinComponent.isLoaded) {
      proteinTimer.update(dt);
    }
    _timer.update(dt);
    _scoreText.text = "Score: $score";
    _timeText.text = "Time: $_remainingTime secs";
    if (playerComponent.isVaccinated) {
      vaccineTimer.update(dt);
    } else if (_vaccineTimerAppearance == 0) {
      if (_remainingTime > 3) {
        _vaccineTimerAppearance = Random().nextInt(_remainingTime - 3) +
            3; // new vaccine appearance time
      }
    }
    super.update(dt);
  }

  void reset() async {
    score = 0;
    _remainingTime = 30;
    _vaccineImmunityTime = 4;
    _vaccineComponent.removeFromParent();
    _proteinTimeLeft = 4;
    _proteinComponent.removeFromParent();
    _proteinTimeAppearance = Random().nextInt(_remainingTime - 5) + 5;
    playerComponent.sprite = await loadSprite(Globals.playerSkinnySprite);
  }
}
