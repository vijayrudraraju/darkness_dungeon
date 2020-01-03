import 'package:darkness_dungeon/core/map/TileMap.dart';

import 'package:darkness_dungeon/enemies/GoblinEnemy.dart';

class MyMaps {
  static List<List<TileMap>> mapOne() {
    return List.generate(16, (indexRow) {
      return List.generate(6, (indexColumm) {
        if (indexRow == 6 && indexColumm == 3) {
          return TileMap('tile/floor_2.png', enemy: GoblinEnemy());
        } else {
          return TileMap('tile/floor_2.png');
        }
      });
    });
  }
}