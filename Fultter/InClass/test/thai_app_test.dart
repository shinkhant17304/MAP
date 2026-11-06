import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Project2/main.dart';

void main() {
  testWidgets('learner registration opens the Thai learning dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(const ThaiLearningApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create an account'));
    await tester.tap(find.text('Create an account'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.ensureVisible(fields.at(0));
    await tester.enterText(fields.at(0), 'thai-learner');
    await tester.ensureVisible(fields.at(1));
    await tester.enterText(fields.at(1), 'thai-learner@example.com');
    await tester.ensureVisible(fields.at(2));
    await tester.enterText(fields.at(2), 'thai1234');
    await tester.ensureVisible(fields.at(3));
    await tester.enterText(fields.at(3), 'thai1234');
    await tester.ensureVisible(find.text('Register'));
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Hi, thai-learner 👋'), findsOneWidget);
    expect(find.text('Popular courses'), findsOneWidget);
    expect(find.text('Thai for Daily Life'), findsWidgets);
  });

  testWidgets('admin demo login opens the management dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(const ThaiLearningApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Admin: admin / admin123'));
    await tester.tap(find.text('Admin: admin / admin123'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('Manage Courses'), findsOneWidget);
  });
}