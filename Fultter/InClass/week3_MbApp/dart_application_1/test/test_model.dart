import 'package:dart_application_1/model.dart';
import 'package:test/test.dart';

void main() {
  test('1. Create a new task should have a new task', () {
    Task task = Task("1", "Cooking", false);

    expect(task.id, "1");
    expect(task.title, "Cooking");
    expect(task.completed, false);
  });

    test('2. Get task should return a task', () {
    Task task = Task("1", "Cooking", false);
    expect(task.getTask(), "⌛ Cooking");
  });
}
