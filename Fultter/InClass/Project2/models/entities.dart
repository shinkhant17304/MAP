enum UserRole { learner, admin }

enum CardType { text, image }

enum SessionStatus { active, completed, abandoned }

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.createdAt,
  });

  final int id;
  final String email;
  final String username;
  final String passwordHash;
  final UserRole role;
  final DateTime createdAt;
}

class Course {
  Course({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.description,
    required this.coverImagePath,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int createdBy;
  String title;
  String description;
  String coverImagePath;
  bool isActive;
  final DateTime createdAt;
  DateTime updatedAt;
}

class Flashcard {
  Flashcard({
    required this.id,
    required this.courseId,
    required this.type,
    required this.frontText,
    required this.frontImagePath,
    required this.backMeaning,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int courseId;
  CardType type;
  String frontText;
  String? frontImagePath;
  String backMeaning;
  bool isActive;
  final DateTime createdAt;
  DateTime updatedAt;
}

class StudySession {
  StudySession({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.startedAt,
    required this.status,
    this.endedAt,
  });

  final int id;
  final int userId;
  final int courseId;
  final DateTime startedAt;
  DateTime? endedAt;
  SessionStatus status;
}

class StudyAttempt {
  const StudyAttempt({
    required this.id,
    required this.sessionId,
    required this.flashcardId,
    required this.isCorrect,
    required this.answeredAt,
  });

  final int id;
  final int sessionId;
  final int flashcardId;
  final bool isCorrect;
  final DateTime answeredAt;
}

class CourseReview {
  CourseReview({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final int courseId;
  int rating;
  String comment;
  final DateTime createdAt;
  DateTime updatedAt;
}
