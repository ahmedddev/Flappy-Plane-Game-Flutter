import 'dart:async';

import 'package:flappy_plane/barriers.dart';
import 'package:flappy_plane/character.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static double charY = 0;
  double initialPos = charY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 2.5;
  double charWidth = 0.1;
  double charHeight = 0.1;
  int scoreCounter = 0;

  //game setting
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [.4, .4 + 1.5];
  static double barrierWidth = 0.5; //out of 2
  List<List<double>> barrierHeight = [
    //out of 2 , where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    scoreCounter = 1;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      // a real physical jump is the same as an upside down parabola
      // so this is a single quadratic equation
      height = gravity * time * time + velocity * time;
      setState(() {
        charY = initialPos - height;
      });

      // check if the character is dead
      if (charIsDead()) {
        timer.cancel();
        _showDialog();
      }

      // keep the map moving
      moveMap();

      // keep the time going
      time += 0.02;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      setState(() {
        barrierX[i] -= 0.06;
      });

      //if barrier exit the left part of screen keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      charY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = charY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
                child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                        padding: EdgeInsets.all(7),
                        color: Colors.white,
                        child: Text(
                          'PLAY AGAIN',
                          style: TextStyle(color: Colors.brown),
                        ))),
              )
            ],
          );
        });
  }

  bool charIsDead() {
    // check if the bird is hitting the top or the bottom of the screen
    if (charY < -1 || charY > 1) {
      // timer.cancel();
      return true;
    }

    // hits barriers
    //check if bird is with in x coordinates and y coordinates of barriers

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= charWidth &&
          barrierX[i] + barrierWidth >= -charWidth &&
          (charY <= -1 + barrierHeight[i][0] ||
              charY + charHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }

    // check if the char is hitting a barrier
    return false;
  }

  void jump() {
    time = 0;
    initialPos = charY;
    setState(() {
      scoreCounter++;
    });
    print(scoreCounter);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: gameHasStarted ? jump : startGame,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    color: scoreCounter >= 5 ? Colors.black : Colors.blue,
                    child: Center(
                      child: Stack(
                        children: [
                          MyCharacter(
                            charY: charY,
                            charHeight: charHeight,
                            charWidth: charWidth,
                          ),

                          // Top barrier 0
                          MyBarriers(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][0],
                            isThisBottomBarrier: false,
                            color:
                                scoreCounter >= 5 ? Colors.grey : Colors.green,
                          ),

                          // Bottom barrier 0
                          MyBarriers(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][1],
                            isThisBottomBarrier: true,
                            color:
                                scoreCounter >= 5 ? Colors.grey : Colors.green,
                          ),

                          // Top barrier 1
                          MyBarriers(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][0],
                            isThisBottomBarrier: false,
                            color:
                                scoreCounter >= 5 ? Colors.grey : Colors.green,
                          ),
                          // Bottom barrier 1
                          MyBarriers(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][1],
                            isThisBottomBarrier: true,
                            color:
                                scoreCounter >= 5 ? Colors.grey : Colors.green,
                          ),

                          Container(
                              alignment: Alignment(0, -0.5),
                              child: Text(
                                gameHasStarted ? "" : "T A P  T O  P L A Y ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                        ],
                      ),
                    ),
                  )),
              Container(
                height: 15,
                color: scoreCounter >= 5 ? Colors.grey : Colors.green,
              ),
              Expanded(
                  child: Container(
                color: Colors.brown,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SCORE',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            scoreCounter.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ],
                      ),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Best',
                      //       style: TextStyle(color: Colors.white, fontSize: 20),
                      //     ),
                      //     SizedBox(
                      //       height: 20,
                      //     ),
                      //     Text(
                      //       '10',
                      //       style: TextStyle(color: Colors.white, fontSize: 35),
                      //     ),
                      //   ],
                      // )
                    ]),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
