import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final birdY;

  const Bird({super.key, this.birdY});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, birdY),
      height: 50,
      width: 50,
      child: Image.asset("asstes/flapbird.png"),
    );
  }
}
