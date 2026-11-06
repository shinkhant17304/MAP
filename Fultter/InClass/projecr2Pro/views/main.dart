import 'package:flutter/material.dart';

import 'auth_view.dart';
import 'main_shell.dart';
import 'admin_dashboard_view.dart';
import 'learner_store.dart';

void main() {
  runApp(const LanguageApp());
}

class LanguageApp extends StatelessWidget {
  const LanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning Platform',
      initialRoute: '/',
      routes: {
        '/': (context) => const BusuuAuthView(),
        '/main': (context) {
          final profile =
              ModalRoute.of(context)?.settings.arguments as LearnerProfile?;
          return profile == null
              ? const BusuuAuthView()
              : BusuuMainShell(learner: profile);
        },
        '/admin': (context) => const AdminDashboardView(),
      },
    );
  }
}
