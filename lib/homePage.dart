// ignore_for_file: file_names

//import 'dart:async';

import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -5.9; // how strong is the gravity
  double velocity = 4.2; //how strong the jump is
  double birdWidth = 0.1; // out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; // out of 2, 2 being the entire height of the screen

//game settings
  bool gameHasStarted = false;

//barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; //out of 2
  List<List<double>> barrierHeight = [
//out of 2, where 2 is the entire height of the screen
// [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      // a real physical jump is the same as an upside down parabola
      //so ths is therefore a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      //print(birdY);

      //chceck f the bird is dead
      if (birdDead()) {
        timer.cancel();

        _showDialog();
      }

      //keep time going
      time += 0.01;
    });
  }

  void resetGame() {
    Navigator.pop(context); //dismmisses the alert dialog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.greenAccent,
              title: const Center(
                child: Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                    onTap: resetGame,
                    // ignore: prefer_const_constructors
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.all(17),
                        color: Colors.white,
                        child: const Text(
                          'PLAY AGAIN',
                          style: TextStyle(color: Colors.greenAccent),
                        ),
                      ),
                    ))
              ]);
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdDead() {
    //this wll check if the bird hits the top or the bottom of the screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    //hits barrier
    //checks f bird width x coordinates and y coordiantes of barriers
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierWidth[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    //check if bird is hitting barriers
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Stack(
                      children: [
                        Bird(
                          birdY: birdY,
                          birdHeight: birdHeight,
                          birdWidth: birdWidth,
                        ),

                        //tap to play
                        //       MyCoverScreen(gameHasStarted: gameHasStarted),

                        // top barrier 0
                        Barrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][0],
                            isThisBottomBarrier: true),

                        //bottom barrier
                        Barrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][1],
                            isThisBottomBarrier: true),

                        //top barrier 1
                        Barrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][0],
                            isThisBottomBarrier: true),

                        //bottom barrier 1
                        Barrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][1],
                            isThisBottomBarrier: true),

                        Container(
                          alignment: const Alignment(0, -0.5),
                          child: Text(gameHasStarted ? '' : "TAP TO PLAY",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20)),
                        )
                      ],
                    ),
                  )),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            )
          ],
        ),
      ),
    );
  }
}
