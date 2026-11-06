import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inclass/model/todo_model.dart';

class TodoController {
  static const String baseUrl = 'http://localhost:3000/todo';

  Future<List<TodoModel>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TodoModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> addTask(String title, DateTime deadline) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'title': title,
          'deadline': deadline.toIso8601String(),
          'complete': false,
          'favorite': false,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add new task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> toggleFavorite(String id, bool favorite) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'favorite': favorite}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> toggleComplete(String id, bool complete) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'complete': complete}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to toggle complete: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  Future<void> updateTask(String id, String title) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'title': title}),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Could not connect to the server.');
    }
  }

  int countAll(List<TodoModel> todos) => todos.length;
  int countPending(List<TodoModel> todos) => todos.where((t) => !t.complete).length;
  int countComplete(List<TodoModel> todos) => todos.where((t) => t.complete).length;
  int countFavorite(List<TodoModel> todos) => todos.where((t) => t.favorite).length;
}
