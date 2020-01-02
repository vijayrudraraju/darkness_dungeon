import 'dart:async';
import 'dart:math';
import 'package:darkness_dungeon/core/Decoration.dart';
import 'package:darkness_dungeon/core/Direction.dart';
import 'package:darkness_dungeon/core/Enemy.dart';
import 'package:darkness_dungeon/core/ObjectCollision.dart';
import 'package:darkness_dungeon/core/map/MapWord.dart';
import 'package:darkness_dungeon/core/AnimationGameObject.dart';
import 'package:flutter/material.dart';
import 'package:flame/animation.dart' as FlameAnimation;

class Player extends AnimationGameObject with ObjectCollision {

  static const double INIT_PADDING_LEFT = 0;
  static const double INIT_PADDING_TOP = 0;

  double life;

  MapControll _mapControl;

  double stamina = 100;
  double costStamina = 15;

  final double size;
  final double damageAtack;
  final Size screenSize;
  final double speedPlayer;
  final Function(double) changeLife;
  final Function(double) changeStamina;
  final Function callBackdie;

  final FlameAnimation.Animation animationIdle;
  final FlameAnimation.Animation animationIdleLeft;
  final FlameAnimation.Animation animationMoveLeft;
  final FlameAnimation.Animation animationMoveRight;
  final FlameAnimation.Animation animationMoveTop;
  final FlameAnimation.Animation animationMoveBottom;
  final FlameAnimation.Animation animationDie;
  final FlameAnimation.Animation animationAtackLeft;
  final FlameAnimation.Animation animationAtackRight;
  final FlameAnimation.Animation animationAtackTop;
  final FlameAnimation.Animation animationAtackBottom;

  AnimationGameObject atackObject = AnimationGameObject();

  Direction lasDirection = Direction.right;
  Direction lasDirectionHotizontal = Direction.right;

  Timer _timerStamina;
  bool notifyDie = false;
  Rect initPosition;

  List<Enemy> _enemies = List();

  Player(
      this.size,
      this.screenSize,
      Rect position,
      this.animationIdle,
      {
        this.damageAtack = 1,
        this.life = 1,
        this.speedPlayer = 1,
        this.animationIdleLeft,
        this.animationMoveLeft,
        this.animationMoveRight,
        this.animationMoveTop,
        this.animationMoveBottom,
        this.animationDie,
        this.animationAtackLeft,
        this.animationAtackRight,
        this.animationAtackTop,
        this.animationAtackBottom,
        this.changeLife,
        this.changeStamina,
        this.callBackdie,
      }
      ){
    initPosition = position;
    this.position = position;
    print("Player(...) - this.position:${this.position}");
    animation = animationIdle;
    widthCollision = position.width;
    heightCollision = position.height/2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if(life > 0) {
      atackObject.render(canvas);
    }
  }

  void setMapControll(MapControll mapControl){
    _mapControl = mapControl;
  }

  void updatePlayer(double dt, List<Rect> collisionsMap, List<Enemy> enemies, List<TileDecoration> decorations) {
    super.update(dt);
    this.collisionsMap = collisionsMap;
    this._enemies = enemies;
    _updateAtackObject(dt);
  }

  void moveToTop() {
    if (life == 0) {
      return;
    }

    if (position.top <= INIT_PADDING_TOP) {
      return;
    }

    Rect displacement = position.translate(0, (speedPlayer * -1));
    if (verifyCollisionRect(displacement)) {
      return;
    }

    position = displacement;

    if (animationMoveTop != null && lasDirection != Direction.top) {
      lasDirection = Direction.top;
      animation = animationMoveTop;
      atackObject.animation = null;
    }
  }

  void moveToBottom() {
    if (life == 0) {
      return;
    }

    if (position.bottom >= screenSize.height) {
      return;
    }

    Rect displacement = position.translate(0, speedPlayer);
    //print("moveToBottom() - displacement.bottom:${displacement.bottom}");
    //print("moveToBottom() - position.top:${position.top}");
    //print("moveToBottom() - position.bottom:${position.bottom}");
    if (verifyCollisionRect(displacement)) {
      return;
    }

    position = displacement;

    if(animationMoveBottom != null && lasDirection != Direction.bottom){
      lasDirection = Direction.bottom;
      animation = animationMoveBottom;
      atackObject.animation = null;
    }

  }

  void moveToLeft() {
    if (life == 0) {
      return;
    }

    if (position.left <= INIT_PADDING_LEFT) {
      return;
    }

    Rect displacement = position.translate((speedPlayer * -1), 0);
    if (verifyCollisionRect(displacement)) {
      return;
    }

    position = displacement;

    lasDirectionHotizontal = Direction.left;

    if(animationMoveLeft != null && lasDirection != Direction.left){
      lasDirection = Direction.left;
      animation = animationMoveLeft;
      atackObject.animation = null;
    }
  }

  void moveToRight() {
    if (life == 0) {
      return;
    }

    if (position.right >= screenSize.width) {
      return;
    }

    Rect displacement = position.translate(speedPlayer, 0);
    if (verifyCollisionRect(displacement)) {
      return;
    }

    position = displacement;

    lasDirectionHotizontal = Direction.right;

    if(animationMoveRight != null && lasDirection != Direction.right){
      lasDirection = Direction.right;
      animation = animationMoveRight;
      atackObject.animation = null;
    }
  }

  void idle(){
    if (life == 0) {
      return;
    }

    if(lasDirectionHotizontal == Direction.right) {
      animation = animationIdle;
    }else{
      animation = animationIdleLeft;
    }
  }

  void receiveAttack(double damage){
    life = life - damage;
    if (life < 0) {
      life = 0;
    }
    if (life == 0) {
      die();
    }
    if (changeLife != null && life != 0) {
      changeLife(life);
    }
  }

  void die() {
    if (callBackdie != null && !notifyDie) {
      notifyDie = true;
      callBackdie();
    }
    animation = FlameAnimation.Animation.sequenced("crypt.png", 1,
        textureWidth: 16, textureHeight: 16);
  }

  void atack() {

    if(life <= 0){
      return;
    }

    startTimeStamina();

    if(stamina < costStamina){
      return;
    }

    stamina = stamina - costStamina;

    if (changeStamina != null) {
      changeStamina(stamina);
    }

    switch(lasDirection){
      case Direction.top: atackObject.animation = animationAtackTop; break;
      case Direction.bottom: atackObject.animation = animationAtackBottom; break;
      case Direction.left: atackObject.animation = animationAtackLeft; break;
      case Direction.right: atackObject.animation = animationAtackRight; break;
    }

    atackObject.animation.clock = 0;
    atackObject.animation.currentIndex = 0;
    atackObject.animation.loop = true;


    double damageMin = damageAtack /2;
    int p = Random().nextInt(damageAtack.toInt() + (damageMin.toInt()));
    double damage = damageMin + p;

    List<Enemy> enemyLife = _enemies.where((e)=>!e.isDie()).toList();
    enemyLife.forEach((enemy){
      if(atackObject.position.overlaps(enemy.getCurrentPosition())){
        enemy.receiveDamage(damage,lasDirection);
      }
    });

  }

  void startTimeStamina() {
    if(_timerStamina != null && _timerStamina.isActive){
      return;
    }
    _timerStamina = Timer.periodic(new Duration(milliseconds: 150), (timer) {
      if(life == 0){
        return;
      }

      stamina = stamina +1.5;
      if(stamina > 100){
        stamina = 100;
      }

      if (changeStamina != null) {
        changeStamina(stamina);
      }
    });
  }

  void reset(double x, double y){

    notifyDie = false;
    this.animation = animationIdle;
    this.position = initPosition;
    stamina = 100;
    life = 100;
  }

  void _updateAtackObject(double dt) {
    double top = position.top;
    double left = position.left;
    switch(lasDirection){
      case Direction.top: top = top-size; break;
      case Direction.bottom: top = top+size; break;
      case Direction.left: left = left-size; break;
      case Direction.right: left = left+size; break;
    }

    if(position != null){
      atackObject.position = Rect.fromLTWH(
          left,
          top,
          size,
          size
      );
    }

    atackObject.update(dt);

    if(atackObject.animation != null){
      if(atackObject.animation.isLastFrame){
        atackObject.animation.loop = false;
      }
    }
  }

}
