import 'package:flutter/material.dart';

class ContainerDemo extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.yellow,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(left: 8, top: 8),
        width: 200,
        height: 200,
        child: Image.network('https://www.iconarchive.com/download/i94308/bokehlicia/captiva/edit-gnote.128.png'),
      ),
    );
  }
}
