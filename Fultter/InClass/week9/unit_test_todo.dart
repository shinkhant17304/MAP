import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:inclass/model/todo_model.dart';

import 'todo_controller.dart';

void main() {
  late TodoController todoController;
  late MockClient client;
  late List<Map<String, dynamic>> todos;
  var nextId = 4;

  setUp(() {
    todos = [
      {
        'id': '1',
        'title': 'Do homework',
        'deadline': '2026-10-16T00:00:00.000',
        'complete': false,
        'favorite': false,
      },
      {
        'id': '2',
        'title': 'Cook dinner',
        'deadline': '2026-10-16T00:00:00.000',
        'complete': false,
        'favorite': false,
      },
      {
        'id': '3',
        'title': 'Go jogging',
        'deadline': '2026-10-16T00:00:00.000',
        'complete': false,
        'favorite': false,
      },
    ];
    nextId = 4;
    client = MockClient((request) async {
      final segments = request.url.pathSegments;
      final id = segments.length > 1 ? segments.last : null;
      switch (request.method) {
        case 'GET':
          return http.Response(jsonEncode(todos), 200);
        case 'POST':
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          final task = {...body, 'id': '${nextId++}'};
          todos.add(task);
          return http.Response(jsonEncode(task), 201);
        case 'DELETE':
          final index = todos.indexWhere((task) => task['id'] == id);
          if (index < 0) return http.Response('', 404);
          todos.removeAt(index);
          return http.Response('{}', 200);
        case 'PATCH':
          final index = todos.indexWhere((task) => task['id'] == id);
          if (index < 0) return http.Response('', 404);
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          todos[index] = {...todos[index], ...body};
          return http.Response(jsonEncode(todos[index]), 200);
        default:
          return http.Response('', 405);
      }
    });
    todoController = TodoController(httpClient: client);
  });

  tearDown(() => client.close());
  test('1. Fetch todo should return Todo List', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    expect(todos.length, 3);
    expect(todos[0].id, '1');
    expect(todos[0].title, 'Do homework');
    expect(todos[0].complete, isFalse);
    expect(todos[0].favorite, isFalse);
    expect(todos[0].deadline.year, 2026);
  });

  test('2. Add task should have the new task', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    int before = todos.length;
    await todoController.addTask('Buy foods', DateTime(2026, 10, 14));
    todos = await todoController.fetchTasks();
    expect(todos.length, before + 1);
    expect(todos.last.title, 'Buy foods');
    expect(todos.last.deadline.year, 2026);
  });

  test('3. Delete task should remove the task', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    int before = todos.length;
    await todoController.deleteTask(todos.last.id);
    todos = await todoController.fetchTasks();
    expect(todos.length, before - 1);
  });

  test('4. Toggle favorite should switch the task favorite status', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    bool before = todos.last.favorite;
    await todoController.toggleFavorite(todos.last.id, !before);
    todos = await todoController.fetchTasks();
    expect(todos.last.favorite, !before);
  });

  test('5. Toggle complete should switch the task complete status', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    bool before = todos.last.complete;
    await todoController.toggleComplete(todos.last.id, !before);
    todos = await todoController.fetchTasks();
    expect(todos.last.complete, !before);
  });

  test('6. Update task title should have the updated title', () async {
    List<TodoModel> todos = await todoController.fetchTasks();
    await todoController.updateTask(todos.last.id, 'Go camping');
    todos = await todoController.fetchTasks();
    expect(todos.last.title, 'Go camping');
  });

  // --- ADDED UNIT TEST FOR TASK COUNTS ---
  test('7. Task status counts should accurately compute from task list', () {
    List<TodoModel> sampleList = [
      TodoModel(
        id: '1',
        title: 'Task 1',
        deadline: DateTime.now(),
        complete: false,
        favorite: false,
      ),
      TodoModel(
        id: '2',
        title: 'Task 2',
        deadline: DateTime.now(),
        complete: true,
        favorite: false,
      ),
      TodoModel(
        id: '3',
        title: 'Task 3',
        deadline: DateTime.now(),
        complete: true,
        favorite: true,
      ),
    ];

    expect(todoController.countAll(sampleList), 3);
    expect(todoController.countPending(sampleList), 1);
    expect(todoController.countComplete(sampleList), 2);
    expect(todoController.countFavorite(sampleList), 1);
  });

  test('8. Search tasks should match titles without case sensitivity', () {
    final taskList = [
      TodoModel(
        id: '1',
        title: 'Do homework',
        deadline: DateTime(2026, 10, 16),
      ),
      TodoModel(
        id: '2',
        title: 'Cook dinner',
        deadline: DateTime(2026, 10, 16),
      ),
      TodoModel(
        id: '3',
        title: 'Go jogging',
        deadline: DateTime(2026, 10, 16),
      ),
    ];

    expect(
      todoController.searchTasks(taskList, '  COOK '),
      hasLength(1),
    );
    expect(todoController.searchTasks(taskList, 'cook').single.title, 'Cook dinner');
    expect(todoController.searchTasks(taskList, ''), taskList);
  });
}
