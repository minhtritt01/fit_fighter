import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

JoystickComponent joystick = JoystickComponent(
    knob: CircleComponent(
        radius: 30.0,
        paint: BasicPalette.red
            .withAlpha(200)
            .paint()), // the inner which the user will drag
    background: CircleComponent(
        radius: 80.0,
        paint: BasicPalette.red.withAlpha(100).paint()) // the outer
    ,
    margin: const EdgeInsets.only(
        left: 40.0, bottom: 40.0)); //position of the joystick
