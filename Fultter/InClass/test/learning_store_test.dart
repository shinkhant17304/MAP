import 'package:flutter_test/flutter_test.dart';

import '../Project2/models/entities.dart';
import '../Project2/models/learning_store.dart';

void main() {
  group('Thai learning ER store', () {
    final store = LearningStore.instance;

    test('only the admin account is seeded with demo credentials', () {
      expect(store.signIn('pyae', 'pyae123'), isNull);
      expect(store.signIn('admin', 'admin123')?.role, UserRole.admin);
      expect(store.signIn('admin', 'incorrect'), isNull);
    });

    test('registration creates a learner and rejects duplicate identity', () {
      final suffix = DateTime.now().microsecondsSinceEpoch;
      final username = 'learner-$suffix';
      final email = '$username@example.com';
      final user = store.register(username, email, 'thai1234');

      expect(user?.role, UserRole.learner);
      expect(user?.passwordHash, isNot('thai1234'));
      expect(store.register(username, 'other-$email', 'thai1234'), isNull);
    });

    test(
      'attempts link to a session and reviews update per user and course',
      () {
        final suffix = DateTime.now().microsecondsSinceEpoch;
        final learner = store.register(
          'study-$suffix',
          'study-$suffix@example.com',
          'thai1234',
        )!;
        final course = store.activeCourses.first;
        final card = store.cardsFor(course.id).first;
        final session = store.startSession(learner.id, course.id);

        store.recordAttempt(session.id, card.id, false);
        store.recordAttempt(session.id, card.id, true);
        store.endSession(session.id, completed: true);

        expect(store.attemptsForSession(session.id), hasLength(2));
        expect(store.attemptsForSession(session.id).last.flashcardId, card.id);
        expect(session.status, SessionStatus.completed);
        expect(session.endedAt, isNotNull);

        store.saveReview(learner.id, course.id, 4, 'Useful phrases.');
        store.saveReview(learner.id, course.id, 5, 'Very useful.');
        final review = store
            .reviewsFor(course.id)
            .singleWhere((item) => item.userId == learner.id);

        expect(review.rating, 5);
        expect(review.comment, 'Very useful.');
      },
    );
  });
}
