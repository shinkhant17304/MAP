import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inclass/model/todo_model.dart';

class TodoController {
  static const String baseUrl = String.fromEnvironment(
    'TODO_API_URL',
    defaultValue: 'http://localhost:3000/todo',
  );

  final http.Client? httpClient;
  final String _baseUrl;

  TodoController({this.httpClient, String? apiUrl})
    : _baseUrl = apiUrl ?? baseUrl;

  Future<http.Response> _request(
    String method,
    String url, {
    Object? body,
  }) async {
    final request = http.Request(method, Uri.parse(url));
    if (body != null) {
      request.headers['Content-Type'] = 'application/json; charset=UTF-8';
      request.body = jsonEncode(body);
    }
    final client = httpClient ?? http.Client();
    try {
      final streamedResponse = await client.send(request);
      return await http.Response.fromStream(streamedResponse);
    } finally {
      if (httpClient == null) client.close();
    }
  }

  // Get all tasks from json-server
  Future<List<TodoModel>> fetchTasks() async {
    final response = await _request('GET', _baseUrl);
    if (response.statusCode != 200) {
      throw Exception('Failed to load todos: ${response.statusCode}');
    }
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => TodoModel.fromJson(json)).toList();
  }

  // Add new task
  Future<void> addTask(String title, DateTime deadline) async {
    final response = await _request(
      'POST',
      _baseUrl,
      body: {
        'title': title,
        'deadline': deadline.toIso8601String(),
        'complete': false,
        'favorite': false,
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add new task: ${response.statusCode}');
    }
  }

  // Delete task
  Future<void> deleteTask(String id) async {
    final response = await _request('DELETE', '$_baseUrl/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task: ${response.statusCode}');
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(String id, bool favorite) async {
    final response = await _request(
      'PATCH',
      '$_baseUrl/$id',
      body: {'favorite': favorite},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle favorite: ${response.statusCode}');
    }
  }

  // Toggle complete
  Future<void> toggleComplete(String id, bool complete) async {
    final response = await _request(
      'PATCH',
      '$_baseUrl/$id',
      body: {'complete': complete},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle complete: ${response.statusCode}');
    }
  }

  // Update task title
  Future<void> updateTask(String id, String title) async {
    final response = await _request(
      'PATCH',
      '$_baseUrl/$id',
      body: {'title': title},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  }

  // --- ADDED STATUS COUNT HELPER METHODS ---
  int countAll(List<TodoModel> todos) => todos.length;
  int countPending(List<TodoModel> todos) =>
      todos.where((t) => !t.complete).length;
  int countComplete(List<TodoModel> todos) =>
      todos.where((t) => t.complete).length;
  int countFavorite(List<TodoModel> todos) =>
      todos.where((t) => t.favorite).length;

  List<TodoModel> searchTasks(List<TodoModel> todos, String query) {
    final searchTerm = query.trim().toLowerCase();
    if (searchTerm.isEmpty) return todos;
    return todos
        .where((task) => task.title.toLowerCase().contains(searchTerm))
        .toList();
  }
}
