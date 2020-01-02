
import 'package:darkness_dungeon/core/Decoration.dart';
import 'package:darkness_dungeon/core/Enemy.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class TileMap {

  static const double DEFAULT_SIZE = 32;

  final String spriteImg;
  final bool collision;
  final Enemy enemy;
  final TileDecoration decoration;

  Rect position;
  Sprite _spriteTile;

  final double size;

  TileMap(this.spriteImg,{this.collision = false,this.enemy,this.decoration,this.size = TileMap.DEFAULT_SIZE}) {
    position = Rect.fromLTWH(0,0, size, size);
    if(spriteImg.isNotEmpty)
      _spriteTile = Sprite(spriteImg);
  }

  void render(Canvas canvas) {
    if(_spriteTile.loaded())
      _spriteTile.renderRect(canvas, position);
  }

}