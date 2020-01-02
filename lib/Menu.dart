
import 'package:darkness_dungeon/main.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:flame/animation.dart' as FlameAnimation;

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                "Signal V Noise",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Normal',
                    fontSize: 30.0
                )
            ),
            SizedBox(
              height: 20.0,
            ),
            Flame.util.animationAsWidget(
                Position(50,50),
                FlameAnimation.Animation.sequenced(
                    "knight_run.png",
                    6,
                    textureWidth: 16,
                    textureHeight: 16
                )
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)
              ),
              color: Color.fromARGB(255, 118, 82, 78),
              child: Text("PLAY",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Normal',
                    fontSize: 18.0
                )
              ),
              onPressed: () async {
                Size size = await Flame.util.initialDimensions();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameWidget(size: size,)), // GameWidget
                ); 
              }
            )
          ],
        ),
      ),
    );
  }
}
