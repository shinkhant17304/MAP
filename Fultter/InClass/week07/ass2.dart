import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const ClickGameApp());
}

class ClickGameApp extends StatelessWidget {
  const ClickGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: const ClickGameCard(),
          ),
        ),
      ),
    );
  }
}

class ClickGameCard extends StatefulWidget {
  const ClickGameCard({super.key});

  @override
  State<ClickGameCard> createState() => _ClickGameCardState();
}

class _ClickGameCardState extends State<ClickGameCard> {
  Timer? _timer;
  int _timeInCentiseconds = 100; // 100 centiseconds = 1.00 second
  int _clicks = 0;
  bool _isPlaying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _timer?.cancel();
    setState(() {
      _timeInCentiseconds = 100;
      _clicks = 0;
      _isPlaying = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_timeInCentiseconds > 0) {
          _timeInCentiseconds--;
        } else {
          _isPlaying = false;
          _timer?.cancel();
        }
      });
    });
  }

  void _handleClick() {
    if (_isPlaying && _timeInCentiseconds > 0) {
      setState(() {
        _clicks++;
      });
    }
  }

  String get _formattedTime {
    return (_timeInCentiseconds / 100).toStringAsFixed(2);
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
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF6B6B),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'Click = $_clicks',
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
                onPressed: _handleClick,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8DC63F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                icon: const Icon(Icons.touch_app, size: 20),
                label: const Text(
                  'Click',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 16),

              OutlinedButton.icon(
                onPressed: _startGame,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF6B6B),
                  side: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text(
                  'PLAY',
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