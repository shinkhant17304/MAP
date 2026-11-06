import 'package:flutter/material.dart';

import 'learn_view.dart';
import 'review_view.dart';
import 'profile_view.dart';
import 'learner_store.dart';

class BusuuMainShell extends StatefulWidget {
  const BusuuMainShell({super.key, required this.learner});

  final LearnerProfile learner;

  @override
  State<BusuuMainShell> createState() => _BusuuMainShellState();
}

class _BusuuMainShellState extends State<BusuuMainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    BusuuLearnView(learnerId: widget.learner.id),
    BusuuReviewView(),
    BusuuProfileView(profile: widget.learner),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0056C6), // Busuu Brand Blue
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            activeIcon: Icon(Icons.map),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            activeIcon: Icon(Icons.style),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
