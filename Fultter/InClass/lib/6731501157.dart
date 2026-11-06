import 'dart:math';
import 'package:flutter/material.dart';

class Labtest_6731501157 extends StatefulWidget {
  const Labtest_6731501157({super.key});

  @override
  State<Labtest_6731501157> createState() => _Labtest_6731501157State();
}

class _Labtest_6731501157State extends State<Labtest_6731501157> {
  final TextEditingController _totalExpenseController = TextEditingController();

  final List<String> _friendNames = ['friend1', 'friend2', 'friend3'];
  final List<String> _friendImages = [
    'lib/Asset_images/friend1.png',
    'lib/Asset_images/friend2.png',
    'lib/Asset_images/friend3.png',
  ];
  final List<double> _percentages = [33.3, 33.3, 33.4];
  final List<Color> _cardColors = [
    const Color(0xFFE6C7D0),
    const Color(0xFFCFE9D6),
    const Color(0xFFC8DFF1),
  ];
  final List<Color> _dotColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  String _message = '';
  String _resultText = '';

  void _randomizePercentages() {
    final random = Random();
    final values = List<int>.generate(3, (_) => random.nextInt(41) + 20);
    final total = values.reduce((a, b) => a + b);

    setState(() {
      _message = '';
      _percentages[0] = values[0] * 100 / total;
      _percentages[1] = values[1] * 100 / total;
      _percentages[2] = values[2] * 100 / total;
      _resultText = '';
    });
  }

  void _calculateExpense() {
    final totalExpense = double.tryParse(_totalExpenseController.text.trim());

    if (totalExpense == null || totalExpense <= 0) {
      setState(() {
        _message = 'Error: no expense';
        _resultText = '';
      });
      return;
    }

    final values = List.generate(3, (index) {
      return (totalExpense * _percentages[index]) / 100;
    });

    setState(() {
      _message = '';
      _resultText = 'Splits -> F1: \$${values[0].toStringAsFixed(2)}, '
          'F2: \$${values[1].toStringAsFixed(2)}, '
          'F3: \$${values[2].toStringAsFixed(2)}';
    });
  }

  void _reset() {
    setState(() {
      _totalExpenseController.clear();
      _percentages[0] = 33.3;
      _percentages[1] = 33.3;
      _percentages[2] = 33.4;
      _message = '';
      _resultText = '';
    });
  }

  Widget _avatar(int index) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          _friendImages[index],
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text('🙂', style: TextStyle(fontSize: 40)),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _totalExpenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 181, 221),
      body: Center(
        child: Container(
          width: 700,
          height: 760,
          color: const Color(0xFFF5F4F5),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          child: Column(
            children: [
              const SizedBox(height: 8),

              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quiz 3: Expense Sharing App',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 480,
                child: TextField(
                  controller: _totalExpenseController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: 'Total Expense (\$)',
                    hintStyle: TextStyle(fontSize: 18, color: Colors.black54),
                    filled: true,
                    fillColor: Color(0xFFF6F5F3),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final amount = _percentages[index].round();
                  return Container(
                    width: 150,
                    height: 180,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: _cardColors[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _friendNames[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _avatar(index),
                        const SizedBox(height: 8),
                        Text(
                          '$amount%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Divider(
                          thickness: 1.2,
                          color: Colors.black.withOpacity(0.6),
                          indent: 20,
                          endIndent: 20,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _smallButton('Random', _randomizePercentages),
                  const SizedBox(width: 14),
                  _smallButton('Calculate', _calculateExpense),
                  const SizedBox(width: 14),
                  _smallButton('Reset', _reset),
                ],
              ),
              if (_message.isNotEmpty) ...[
                const SizedBox(height: 18),
                Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              if (_resultText.isNotEmpty) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _resultText,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(10, (index) {
                    final color = index < ((_percentages[0].round() / 10).clamp(0, 10)).toInt()
                        ? _dotColors[0]
                        : index < ((_percentages[0].round() / 10 + _percentages[1].round() / 10).clamp(0, 10)).toInt()
                            ? _dotColors[1]
                            : _dotColors[2];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(Icons.circle, size: 14, color: color),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE0E1EA),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 17)),
    );
  }
}
