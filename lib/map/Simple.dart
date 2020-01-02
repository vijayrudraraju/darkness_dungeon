
import 'dart:math';

import 'package:darkness_dungeon/core/Decoration.dart';
import 'package:darkness_dungeon/core/map/TileMap.dart';
import 'package:flutter/material.dart';
import 'package:flame/animation.dart' as FlameAnimation;


class MyMaps {
  static List<List<TileMap>> mapOne() {
    return List.generate(5, (indexRow) {
      return List.generate(5, (indexColumm) {
        return TileMap('tile/floor_2.png');
      });
    });
  }
}