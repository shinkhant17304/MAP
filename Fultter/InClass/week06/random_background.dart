import 'dart:math';
import 'package:flutter/material.dart';

class RandomBackground extends StatefulWidget {
  const new({super.key});

  @override
  State<RandomBackground> createState() => _RandomBackgroundState();
}

class _RandomBackgroundState extends State<RandomBackground> {
  Color bgColor = Colors.blue;
  Random random = Random();
  int icons = 0;

  void changeBgColor() {
    // 0-255
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);

    setState(() {
      bgColor = Color.fromRGBO(r, g, b, 1);
      icons = random.nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        mainAxisAlignment: .center,
        children: [
          // generate number of random icons from 1 to 6
          for(int i=1; i<=icons; i++)
            Icon(Icons.card_giftcard, size: 40,)
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: changeBgColor, child: Icon(Icons.update),),
    );
  }
}