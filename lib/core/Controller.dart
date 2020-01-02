import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Controller extends PositionComponent {

  double backgroundAspectRatio = 2.2;
  Sprite backgroundSprite;
  Rect upRect;
  Rect downRect;
  Rect leftRect;
  Rect rightRect;

  double atackAspectRatio = 2.5;
  Rect atackRect;
  Sprite atackSprite;

  final double tileSize;
  final Size screenSize;

  final Function() moveTop;
  final Function() moveBottom;
  final Function() moveLeft;
  final Function() moveRight;
  final Function() idle;
  final Function() atack;

  Controller(
      this.screenSize,
      this.tileSize,
      this.moveTop,
      this.moveBottom,
      this.moveLeft,
      this.moveRight,
      this.idle,
      this.atack) {
    backgroundSprite = Sprite('joystick_background.png');
    atackSprite = Sprite('joystick_atack.png');

    //Button Atack
    atackRect = Rect.fromCircle(
      center: Offset(295, 580),
      radius: 70,
    );

    upRect = Rect.fromCircle(
      center: Offset(95, 510),
      radius: 30
    );
    downRect = Rect.fromCircle(
      center: Offset(95, 620),
      radius: 30
    );
    leftRect = Rect.fromCircle(
      center: Offset(40, 565),
      radius: 30
    );
    rightRect = Rect.fromCircle(
      center: Offset(150, 565),
      radius: 30
    );
 }

  void render(Canvas canvas) {
    backgroundSprite.renderRect(canvas, upRect);
    backgroundSprite.renderRect(canvas, downRect);
    backgroundSprite.renderRect(canvas, leftRect);
    backgroundSprite.renderRect(canvas, rightRect);

    atackSprite.renderRect(canvas, atackRect);
  }

  void update(double t) {
  }

  void onPanStart(DragStartDetails details) {
  }

  void onTapDown(TapDownDetails details){
    if (upRect.contains(details.globalPosition)) {
      moveTop();
    }
    if (downRect.contains(details.globalPosition)) {
      moveBottom();
    }
    if (leftRect.contains(details.globalPosition)) {
      moveLeft();
    }
    if (rightRect.contains(details.globalPosition)) {
      moveRight();
    }
  }

  void onTapUp(TapUpDetails details){
  }

  void onPanUpdate(DragUpdateDetails details) {
  }

  void onPanEnd(DragEndDetails details) {
  }

  void onTapDownAtack(TapDownDetails details){
    if (atackRect.contains(details.globalPosition)) {
      atack();
    }
  }

  void onTapUpAtack(TapUpDetails details){
  }

}