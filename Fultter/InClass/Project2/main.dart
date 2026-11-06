import 'package:flutter/material.dart';

import 'views/auth_view.dart';
import 'views/common.dart';

void main() {
  runApp(const ThaiLearningApp());
}

class ThaiLearningApp extends StatelessWidget {
  const ThaiLearningApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'LinguaGo Thai',
    theme: appTheme(),
    home: const AuthView(),
  );
}
