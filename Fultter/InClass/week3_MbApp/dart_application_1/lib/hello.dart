import 'dart:io';

import 'package:todo/logic.dart';
import 'package:todo/model.dart';

final apiService = ApiService();

void main() async {
  bool running = true;

  while (running) {
    print('\n===== TODO MENU =====');
    print('1. View all tasks');
    print('2. Add a task');
    print('3. Toggle task complete');
    print('4. Update a task');
    print('5. Delete a task');
    print('6. View tasks by priority');
    print('7. Exit');
    stdout.write('Choose an option: ');

    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await _viewAllTasks();
        break;
      case '2':
        await _addTask();
        break;
      case '3':
        await _toggleTask();
        break;
      case '4':
        await _updateTask();
        break;
      case '5':
        await _deleteTask();
        break;
      case '6':
        await _viewTasksByPriority();
        break;
      case '7':
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid option, please try again.');
    }
  }
}

Future<void> _viewAllTasks() async {
  final todos = await apiService.fetchTodos();
  print('\n--- All tasks ---');
  for (final task in todos) {
    print('[${task.id}] $task');
  }
}

Future<void> _addTask() async {
  stdout.write('Enter task title: ');
  final title = stdin.readLineSync() ?? '';

  final priority = _promptPriority();

  final newTask = await apiService.addTodo(title, priority: priority);
  print('Added: $newTask');
}

Future<void> _toggleTask() async {
  stdout.write('Enter task id to toggle: ');
  final id = stdin.readLineSync() ?? '';
  try {
    final toggled = await apiService.toggleComplete(id);
    print('Toggled: $toggled');
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> _updateTask() async {
  stdout.write('Enter task id to update: ');
  final id = stdin.readLineSync() ?? '';

  stdout.write('New title (leave blank to keep current): ');
  final title = stdin.readLineSync();

  stdout.write('Update priority? (y/n): ');
  final wantsPriority = (stdin.readLineSync() ?? '').trim().toLowerCase();
  final priority = wantsPriority == 'y' ? _promptPriority() : null;

  try {
    final updated = await apiService.updateTodo(
      id,
      title: (title == null || title.isEmpty) ? null : title,
      priority: priority,
    );
    print('Updated: $updated');
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> _deleteTask() async {
  stdout.write('Enter task id to delete: ');
  final id = stdin.readLineSync() ?? '';
  final deleted = await apiService.deleteTodo(id);
  print(deleted ? 'Task $id deleted.' : 'Task $id not found.');
}

Future<void> _viewTasksByPriority() async {
  final todos = await apiService.fetchTodosByPriority();
  print('\n--- Tasks by priority (High -> Low) ---');
  for (final task in todos) {
    print('[${task.id}] $task');
  }
}

/// Prompts the user for a priority level and parses it, defaulting to
/// Medium if the input is empty or unrecognized.
Priority _promptPriority() {
  stdout.write('Enter priority (High/Medium/Low): ');
  final input = stdin.readLineSync() ?? '';
  return PriorityX.fromString(input);
}