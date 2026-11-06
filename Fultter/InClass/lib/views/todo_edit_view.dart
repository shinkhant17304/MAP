import 'package:flutter/material.dart';
import 'package:inclass/model/todo_model.dart';

class TodoEditView extends StatefulWidget {
  final TodoModel task;

  const TodoEditView({super.key, required this.task});

  @override
  State<TodoEditView> createState() => _TodoEditViewState();
}

class _TodoEditViewState extends State<TodoEditView> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final newTitle = _titleController.text.trim();
                if (newTitle.isEmpty) {
                  return;
                }
                Navigator.pop(context, newTitle);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
