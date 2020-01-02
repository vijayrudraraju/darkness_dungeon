
import 'dart:async';

import 'package:darkness_dungeon/Menu.dart';
import 'package:darkness_dungeon/player/HealthBar.dart';
import 'package:darkness_dungeon/core/Controller.dart';
import 'package:darkness_dungeon/core/map/SimpleWorld.dart';
import 'package:darkness_dungeon/map/Simple.dart';
import 'package:darkness_dungeon/player/Knight.dart';
import 'package:darkness_dungeon/core/Player.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double DEFAULT_SIZE = 32;
const int ROWS = 16;
const int COLS = 6;
Size initSize = Size(
  DEFAULT_SIZE * COLS,
  DEFAULT_SIZE * ROWS
);

void main() async {
  //debugPaintSizeEnabled = true;
  debugPaintPointersEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.util.fullScreen();
  runApp(MaterialApp(
    home: GameWidget(size: initSize,),
  ));
}
  
class GameWidget extends StatefulWidget {
  final Size size;

  GameWidget({Key key, this.size}) : super(key: key);

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  DarknessDungeon game;
  final GlobalKey<HealthBarState> healthKey = GlobalKey();
  StreamController<bool> streamProgress = StreamController();

  @override
  void initState() {
    print("_GameWidgetState->initState() - widget.size:${widget.size}");
    print("_GameWidgetState->initState() - initSize:$initSize");

    game = DarknessDungeon(
        initSize,
        gameOver: (){
          _showDialogGameOver();
        },
        loaded: (){
          Future.delayed(Duration(milliseconds: 500),(){
            streamProgress.sink.add(false);
          });
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          game.widget,
          /*
          Align(
            alignment: Alignment.topLeft,
            child: HealthBar(
                key: healthKey
            ),
          ),
          */
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: game.controller.onPanStart,
                    onPanUpdate: game.controller.onPanUpdate,
                    onPanEnd: game.controller.onPanEnd,
                    onTapDown: game.controller.onTapDown,
                    onTapUp: game.controller.onTapUp,
                    child: Container()),
              ),
              Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: game.controller.onTapDownAtack,
                    onTapUp: game.controller.onTapUpAtack,
                    child: Container()),
              )
            ],
          )
        ],
      ),
    );
  }

  void _showDialogGameOver() {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/game_over.png',height: 100,),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  color: Colors.transparent,
                  onPressed: (){
                    healthKey.currentState.updateHealth(100);
                    healthKey.currentState.updateStamina(100);
                    game.resetGame();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "PLAY AGAIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Normal',
                      fontSize: 20.0
                    ),
                  ),
                )
              ],
            ),
          );
        });

  }

  Widget _buildProgress() {

    return StreamBuilder(
      stream: streamProgress.stream,
      initialData: true,
      builder: (context,snapshot){
        bool showProgress = true;

        if(snapshot.hasData){
          showProgress = snapshot.data;
        }

        return AnimatedOpacity(
          opacity: showProgress ? 1.0 : 0.0 ,
          duration: Duration(milliseconds: 500),
          child: Container(
            color: Colors.black,
            child: Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Normal',
                    fontSize: 20.0
                ),
              ),
            ),
          ),
        );
      },
    );

  }

  @override
  void dispose() {
    streamProgress.close();
    super.dispose();
  }
}

class DarknessDungeon extends BaseGame {
  Size size;

  final Function(double) changeLife;
  final Function(double) changeStamina;
  final Function() gameOver;
  final Function() loaded;

  Player player;
  SimpleWorld map;
  Controller controller;

  bool loadedControl = false;
  static const double INIT_X = 0;
  static const double INIT_Y = 0;

  @override
  bool debugMode() => true;

  DarknessDungeon(
    this.size, 
    {
      this.changeLife, 
      this.changeStamina, 
      this.gameOver, 
      this.loaded
    }
  ) {
    print("DarknessDungeon(...) - this.size:${this.size}");

    player = Knight(
        size,
        initX: INIT_X,
        initY: INIT_Y,
        changeLife: changeLife,
        changeStamina: changeStamina,
        callBackdie: (){
          if(gameOver != null){
            gameOver();
          }
        }
    );

    map = SimpleWorld(
      MyMaps.mapOne(),
      player,
      size,
    );
    map.x = 170;
    map.y = 15;

    controller = Controller(
      size,
      size.height / 10,
      player.moveToTop,
      player.moveToBottom,
      player.moveToLeft,
      player.moveToRight,
      player.idle,
      player.atack
  );

    add(map);
    add(controller);
  }

  void resetGame(){
    player.reset(3,3);
    //map.resetMap(MyMaps.mapOne());
  }

  @override
  void resize(Size size) {
    this.size = size;
    super.resize(size);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if(!loadedControl){
      loadedControl = true;
      loaded();
    }
  }

}
