import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  const new({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;
  final inputController = TextEditingController();
  String errorText = '';

  // get the input
  void getNumber() {
    String input = inputController.text.trim();
    inputController.clear();

    // check empty input
    if(input.isEmpty) {
      setState(() {
        errorText = 'Error: no input';
      });
      return;
    }
    // check for integer input
    int? num = int.tryParse(input);
    if(num == null) {
      setState(() {
        errorText = 'Error: integer only';
      });
      return;
    }
    // update the counter
    setState(() {
      count = num;
      errorText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter app')),
      body: Column(
        children: [
          Text('Counter = $count'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                count = 0;
              });
            },
            child: Text('Reset'),
          ),
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: inputController,
              decoration: InputDecoration(
                hint: Text('Enter a number'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(onPressed: getNumber, child: Text('Submit')),
          Text(errorText)
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                count++;
              });
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                count--;
              });
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
