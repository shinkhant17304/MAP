import 'package:flutter/material.dart';

import '../models/entities.dart';
import '../models/learning_store.dart';
import 'auth_view.dart';
import 'common.dart';
import 'study_view.dart';

class LearnerView extends StatefulWidget {
  const LearnerView({super.key});

  @override
  State<LearnerView> createState() => _LearnerViewState();
}

class _LearnerViewState extends State<LearnerView> {
  final _store = LearningStore.instance;
  final _search = TextEditingController();
  final Set<int> _saved = {};
  int _tab = 0;
  String _filter = 'All';

  AppUser get _user => _store.currentUser ?? _store.learners.first;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _tab == 0
        ? null
        : AppBar(
            centerTitle: true,
            title: Text(
              ['Home', 'Courses', 'Study', 'Stats', 'Profile'][_tab],
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: IndexedStack(
          index: _tab,
          children: [_home(), _catalog(), _study(), _stats(), _profile()],
        ),
      ),
    ),
    bottomNavigationBar: NavigationBar(
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFE9ECFF),
      selectedIndex: _tab,
      onDestinationSelected: (index) => setState(() => _tab = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_rounded),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.bolt_outlined),
          selectedIcon: Icon(Icons.bolt_rounded),
          label: 'Study',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart_rounded),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    ),
  );

  Widget _home() {
    final courses = _store.activeCourses;
    if (courses.isEmpty) {
      return const Center(child: Text('No active courses yet.'));
    }
    final course = courses.first;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 19, 18, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${_user.username} 👋',
                    style: const TextStyle(
                      color: Palette.ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Keep learning, keep growing!',
                    style: TextStyle(color: Palette.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Avatar(name: _user.username),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          readOnly: true,
          onTap: () => setState(() => _tab = 1),
          decoration: inputStyle(
            'What do you want to learn?',
            prefix: const Icon(Icons.search_rounded, color: Palette.muted),
            suffix: const Icon(Icons.tune_rounded, size: 18),
          ),
        ),
        const SizedBox(height: 18),
        SectionTitle(
          'Languages',
          action: 'See all',
          onAction: () => setState(() => _tab = 1),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) => _LanguageTile(
              course: courses[index],
              onTap: () => _openCourse(courses[index]),
            ),
          ),
        ),
        const SizedBox(height: 17),
        SectionTitle(
          'Continue learning',
          action: 'View course',
          onAction: () => _openCourse(course),
        ),
        const SizedBox(height: 8),
        _ContinueCard(
          course: course,
          progress: _progress(course),
          onTap: () => _startStudy(course),
        ),
        const SizedBox(height: 16),
        SectionTitle(
          'Popular courses',
          action: 'See all',
          onAction: () => setState(() => _tab = 1),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 215,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            separatorBuilder: (_, _) => const SizedBox(width: 9),
            itemBuilder: (context, index) => SizedBox(
              width: 200,
              child: _PopularCard(
                course: courses[index],
                saved: _saved.contains(courses[index].id),
                onSave: () => _toggleSave(courses[index]),
                onTap: () => _openCourse(courses[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _catalog() {
    final query = _search.text.trim().toLowerCase();
    final courses = _store.activeCourses.where((course) {
      final matchesText =
          course.title.toLowerCase().contains(query) ||
          course.description.toLowerCase().contains(query);
      final matchesFilter =
          _filter == 'All' ||
          (_filter == 'Saved' && _saved.contains(course.id)) ||
          (_filter == 'Beginner' && course.id == 1);
      return matchesText && matchesFilter;
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 7),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: inputStyle(
              'Search Thai courses...',
              prefix: const Icon(Icons.search_rounded, color: Palette.muted),
            ),
          ),
        ),
        SizedBox(
          height: 39,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: [
              for (final item in ['All', 'Beginner', 'Saved'])
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: ChoiceChip(
                    label: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    selected: item == _filter,
                    onSelected: (_) => setState(() => _filter = item),
                    selectedColor: Palette.blue,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: item == _filter ? Colors.white : Palette.ink,
                    ),
                    side: BorderSide(
                      color: item == _filter ? Palette.blue : Palette.line,
                    ),
                    showCheckmark: false,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 7, 18, 8),
          child: Row(
            children: [
              Text(
                '${courses.length} courses',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Text(
                'Recommended',
                style: TextStyle(color: Palette.muted, fontSize: 9),
              ),
            ],
          ),
        ),
        Expanded(
          child: courses.isEmpty
              ? const Center(
                  child: Text(
                    'No courses match your search.',
                    style: TextStyle(color: Palette.muted),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  itemCount: courses.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _CatalogCard(
                    course: courses[index],
                    saved: _saved.contains(courses[index].id),
                    onSave: () => _toggleSave(courses[index]),
                    onTap: () => _openCourse(courses[index]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _study() {
    final sessions = _store.sessions
        .where((session) => session.userId == _user.id)
        .toList()
        .reversed
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      children: [
        const Text(
          'Build a daily habit',
          style: TextStyle(
            color: Palette.ink,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Choose a course and begin a focused session.',
          style: TextStyle(color: Palette.muted, fontSize: 11),
        ),
        const SizedBox(height: 13),
        for (final course in _store.activeCourses) ...[
          _StudyCourse(course: course, onStart: () => _startStudy(course)),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        const SectionTitle('Recent sessions'),
        const SizedBox(height: 6),
        if (sessions.isEmpty)
          const Panel(
            child: Text(
              'Your study sessions will appear here.',
              style: TextStyle(color: Palette.muted, fontSize: 11),
            ),
          ),
        for (final session in sessions.take(5)) _SessionRow(session: session),
      ],
    );
  }

  Widget _stats() {
    final attempts = _store.attempts
        .where(
          (attempt) => _store.sessions.any(
            (session) =>
                session.id == attempt.sessionId && session.userId == _user.id,
          ),
        )
        .toList();
    final accuracy = _store.accuracyByUser(_user.id);
    final week = List<int>.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: 6 - index));
      return attempts
          .where(
            (attempt) =>
                attempt.answeredAt.year == day.year &&
                attempt.answeredAt.month == day.month &&
                attempt.answeredAt.day == day.day,
          )
          .length;
    });
    final maxValue = week.fold<int>(
      1,
      (max, value) => value > max ? value : max,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
      children: [
        const Text(
          'Your progress',
          style: TextStyle(
            color: Palette.ink,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Small steps make real progress.',
          style: TextStyle(color: Palette.muted, fontSize: 11),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Palette.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'THIS WEEK',
                style: TextStyle(
                  color: Color(0xFFDCE2FF),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'You studied ${attempts.length} flashcards.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Keep showing up. Your Thai is growing.',
                style: TextStyle(color: Color(0xFFE2E6FF), fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.45,
          children: [
            Metric(
              icon: Icons.bolt_rounded,
              value: '${attempts.length}',
              label: 'Studied today',
              tint: Palette.blue,
            ),
            Metric(
              icon: Icons.menu_book_rounded,
              value: '${_store.coursesDone(_user.id)}',
              label: 'Courses done',
              tint: Palette.green,
            ),
            Metric(
              icon: Icons.bar_chart_rounded,
              value: '${(accuracy * 100).round()}%',
              label: 'Average score',
              tint: const Color(0xFFE6B842),
            ),
            Metric(
              icon: Icons.star_outline_rounded,
              value:
                  '${_store.reviews.where((r) => r.userId == _user.id).length}',
              label: 'Reviews',
              tint: const Color(0xFF8A71D7),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Study activity',
                style: TextStyle(
                  color: Palette.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Cards studied · last 7 days',
                style: TextStyle(color: Palette.muted, fontSize: 9),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var index = 0; index < week.length; index++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FractionallySizedBox(
                                    heightFactor: (week[index] / maxValue)
                                        .clamp(0.06, 1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: index == 6
                                            ? Palette.blue
                                            : const Color(0xFFC9D0F9),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _weekday(
                                  DateTime.now()
                                      .subtract(Duration(days: 6 - index))
                                      .weekday,
                                ),
                                style: const TextStyle(
                                  color: Palette.muted,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const SectionTitle('Recent activity'),
        if (attempts.isEmpty)
          const Panel(
            child: Text(
              'Complete a study session to see your activity.',
              style: TextStyle(color: Palette.muted, fontSize: 11),
            ),
          ),
        for (final attempt in attempts.reversed.take(5))
          _AttemptRow(attempt: attempt),
      ],
    );
  }

  Widget _profile() {
    final myReviews = _store.reviews.where((r) => r.userId == _user.id).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () =>
                _toast('Account settings are not connected in this demo.'),
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Column(
            children: [
              Avatar(name: _user.username, radius: 42),
              const SizedBox(height: 10),
              Text(
                _user.username,
                style: const TextStyle(
                  color: Palette.ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _user.email,
                style: const TextStyle(color: Palette.muted, fontSize: 11),
              ),
              const SizedBox(height: 8),
              _RolePill(label: 'Learner'),
            ],
          ),
        ),
        const SizedBox(height: 19),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _ProfileRow(
                icon: Icons.menu_book_outlined,
                label: 'My Courses',
                detail: '${_store.coursesDone(_user.id)} completed',
                onTap: () => setState(() => _tab = 1),
              ),
              const Divider(height: 1, indent: 52),
              _ProfileRow(
                icon: Icons.bar_chart_rounded,
                label: 'Study History',
                detail: '${_store.sessionsByUser(_user.id)} sessions',
                onTap: () => setState(() => _tab = 2),
              ),
              const Divider(height: 1, indent: 52),
              _ProfileRow(
                icon: Icons.star_outline_rounded,
                label: 'My Reviews',
                detail: '$myReviews reviews',
                onTap: () => setState(() => _tab = 1),
              ),
              const Divider(height: 1, indent: 52),
              _ProfileRow(
                icon: Icons.settings_outlined,
                label: 'Account Settings',
                detail: 'Manage your account',
                onTap: () =>
                    _toast('Account settings are not connected in this demo.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        OutlinedButton(
          onPressed: _logout,
          style: OutlinedButton.styleFrom(
            foregroundColor: Palette.red,
            backgroundColor: const Color(0xFFFFF8F8),
            side: const BorderSide(color: Color(0xFFF2DFE0)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Log out',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  double _progress(Course course) {
    final total = _store.cardsFor(course.id).length;
    if (total == 0) return 0;
    final sessionIds = _store.sessions
        .where((s) => s.userId == _user.id && s.courseId == course.id)
        .map((s) => s.id)
        .toSet();
    final mastered = _store.attempts
        .where((a) => sessionIds.contains(a.sessionId) && a.isCorrect)
        .map((a) => a.flashcardId)
        .toSet()
        .length;
    return (mastered / total).clamp(0, 1);
  }

  void _toggleSave(Course course) => setState(() {
    if (!_saved.add(course.id)) _saved.remove(course.id);
  });

  Future<void> _openCourse(Course course) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailView(
          courseId: course.id,
          userId: _user.id,
          isSaved: _saved.contains(course.id),
          onSave: () => _toggleSave(course),
        ),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _startStudy(Course course) async {
    final session = _store.startSession(_user.id, course.id);
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => StudyView(sessionId: session.id)),
    );
    if (mounted) setState(() {});
  }

  void _logout() {
    _store.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const AuthView()),
      (_) => false,
    );
  }

  void _toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class CourseDetailView extends StatefulWidget {
  const CourseDetailView({
    super.key,
    required this.courseId,
    required this.userId,
    required this.isSaved,
    required this.onSave,
  });

  final int courseId;
  final int userId;
  final bool isSaved;
  final VoidCallback onSave;

  @override
  State<CourseDetailView> createState() => _CourseDetailViewState();
}

class _CourseDetailViewState extends State<CourseDetailView> {
  final _store = LearningStore.instance;
  int _tab = 0;

  Course get _course => _store.course(widget.courseId)!;

  Future<void> _start() async {
    final session = _store.startSession(widget.userId, widget.courseId);
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => StudyView(sessionId: session.id)),
    );
    if (mounted) setState(() {});
  }

  Future<void> _review() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ReviewView(courseId: widget.courseId, userId: widget.userId),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cards = _store.cardsFor(widget.courseId);
    final reviews = _store.reviewsFor(widget.courseId);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 178,
                backgroundColor: Colors.white,
                leading: IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                ),
                actions: [
                  IconButton.filledTonal(
                    onPressed: widget.onSave,
                    tooltip: widget.isSaved
                        ? 'Remove saved course'
                        : 'Save course',
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    icon: Icon(
                      widget.isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: widget.isSaved ? Palette.red : Palette.ink,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 72, 12, 10),
                    child: CourseArt(course: _course, height: 126),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'THAI LANGUAGE',
                        style: TextStyle(
                          color: Palette.blue,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _course.title,
                        style: const TextStyle(
                          color: Palette.ink,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Wrap(
                        spacing: 7,
                        children: [
                          _Pill(
                            icon: Icons.signal_cellular_alt,
                            text: 'Beginner',
                          ),
                          _Pill(
                            icon: Icons.star_rounded,
                            text: _store.ratingFor(widget.courseId) == 0
                                ? 'New'
                                : '${_store.ratingFor(widget.courseId).toStringAsFixed(1)} (${reviews.length})',
                          ),
                          _Pill(
                            icon: Icons.style_outlined,
                            text: '${cards.length} cards',
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          for (var i = 0; i < 3; i++)
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _tab = i),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _tab == i
                                            ? Palette.blue
                                            : Palette.line,
                                        width: _tab == i ? 2 : 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    ['About', 'Flashcards', 'Reviews'][i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _tab == i
                                          ? Palette.blue
                                          : Palette.muted,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      if (_tab == 0)
                        _about()
                      else if (_tab == 1)
                        _flashcards(cards)
                      else
                        _reviews(reviews),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _review,
                  icon: const Icon(Icons.star_outline_rounded, size: 17),
                  label: const Text('Review'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Palette.ink,
                    side: const BorderSide(color: Palette.line),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: cards.isEmpty ? null : _start,
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Start Learning'),
                    style: primaryButton(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _about() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        _course.description,
        style: const TextStyle(color: Palette.muted, height: 1.5, fontSize: 12),
      ),
      const SizedBox(height: 16),
      const Text(
        'What you will learn',
        style: TextStyle(
          color: Palette.ink,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 9),
      for (final text in [
        'Useful Thai vocabulary',
        'Clear pronunciation practice',
        'Common everyday phrases',
        'Confidence in daily conversations',
      ])
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Palette.green,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(color: Palette.muted, fontSize: 11),
              ),
            ],
          ),
        ),
    ],
  );

  Widget _flashcards(List<Flashcard> cards) => Column(
    children: [
      for (final card in cards.take(8))
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Panel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Text(
                  card.id.toString().padLeft(2, '0'),
                  style: const TextStyle(color: Palette.muted, fontSize: 9),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    card.frontText,
                    style: const TextStyle(
                      color: Palette.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    card.backMeaning.split(' · ').last,
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Palette.blue, fontSize: 9),
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );

  Widget _reviews(List<CourseReview> reviews) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.star_rounded, color: Palette.yellow),
          const SizedBox(width: 5),
          Text(
            _store.ratingFor(widget.courseId) == 0
                ? 'New'
                : _store.ratingFor(widget.courseId).toStringAsFixed(1),
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 6),
          Text(
            '${reviews.length} reviews',
            style: const TextStyle(color: Palette.muted, fontSize: 10),
          ),
        ],
      ),
      const SizedBox(height: 9),
      if (reviews.isEmpty)
        const Text(
          'Be the first to review this course.',
          style: TextStyle(color: Palette.muted, fontSize: 11),
        ),
      for (final review in reviews.take(8))
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Avatar(
            name: _store.user(review.userId)?.username ?? 'L',
            radius: 18,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  _store.user(review.userId)?.username ?? 'Learner',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Rating(review.rating.toDouble(), size: 13),
            ],
          ),
          subtitle: Text(
            review.comment,
            style: const TextStyle(color: Palette.muted, fontSize: 10),
          ),
        ),
    ],
  );
}

class ReviewView extends StatefulWidget {
  const ReviewView({super.key, required this.courseId, required this.userId});

  final int courseId;
  final int userId;

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final _store = LearningStore.instance;
  final _comment = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    final review = _store.reviewFor(widget.userId, widget.courseId);
    if (review != null) {
      _rating = review.rating;
      _comment.text = review.comment;
    }
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = _store.course(widget.courseId)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Write a review',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              Panel(
                padding: const EdgeInsets.all(9),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: CourseArt(
                        course: course,
                        height: 66,
                        compact: true,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THAI · BEGINNER',
                            style: TextStyle(
                              color: Palette.blue,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Rating(_store.ratingFor(course.id), size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'How was your experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.ink,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Your feedback helps other learners find the right course.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Palette.muted, fontSize: 10),
              ),
              const SizedBox(height: 22),
              Panel(
                color: const Color(0xFFF1F3FF),
                child: Column(
                  children: [
                    const Text(
                      'Your rating',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 1; i <= 5; i++)
                          IconButton(
                            onPressed: () => setState(() => _rating = i),
                            tooltip: '$i stars',
                            icon: Icon(
                              i <= _rating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 29,
                              color: i <= _rating
                                  ? Palette.yellow
                                  : const Color(0xFFCDD2DE),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      _rating == 0 ? 'Tap a star to rate' : '$_rating out of 5',
                      style: const TextStyle(color: Palette.muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 17),
              const Text(
                'Your review',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _comment,
                maxLines: 6,
                maxLength: 500,
                decoration: inputStyle(
                  'Share your experience with this course...',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Submit Review'),
                  style: primaryButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a star rating first.')),
      );
      return;
    }
    _store.saveReview(widget.userId, widget.courseId, _rating, _comment.text);
    Navigator.pop(context);
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.course, required this.onTap});
  final Course course;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      width: 104,
      child: Panel(
        padding: const EdgeInsets.all(9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TH',
              style: TextStyle(
                color: Palette.blue,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              course.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.course,
    required this.progress,
    required this.onTap,
  });
  final Course course;
  final double progress;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Palette.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Container(
          width: 54,
          height: 88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Palette.blueDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'ก',
            style: TextStyle(
              color: Palette.yellow,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'THAI · BEGINNER',
                style: TextStyle(
                  color: Color(0xFFDCE2FF),
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                course.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      color: Palette.yellow,
                      backgroundColor: Colors.white24,
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                child: FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.play_arrow_rounded, size: 16),
                  label: const Text('Continue'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Palette.yellow,
                    foregroundColor: Palette.ink,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PopularCard extends StatelessWidget {
  const _PopularCard({
    required this.course,
    required this.saved,
    required this.onSave,
    required this.onTap,
  });
  final Course course;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: Panel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CourseArt(course: course, height: 112),
              Positioned(
                right: 4,
                top: 4,
                child: IconButton.filledTonal(
                  onPressed: onSave,
                  tooltip: saved ? 'Remove saved course' : 'Save course',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(32, 32),
                    padding: EdgeInsets.zero,
                  ),
                  icon: Icon(
                    saved
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: saved ? Palette.red : Palette.ink,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BEGINNER',
                  style: TextStyle(
                    color: Palette.blue,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Rating(
                      LearningStore.instance.ratingFor(course.id),
                      size: 12,
                    ),
                    const Spacer(),
                    Text(
                      '${LearningStore.instance.cardsFor(course.id).length} cards',
                      style: const TextStyle(color: Palette.muted, fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({
    required this.course,
    required this.saved,
    required this.onSave,
    required this.onTap,
  });
  final Course course;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Palette.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 92,
              child: CourseArt(course: course, height: 102, compact: true),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BEGINNER',
                    style: TextStyle(
                      color: Palette.blue,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Palette.ink,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Palette.muted,
                      fontSize: 8,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Rating(LearningStore.instance.ratingFor(course.id), size: 12),
                ],
              ),
            ),
            IconButton(
              onPressed: onSave,
              tooltip: saved ? 'Remove saved course' : 'Save course',
              icon: Icon(
                saved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: saved ? Palette.red : Palette.muted,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _StudyCourse extends StatelessWidget {
  const _StudyCourse({required this.course, required this.onStart});
  final Course course;
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(9),
    child: Row(
      children: [
        SizedBox(
          width: 68,
          child: CourseArt(course: course, height: 68, compact: true),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${LearningStore.instance.cardsFor(course.id).length} flashcards · Thai',
                style: const TextStyle(color: Palette.muted, fontSize: 9),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 28,
                child: FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow_rounded, size: 15),
                  label: const Text('Study now'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Palette.blue,
                    textStyle: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Palette.line),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Palette.blue),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Palette.muted,
            fontSize: 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _RolePill extends StatelessWidget {
  const _RolePill({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFE9ECFF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Palette.blue,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.detail,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String detail;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: ListTile(
      onTap: onTap,
      dense: true,
      leading: Container(
        width: 33,
        height: 33,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 17, color: Palette.blue),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        detail,
        style: const TextStyle(color: Palette.muted, fontSize: 8),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Palette.muted,
        size: 17,
      ),
    ),
  );
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.session});
  final StudySession session;
  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    final course = store.course(session.courseId);
    final count = store.attemptsForSession(session.id).length;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE9ECFF),
        child: Icon(Icons.bolt_rounded, size: 17, color: Palette.blue),
      ),
      title: Text(
        course?.title ?? 'Thai course',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        '$count cards · ${session.startedAt.month}/${session.startedAt.day}',
        style: const TextStyle(color: Palette.muted, fontSize: 9),
      ),
      trailing: Text(
        session.status.name,
        style: const TextStyle(color: Palette.muted, fontSize: 8),
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.attempt});
  final StudyAttempt attempt;
  @override
  Widget build(BuildContext context) {
    final card = LearningStore.instance.card(attempt.flashcardId);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        attempt.isCorrect ? Icons.check_circle_rounded : Icons.refresh_rounded,
        color: attempt.isCorrect ? Palette.green : Palette.yellow,
        size: 19,
      ),
      title: Text(
        card?.frontText ?? 'Thai card',
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        card?.backMeaning ?? '',
        style: const TextStyle(color: Palette.muted, fontSize: 9),
      ),
    );
  }
}

String _weekday(int weekday) =>
    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][weekday - 1];
