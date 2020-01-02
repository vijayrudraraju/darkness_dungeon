import 'package:darkness_dungeon/core/map/TileMap.dart';
import 'package:darkness_dungeon/core/Player.dart';
import 'package:darkness_dungeon/core/Enemy.dart';
import 'package:darkness_dungeon/core/Decoration.dart';
import 'package:flame/components/component.dart';
import 'package:flutter/material.dart';

class SimpleWorld extends SpriteComponent {

  static const double INIT_PADDING_LEFT = 30;
  static const double INIT_PADDING_TOP = 50;

  List<List<TileMap>> map;
  final Size initSize;
  final Player player;

  double maxTop = INIT_PADDING_TOP;
  double maxLeft = INIT_PADDING_LEFT;

  bool maxRight = false;
  bool maxBottom = false;

  List<TileMap> tilesMap = List();
  List<Rect> collisionsRect = List();
  List<Enemy> enemies = List();
  List<TileDecoration> decorations = List();

  SimpleWorld(this.map, this.player, this.initSize) : super.square(initSize.width, "tile/empty.png") {
    debugMode = true;
    print("SimpleWorld(...)");
    initializeMap();
  }

  void initializeMap() {
    print("SimpleWorld->initializeMap() - player.position:${player.position}");
    print("SimpleWorld->initializeMap() - initSize:$initSize");
    print("SimpleWorld->initializeMap() - map.length:${map.length} map[0][0].size:${map[0][0].size}"); 

    //_confInitialCamera();
    tilesMap.clear();
    map.asMap().forEach((i, row) {
      row.asMap().forEach((j, tile) {
        tile.position = tile.position.translate(this.x + (tile.size * j), this.y + (tile.size * i));
        tilesMap.add(tile);
      });
    });
 
    print("tilesMap.length ${tilesMap.length}");
    print("${tilesMap[0].position}");
    print("${tilesMap[1].position}");
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    tilesMap.forEach((tile) => tile.render(canvas));

    player.render(canvas);
  }

  @override
  void update(double t) {
   player.updatePlayer(t, collisionsRect, enemies, decorations);
  }

}
