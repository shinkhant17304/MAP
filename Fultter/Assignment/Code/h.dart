// Unit test for testing logics, no user inputs
// dart test test/todo_test.dart --reporter=expanded
import 'package:test/test.dart';
import 'package:todo_app/lib/todo_logic.dart';
import 'package:todo_app/todo_model.dart';

void main() {
  group('Todo model test:', () {
    late Task task;
    setUp(() {
      task = Task('Call home');
    });

    test('Create task should have title and status', () {
      expect(task.title, equals('Call home'));
      expect(task.complete, isFalse);
    });

    test('Toggle task status should make the status changes', () {
      task.toggleStatus();
      expect(task.complete, isTrue);
      task.toggleStatus();
      expect(task.complete, isFalse);
    });

    test('Show task should have title and status', () {
      expect(task.toString(), contains('[ ]'));
      expect(task.toString(), contains('Call home'));
    });
  });

  group('Todo controller full tests:', () {
    late Todo todo;
    setUp(() {
      todo = Todo();
    });

    test('addTask should create new tasks', () {
      todo.addTask('Buy books');
      expect(todo.todos.length, equals(1));
      expect(todo.todos[0].toString(), contains('[ ] Buy books'));

      todo.addTask('Cook dinner');
      expect(todo.todos.length, equals(2));
    });

    test('deleteTask should remove and return the task at a valid index', () {
      todo.addTask('A');
      todo.addTask('B');

      final removed = todo.deleteTask(0);
      expect(removed, isNotNull);
      expect(removed?.title, equals('A'));
      expect(todo.todos.length, equals(1));
      expect(todo.todos[0].title, equals('B'));
    });

    test('deleteTask should return null for an invalid index', () {
      todo.addTask('A');
      expect(todo.deleteTask(10), isNull);
      expect(todo.deleteTask(-1), isNull);
      expect(todo.todos.length, equals(1));
    });

    test('toggleTask should flip the complete flag at a valid index', () {
      todo.addTask('Task');
      expect(todo.todos[0].complete, isFalse);

      final ok = todo.toggleTask(0);
      expect(ok, isTrue);
      expect(todo.todos[0].complete, isTrue);

      todo.toggleTask(0);
      expect(todo.todos[0].complete, isFalse);
    });

    test('toggleTask should return false for an invalid index', () {
      todo.addTask('Task');
      expect(todo.toggleTask(5), isFalse);
    });

    test('editTask should change the title at a valid index', () {
      todo.addTask('Old');

      final ok = todo.editTask(0, 'New');
      expect(ok, isTrue);
      expect(todo.todos[0].title, equals('New'));
    });

    test('editTask should return false for an invalid index', () {
      todo.addTask('Old');
      expect(todo.editTask(5, 'New'), isFalse);
      expect(todo.todos[0].title, equals('Old'));
    });

    test('editTask should return false for a blank new title', () {
      todo.addTask('Old');
      expect(todo.editTask(0, '   '), isFalse);
      expect(todo.todos[0].title, equals('Old'));
    });

    test('search should return tasks matching a partial title, possibly multiple', () {
      todo.addTask('Alpha');
      todo.addTask('Beta');
      todo.addTask('Alphabet');

      final res = todo.search('Alph');
      expect(res.length, equals(2));
      expect(res.map((t) => t.title), containsAll(['Alpha', 'Alphabet']));
    });

    test('search should be case-insensitive', () {
      todo.addTask('Study Flutter');
      final res = todo.search('flutter');
      expect(res.length, equals(1));
    });

    test('search should return an empty list when nothing matches', () {
      todo.addTask('Alpha');
      expect(todo.search('nonexistent'), isEmpty);
    });

    test('search should return an empty list for a blank query', () {
      todo.addTask('Alpha');
      expect(todo.search('   '), isEmpty);
    });

    test('clearAll should remove all tasks', () {
      todo.addTask('1');
      todo.addTask('2');
      todo.clearAll();
      expect(todo.todos, isEmpty);
    });

    test('clearAll should not throw when already empty', () {
      expect(() => todo.clearAll(), returnsNormally);
    });
  });
}