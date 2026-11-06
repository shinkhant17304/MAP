import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FitnessPage(),
    ));

class FitnessPage extends StatefulWidget {
  const FitnessPage({super.key});

  @override
  State<FitnessPage> createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final List<String> _workouts = [
    '💪 Push-ups & Core',
    '🏃 Outdoor Run',
    '🏋️ Dumbbell Squats',
    '🧘 Yoga & Stretch',
    '🔥 Jumping Jacks',
  ];

  int _selectedWorkoutIndex = 0;
  int _workoutMinutes = 15;
  String _bodySize = 'Medium';
  String _resultText = '';

  // 1. RANDOM NUMBER: Picks a random workout from the list
  void _pickRandomWorkout() {
    setState(() {
      _selectedWorkoutIndex = Random().nextInt(_workouts.length);
      _workoutMinutes = Random().nextInt(56) + 5;
    });
  }

  // 2. TEXTFIELD LOGIC: Calculates calories burned based on exercise duration
  void _calculateCalories() {
    final double? weight = double.tryParse(_weightController.text.trim());
    final double? height = double.tryParse(_heightController.text.trim());

    if (weight == null || weight <= 0 ||
        height == null || height <= 0) {
      setState(() {
        _resultText = 'Please enter valid weight and height values.';
      });
      return;
    }

    const int caloriesPerMinute = 8; // Average 8 calories/min
    final int totalCalories = _workoutMinutes * caloriesPerMinute;
    final double heightInMeters = height / 100;
    final double bmi = weight / (heightInMeters * heightInMeters);

    setState(() {
      _resultText = 'Workout: ${_workouts[_selectedWorkoutIndex]}\n'
          'Duration: $_workoutMinutes minutes\n'
          'Weight: ${weight.toStringAsFixed(1)} kg\n'
          'Height: ${height.toStringAsFixed(1)} cm\n'
          'Body Size: $_bodySize\n'
          'BMI: ${bmi.toStringAsFixed(1)}\n'
          'Est. Calories Burned: ~$totalCalories kcal';
    });
  }

  void _reset() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _resultText = '';
      _selectedWorkoutIndex = 0;
      _workoutMinutes = 15;
      _bodySize = 'Medium';
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏋️ Workout & Calorie Tracker'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column( // LAYOUT: Column (Vertical Stack)
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOPIC 1: ASSET IMAGE BANNER
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/fitness_banner.png',
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: Colors.teal.shade100,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, size: 36, color: Colors.teal),
                        SizedBox(width: 8),
                        Text('Ready for Today\'s Workout?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TOPIC 2 & 3: RANDOM WORKOUT SELECTOR + ROW LAYOUT
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row( // LAYOUT: Row (Horizontal alignment)
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _workouts[_selectedWorkoutIndex],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _pickRandomWorkout,
                      icon: const Icon(Icons.casino), // ICON
                      label: const Text('Random Exercise'), // BUTTON
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // RANDOM DURATION: Generates a workout duration from 5 to 60 minutes.
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Random Workout Duration',
                prefixIcon: Icon(Icons.timer, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              child: Text('$_workoutMinutes minutes'),
            ),
            const SizedBox(height: 16),

            // HUMAN BODY DETAILS: Collects weight, height, and clothing body size.
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      prefixIcon: Icon(Icons.monitor_weight, color: Colors.teal),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      prefixIcon: Icon(Icons.height, color: Colors.teal),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _bodySize,
              decoration: const InputDecoration(
                labelText: 'Body Size',
                prefixIcon: Icon(Icons.accessibility_new, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
              items: const ['Small', 'Medium', 'Large', 'Extra Large']
                  .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _bodySize = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // TOPIC 3 & 4: EXPANDED BUTTONS IN A ROW
            Row(
              children: [
                Expanded( // LAYOUT: Takes 50% width
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _calculateCalories,
                    icon: const Icon(Icons.local_fire_department),
                    label: const Text('Calculate Burn'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded( // LAYOUT: Takes 50% width
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // DYNAMIC RESULT DISPLAY
            if (_resultText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  border: Border.all(color: Colors.teal.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _resultText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}