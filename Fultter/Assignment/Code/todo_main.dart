// todo_main.dart
// Console menu for the To-Do application.

import 'dart:io';
import 'todo_logic.dart';

final TaskRepository repo = TaskRepository();
late final TaskService service = TaskService(repo);

void main() {
  bool running = true;

  while (running) {
    printMenu();
    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        addTaskFlow();
        break;
      case '2':
        viewTasksFlow();
        break;
      case '3':
        deleteTaskFlow();
        break;
      case '4':
        toggleTaskFlow();
        break;
      case '5':
        editTaskFlow(); // a) Edit task
        break;
      case '6':
        searchTasksFlow(); // b) Search tasks
        break;
      case '7':
        clearAllFlow();
        break;
      case '0':
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid choice. Please try again.\n');
    }
  }
}

void printMenu() {
  print('\n===== TO-DO APP MENU =====');
  print('1. Add Task');
  print('2. View Tasks');
  print('3. Delete Task');
  print('4. Toggle Task Status');
  print('5. Edit Task');
  print('6. Search Tasks');
  print('7. Clear All Tasks');
  print('0. Exit');
  stdout.write('Enter your choice: ');
}

void addTaskFlow() {
  stdout.write('Enter task title: ');
  final title = stdin.readLineSync() ?? '';
  if (title.trim().isEmpty) {
    print('Title cannot be empty.');
    return;
  }
  service.addTask(title.trim());
  print('Task added.');
}

void viewTasksFlow() {
  if (service.tasks.isEmpty) {
    print('No tasks.');
    return;
  }
  for (int i = 0; i < service.tasks.length; i++) {
    print('$i. ${service.tasks[i]}');
  }
}

void deleteTaskFlow() {
  stdout.write('Enter task ID to delete: ');
  final id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('Invalid ID.');
    return;
  }
  final removed = service.deleteTask(id);
  print(removed != null ? 'Deleted: ${removed.title}' : 'Task not found.');
}

void toggleTaskFlow() {
  stdout.write('Enter task ID to toggle: ');
  final id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null || !service.toggleTask(id)) {
    print('Task not found.');
  } else {
    print('Task toggled.');
  }
}

// ---------- a) Edit Task flow ----------
void editTaskFlow() {
  stdout.write('Enter task ID to edit: ');
  final id = int.tryParse(stdin.readLineSync() ?? '');
  if (id == null) {
    print('Invalid ID.');
    return;
  }
  stdout.write('Enter new title: ');
  final newTitle = stdin.readLineSync() ?? '';
  final ok = service.editTask(id, newTitle);
  print(ok ? 'Task updated.' : 'Task not found or invalid title.');
}

// ---------- b) Search Tasks flow ----------
void searchTasksFlow() {
  stdout.write('Enter keyword to search: ');
  final keyword = stdin.readLineSync() ?? '';
  final results = service.search(keyword);
  if (results.isEmpty) {
    print('No tasks matched "$keyword".');
  } else {
    print('--- ${results.length} result(s) found ---');
    for (final t in results) {
      print(t);
    }
  }
}

void clearAllFlow() {
  service.clearAll();
  print('All tasks cleared.');
}