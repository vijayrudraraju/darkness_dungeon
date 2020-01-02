import 'package:darkness_dungeon/core/map/TileMap.dart';

class MyMaps {
  static List<List<TileMap>> mapOne() {
    return List.generate(16, (indexRow) {
      return List.generate(6, (indexColumm) {
        return TileMap('tile/floor_2.png');
      });
    });
  }
}