import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo/controller/todo_controller.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/views/todo_view.dart';

class MockTodoController extends Mock implements TodoController {}

void main() {
  late MockTodoController mockTodoController;

  setUp(() {
    mockTodoController = MockTodoController();
  });

  group('Todo Search Widget Tests', () {
    testWidgets('9. Shows error SnackBar when pressing Search with empty keyword', (WidgetTester tester) async {
      when(() => mockTodoController.getTasks()).thenAnswer((_) async => []);
      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Search'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOne);
      expect(find.text('Error: Enter search keyword'), findsOne);
    });

    testWidgets('10. Searching keyword displays matching tasks and Reset shows all tasks', (WidgetTester tester) async {
      final mockTodos = [
        TodoModel(id: 1, title: 'Cook dinner', deadline: DateTime(2026, 10, 31)),
        TodoModel(id: 2, title: 'Go camping', deadline: DateTime(2026, 12, 31)),
      ];

      when(() => mockTodoController.getTasks()).thenAnswer((_) async => mockTodos);
      when(() => mockTodoController.searchTasks('dinner')).thenAnswer((_) async => [mockTodos[0]]);

      await tester.pumpWidget(TodoView(todoController: mockTodoController));
      await tester.pumpAndSettle();

      expect(find.text('Cook dinner'), findsOne);
      expect(find.text('Go camping'), findsOne);

      await tester.enterText(find.widgetWithText(TextField, 'Search task'), 'dinner');
      await tester.tap(find.widgetWithText(FilledButton, 'Search'));
      await tester.pumpAndSettle();

      expect(find.text('Cook dinner'), findsOne);
      expect(find.text('Go camping'), findsNothing);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Cook dinner'), findsOne);
      expect(find.text('Go camping'), findsOne);
    });
  });
}