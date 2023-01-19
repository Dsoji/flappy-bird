// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;

  const Bird(
      {super.key,
      this.birdY,
      required this.birdWidth,
      required this.birdHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      child: Image.asset(
        "assets/images/bird.png",
        width: MediaQuery.of(context).size.width * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
