import 'dart:math';
import 'package:flutter/material.dart';

class RandomDemo extends StatefulWidget {
  const new({super.key});

  @override
  State<RandomDemo> createState() => _RandomDemoState();
}

class _RandomDemoState extends State<RandomDemo> {
  int num = 0;

  // run once before "build"
  // app life cycle
  // initState() => build() => dispose()
  @override
  void initState() {
    num = Random().nextInt(6) + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 16,),
              Text('Random number = $num', style: TextStyle(fontSize: 22),),
              SizedBox(height: 8,),
              ElevatedButton(onPressed: () {
                setState(() {
                  // 1-6
                  num = 1 + Random().nextInt(6);
                });
              }, child: Text('Generate')),
            ],
          ),
        ),
      ),
    );
  }
}