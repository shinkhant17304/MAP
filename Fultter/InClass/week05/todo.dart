import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List<String> todos = [
    'Go shopping',
    'Have lunch',
    'Play football',
    'Do homework'
  ];
  final taskController = TextEditingController();

  void addTask() {
    String task = taskController.text.trim();
    if(task.isEmpty) {
      return;
    }
    setState(() {
      todos.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo app'),),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(child: TextField(controller: taskController,)),
              ElevatedButton(onPressed: addTask, child: Text('Add'))
            ],),
          ),
          SizedBox(height: 16,),
          for(String todo in todos)
            Text(todo)
          // Text(todos[0]),
          // Text(todos[1]),
          // Text(todos[2]),
        ],
      ),
    );
  }
}