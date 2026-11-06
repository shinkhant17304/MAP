import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const CountdownApp());
}

class CountdownApp extends StatelessWidget {
  const CountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: const CountdownCard(),
          ),
        ),
      ),
    );
  }
}

class CountdownCard extends StatefulWidget {
  const CountdownCard({super.key});

  @override
  State<CountdownCard> createState() => _CountdownCardState();
}

class _CountdownCardState extends State<CountdownCard> {
  Timer? _timer;
  int _centiseconds = 100; // 100 centiseconds = 1.00 second
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning || _centiseconds <= 0) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_centiseconds > 0) {
          _centiseconds--;
        } else {
          _isRunning = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _centiseconds = 100;
      _isRunning = false;
    });
  }

  String get _formattedTime {
    return (_centiseconds / 100).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF5F7),
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formattedTime,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B52A1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                icon: const Icon(Icons.play_circle_fill, size: 20),
                label: const Text(
                  'Start',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 16),

              ElevatedButton.icon(
                onPressed: _resetTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5252),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text(
                  'Reset',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}