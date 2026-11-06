import 'package:test/test.dart';
import 'package:todo_app/todo_main.dart';

void main() {
  group('Todo controller full tests', () {
    late TaskRepository repo;
    late TaskService service;

    setUp(() {
      repo = TaskRepository();
      service = TaskService(repo);
    });

    test('addTask should add tasks', () {
      service.addTask('Buy books');
      expect(service.tasks.length, equals(1));
      expect(service.tasks[0].title, equals('Buy books'));

      service.addTask('Cook dinner');
      expect(service.tasks.length, equals(2));
    });

    test('deleteTask should remove and return task', () {
      service.addTask('A');
      service.addTask('B');

      final removed = service.deleteTask(0);
      expect(removed, isNotNull);
      expect(removed?.title, equals('A'));
      expect(service.tasks.length, equals(1));

      final none = service.deleteTask(10);
      expect(none, isNull);
    });

    test('toggleTask should flip complete flag', () {
      service.addTask('Task');
      expect(service.tasks[0].complete, isFalse);

      final ok = service.toggleTask(0);
      expect(ok, isTrue);
      expect(service.tasks[0].complete, isTrue);

      expect(service.toggleTask(5), isFalse);
    });

    test('editTask should change title via the controller', () {
      service.addTask('Old');

      final ok = service.editTask(0, 'New');
      expect(ok, isTrue);
      expect(service.tasks[0].title, equals('New'));

      // invalid index
      expect(service.editTask(5, 'X'), isFalse);

      // blank title rejected
      expect(service.editTask(0, '   '), isFalse);
      expect(service.tasks[0].title, equals('New')); // unchanged
    });

    test('search should return matching tasks via the controller', () {
      service.addTask('Alpha');
      service.addTask('Beta');
      service.addTask('Alphabet');

      final res = service.search('Alph');
      expect(res.length, equals(2));
      expect(res.map((t) => t.title), containsAll(['Alpha', 'Alphabet']));

      // case-insensitive
      expect(service.search('alpha').length, equals(2));

      // blank query returns empty
      expect(service.search('   '), isEmpty);
    });

    test('clearAll should remove all tasks', () {
      service.addTask('1');
      service.addTask('2');

      service.clearAll();
      expect(service.tasks, isEmpty);
    });
  });
}