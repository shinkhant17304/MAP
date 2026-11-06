import 'package:flutter/material.dart';
import 'package:inclass/model/todo_model.dart';

class TodoDetailView extends StatelessWidget {
  final TodoModel task;

  const TodoDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Status: ${task.complete ? 'Complete' : 'Pending'}'),
            const SizedBox(height: 8),
            Text('Favorite: ${task.favorite ? 'Yes' : 'No'}'),
            const SizedBox(height: 8),
            Text('Deadline: ${task.deadline.toLocal().toString()}'),
          ],
        ),
      ),
    );
  }
}
