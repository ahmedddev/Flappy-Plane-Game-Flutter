import 'package:flutter/material.dart';

class MyBarriers extends StatelessWidget {
  const MyBarriers(
      {Key? key,
      this.barrierWidth,
      this.barrierHeight,
      this.barrierX,
      this.color,
      required this.isThisBottomBarrier})
      : super(key: key);

  final Color? color;
  final barrierWidth;
  final barrierHeight;
  final barrierX;
  final bool isThisBottomBarrier;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      child: Container(
        color: color,
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
