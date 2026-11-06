import 'entities.dart';

class LearningStore {
  LearningStore._() {
    _seed();
  }

  static final LearningStore instance = LearningStore._();

  final List<AppUser> _users = [];
  final List<Course> _courses = [];
  final List<Flashcard> _cards = [];
  final List<StudySession> _sessions = [];
  final List<StudyAttempt> _attempts = [];
  final List<CourseReview> _reviews = [];
  AppUser? currentUser;
  int _userId = 1;
  int _courseId = 1;
  int _cardId = 1;
  int _sessionId = 1;
  int _attemptId = 1;
  int _reviewId = 1;

  List<AppUser> get users => List.unmodifiable(_users);
  List<AppUser> get learners =>
      List.unmodifiable(_users.where((u) => u.role == UserRole.learner));
  List<Course> get courses => List.unmodifiable(_courses);
  List<Course> get activeCourses =>
      List.unmodifiable(_courses.where((c) => c.isActive));
  List<Flashcard> get cards => List.unmodifiable(_cards);
  List<StudySession> get sessions => List.unmodifiable(_sessions);
  List<StudyAttempt> get attempts => List.unmodifiable(_attempts);
  List<CourseReview> get reviews => List.unmodifiable(_reviews);
  int get totalActiveCards => _cards.where((c) => c.isActive).length;

  AppUser? signIn(String usernameOrEmail, String password) {
    final login = usernameOrEmail.trim().toLowerCase();
    for (final user in _users) {
      if ((user.username.toLowerCase() == login ||
              user.email.toLowerCase() == login) &&
          user.passwordHash == _hash(password)) {
        currentUser = user;
        return user;
      }
    }
    return null;
  }

  AppUser? register(String username, String email, String password) {
    final name = username.trim();
    final address = email.trim().toLowerCase();
    if (_users.any(
      (u) =>
          u.username.toLowerCase() == name.toLowerCase() ||
          u.email.toLowerCase() == address,
    )) {
      return null;
    }
    final user = AppUser(
      id: _userId++,
      email: address,
      username: name,
      passwordHash: _hash(password),
      role: UserRole.learner,
      createdAt: DateTime.now(),
    );
    _users.add(user);
    currentUser = user;
    return user;
  }

  void signOut() => currentUser = null;

  Course? course(int id) {
    for (final item in _courses) {
      if (item.id == id) return item;
    }
    return null;
  }

  AppUser? user(int id) {
    for (final item in _users) {
      if (item.id == id) return item;
    }
    return null;
  }

  Flashcard? card(int id) {
    for (final item in _cards) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<Flashcard> cardsFor(int courseId, {bool activeOnly = true}) =>
      List.unmodifiable(
        _cards.where(
          (c) => c.courseId == courseId && (!activeOnly || c.isActive),
        ),
      );

  List<CourseReview> reviewsFor(int courseId) => List.unmodifiable(
    _reviews.where((r) => r.courseId == courseId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
  );

  CourseReview? reviewFor(int userId, int courseId) {
    for (final review in _reviews) {
      if (review.userId == userId && review.courseId == courseId) return review;
    }
    return null;
  }

  double ratingFor(int courseId) {
    final items = reviewsFor(courseId);
    if (items.isEmpty) return 0;
    return items.fold<int>(0, (sum, review) => sum + review.rating) /
        items.length;
  }

  StudySession startSession(int userId, int courseId) {
    final session = StudySession(
      id: _sessionId++,
      userId: userId,
      courseId: courseId,
      startedAt: DateTime.now(),
      status: SessionStatus.active,
    );
    _sessions.add(session);
    return session;
  }

  List<StudyAttempt> attemptsForSession(int sessionId) =>
      List.unmodifiable(_attempts.where((a) => a.sessionId == sessionId));

  void recordAttempt(int sessionId, int cardId, bool correct) {
    _attempts.add(
      StudyAttempt(
        id: _attemptId++,
        sessionId: sessionId,
        flashcardId: cardId,
        isCorrect: correct,
        answeredAt: DateTime.now(),
      ),
    );
  }

  void endSession(int sessionId, {required bool completed}) {
    for (final session in _sessions) {
      if (session.id == sessionId && session.status == SessionStatus.active) {
        session
          ..status = completed
              ? SessionStatus.completed
              : SessionStatus.abandoned
          ..endedAt = DateTime.now();
        return;
      }
    }
  }

  void saveReview(int userId, int courseId, int rating, String comment) {
    final old = reviewFor(userId, courseId);
    if (old != null) {
      old
        ..rating = rating
        ..comment = comment.trim()
        ..updatedAt = DateTime.now();
      return;
    }
    final now = DateTime.now();
    _reviews.add(
      CourseReview(
        id: _reviewId++,
        userId: userId,
        courseId: courseId,
        rating: rating,
        comment: comment.trim(),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Course addCourse(
    int adminId,
    String title,
    String description,
    String coverPath,
  ) {
    final now = DateTime.now();
    final item = Course(
      id: _courseId++,
      createdBy: adminId,
      title: title.trim(),
      description: description.trim(),
      coverImagePath: coverPath.trim(),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    _courses.add(item);
    return item;
  }

  void updateCourse(
    Course item,
    String title,
    String description,
    String coverPath,
    bool active,
  ) {
    item
      ..title = title.trim()
      ..description = description.trim()
      ..coverImagePath = coverPath.trim()
      ..isActive = active
      ..updatedAt = DateTime.now();
  }

  Flashcard addCard(int courseId, String front, String back, String imagePath) {
    final now = DateTime.now();
    final item = Flashcard(
      id: _cardId++,
      courseId: courseId,
      type: imagePath.trim().isEmpty ? CardType.text : CardType.image,
      frontText: front.trim(),
      frontImagePath: imagePath.trim().isEmpty ? null : imagePath.trim(),
      backMeaning: back.trim(),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    _cards.add(item);
    return item;
  }

  void updateCard(Flashcard item, String front, String back, String imagePath) {
    item
      ..frontText = front.trim()
      ..backMeaning = back.trim()
      ..frontImagePath = imagePath.trim().isEmpty ? null : imagePath.trim()
      ..type = imagePath.trim().isEmpty ? CardType.text : CardType.image
      ..updatedAt = DateTime.now();
  }

  int attemptsByUser(int userId) =>
      _attempts.where((a) => _sessionFor(a.sessionId)?.userId == userId).length;
  int sessionsByUser(int userId) => _sessions
      .where((s) => s.userId == userId && s.status == SessionStatus.completed)
      .length;
  int coursesDone(int userId) => _sessions
      .where((s) => s.userId == userId && s.status == SessionStatus.completed)
      .map((s) => s.courseId)
      .toSet()
      .length;
  double accuracyByUser(int userId) {
    final items = _attempts
        .where((a) => _sessionFor(a.sessionId)?.userId == userId)
        .toList();
    if (items.isEmpty) return 0;
    return items.where((a) => a.isCorrect).length / items.length;
  }

  int attemptsByCourse(int courseId) {
    final ids = _sessions
        .where((s) => s.courseId == courseId)
        .map((s) => s.id)
        .toSet();
    return _attempts.where((a) => ids.contains(a.sessionId)).length;
  }

  StudySession? _sessionFor(int id) {
    for (final session in _sessions) {
      if (session.id == id) return session;
    }
    return null;
  }

  String _hash(String input) {
    var value = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      value = ((value ^ unit) * 0x01000193) & 0xFFFFFFFF;
    }
    return value.toRadixString(16).padLeft(8, '0');
  }

  void _seed() {
    final now = DateTime.now();
    _users.add(
      AppUser(
        id: _userId++,
        email: 'admin@linguago.edu',
        username: 'admin',
        passwordHash: _hash('admin123'),
        role: UserRole.admin,
        createdAt: now,
      ),
    );
    _courses.addAll([
      Course(
        id: _courseId++,
        createdBy: 1,
        title: 'Thai for Daily Life',
        description:
            'Useful Thai words and phrases for everyday conversations.',
        coverImagePath: '',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Course(
        id: _courseId++,
        createdBy: 1,
        title: 'Thai Travel Essentials',
        description: 'Thai for transport, food, shopping, and directions.',
        coverImagePath: '',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Course(
        id: _courseId++,
        createdBy: 1,
        title: 'Thai Pronunciation',
        description: 'Practice Thai tones and clear pronunciation.',
        coverImagePath: '',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    ]);
    const daily = [
      ['สวัสดี', 'sa-wat-dee · Hello / Good morning'],
      ['ขอบคุณ', 'khàawp-khun · Thank you'],
      ['ใช่', 'châi · Yes'],
      ['ไม่เป็นไร', 'mâi-pen-rai · No problem'],
      ['ขอโทษ', 'khǎaw-thôot · Excuse me / Sorry'],
      ['สบายดีไหม', 'sa-baai-dee-mai · How are you?'],
      ['ลาก่อน', 'laa-gàawn · Goodbye'],
      ['เท่าไหร่', 'thâo-rài · How much?'],
      ['อร่อย', 'a-ròi · Delicious'],
      ['น้ำเปล่า', 'náam-plào · Drinking water'],
      ['ไม่เผ็ด', 'mâi-phèt · Not spicy'],
      ['ช่วยด้วย', 'chûay-dûay · Please help'],
    ];
    const travel = [
      ['สนามบิน', 'sa-nǎam-bin · Airport'],
      ['สถานีรถไฟ', 'sa-thǎa-nii-rót-fai · Train station'],
      ['เลี้ยวซ้าย', 'líaw-sáai · Turn left'],
      ['เลี้ยวขวา', 'líaw-khwǎa · Turn right'],
      ['ตรงไป', 'dtrong-bpai · Go straight'],
    ];
    const tones = [
      ['มา', 'maa · to come'],
      ['ม้า', 'máa · horse'],
      ['หมา', 'mǎa · dog'],
      ['ข้าว', 'khâao · rice'],
      ['เก้า', 'gâo · nine'],
    ];
    for (final pair in daily) {
      addCard(1, pair[0], pair[1], '');
    }
    for (final pair in travel) {
      addCard(2, pair[0], pair[1], '');
    }
    for (final pair in tones) {
      addCard(3, pair[0], pair[1], '');
    }
  }
}
