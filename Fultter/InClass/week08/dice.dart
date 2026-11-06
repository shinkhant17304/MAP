import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const PracticeApp());
}

class PracticeApp extends StatelessWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LabPracticePage(),
    );
  }
}

class LabPracticePage extends StatefulWidget {
  const LabPracticePage({super.key});

  @override
  State<LabPracticePage> createState() => _LabPracticePageState();
}

class _LabPracticePageState extends State<LabPracticePage> {
  final TextEditingController _controller = TextEditingController();
  int? _randomNumber;
  String _resultText = '';

  final List<String> _assetImages = [
    'Image 1',
    'Image 2',
    'Image 3',
  ];
  int _currentImageIndex = 0;

  void _changeImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _assetImages.length;
    });
  }

  void _submit() {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      setState(() {
        _resultText = 'Please enter a value';
      });
      return;
    }

    final value = int.tryParse(input);

    if (value == null) {
      setState(() {
        _resultText = 'Please enter a valid number';
      });
      return;
    }

    setState(() {
      final randomNumber = Random().nextInt(10) + 1;
      _randomNumber = randomNumber;

      if (value == randomNumber) {
        _resultText = 'Correct! You guessed the number: $randomNumber';
      } else if (value < randomNumber) {
        _resultText = 'Too low! Try a higher number.';
      } else {
        _resultText = 'Too high! Try a lower number.';
      }
    });
  }

  void _clearAll() {
    setState(() {
      _controller.clear();
      _resultText = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset + Random + Layout Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.blue.shade100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          [Icons.image, Icons.landscape, Icons.photo][
                            _currentImageIndex
                          ],
                          size: 80,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _assetImages[_currentImageIndex],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _changeImage,
              icon: const Icon(Icons.image_outlined),
              label: const Text('Change Asset Image'),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Answer',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          _randomNumber?.toString() ?? '?',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.help_outline,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter a number',
                hintText: 'Type here...',
                prefixIcon: Icon(Icons.edit, color: Colors.blue),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Submit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Clear'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_resultText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  _resultText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}