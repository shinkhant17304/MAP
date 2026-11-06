import 'package:flutter/material.dart';

import '../models/entities.dart';
import '../models/learning_store.dart';
import 'auth_view.dart';
import 'common.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _store = LearningStore.instance;
  final _courseSearch = TextEditingController();
  final _cardSearch = TextEditingController();
  int _tab = 0;
  int? _courseId;

  AppUser get _admin => _store.currentUser ?? _store.users.last;

  @override
  void dispose() {
    _courseSearch.dispose();
    _cardSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _tab == 0
        ? null
        : AppBar(
            centerTitle: true,
            title: Text(
              [
                'Dashboard',
                'Courses',
                'Flashcards',
                'Statistics',
                'Profile',
              ][_tab],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            actions: _tab == 1
                ? [
                    IconButton(
                      onPressed: _editCourse,
                      tooltip: 'Add course',
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ]
                : _tab == 2
                ? [
                    IconButton(
                      onPressed: _editCard,
                      tooltip: 'Add flashcard',
                      icon: const Icon(Icons.add_rounded),
                    ),
                  ]
                : null,
          ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: IndexedStack(
          index: _tab,
          children: [
            _dashboard(),
            _courses(),
            _flashcards(),
            _statistics(),
            _profile(),
          ],
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
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_rounded),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.style_outlined),
          selectedIcon: Icon(Icons.style_rounded),
          label: 'Cards',
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

  Widget _dashboard() => ListView(
    padding: const EdgeInsets.fromLTRB(18, 19, 18, 24),
    children: [
      const Text(
        'LINGUAGO ADMIN',
        style: TextStyle(
          color: Palette.blue,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
        ),
      ),
      const SizedBox(height: 4),
      Row(
        children: [
          const Expanded(
            child: Text(
              'Dashboard',
              style: TextStyle(
                color: Palette.ink,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Avatar(name: _admin.username),
        ],
      ),
      const SizedBox(height: 3),
      Text(_today(), style: const TextStyle(color: Palette.muted, fontSize: 9)),
      const SizedBox(height: 15),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Palette.blue,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WEEKLY OVERVIEW',
              style: TextStyle(
                color: Color(0xFFDCE2FF),
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Everything is looking good.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_store.sessions.length} study sessions · ${_store.attempts.length} flashcard attempts',
              style: const TextStyle(color: Color(0xFFE2E6FF), fontSize: 9),
            ),
          ],
        ),
      ),
      const SizedBox(height: 9),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.45,
        children: [
          Metric(
            icon: Icons.menu_book_rounded,
            value: '${_store.activeCourses.length}',
            label: 'Active courses',
            tint: Palette.blue,
          ),
          Metric(
            icon: Icons.people_outline_rounded,
            value: '${_store.learners.length}',
            label: 'Total learners',
            tint: const Color(0xFF8A71D7),
          ),
          Metric(
            icon: Icons.style_rounded,
            value: '${_store.totalActiveCards}',
            label: 'Flashcards',
            tint: const Color(0xFFE6B842),
          ),
          Metric(
            icon: Icons.bolt_rounded,
            value: '${_store.attempts.length}',
            label: 'Study records',
            tint: Palette.green,
          ),
        ],
      ),
      const SizedBox(height: 17),
      const SectionTitle('Quick actions'),
      const SizedBox(height: 8),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.65,
        children: [
          _Action(
            icon: Icons.menu_book_rounded,
            label: 'Manage Courses',
            onTap: () => setState(() => _tab = 1),
          ),
          _Action(
            icon: Icons.bolt_rounded,
            label: 'Manage Flashcards',
            onTap: () => setState(() => _tab = 2),
          ),
          _Action(
            icon: Icons.insights_rounded,
            label: 'Course Statistics',
            onTap: () => setState(() => _tab = 3),
          ),
          _Action(
            icon: Icons.bar_chart_rounded,
            label: 'Study Statistics',
            onTap: () => setState(() => _tab = 3),
          ),
        ],
      ),
      const SizedBox(height: 15),
      SectionTitle(
        'Recent activity',
        action: 'View all',
        onAction: () => setState(() => _tab = 3),
      ),
      const SizedBox(height: 6),
      if (_store.sessions.isEmpty)
        const Panel(
          child: Text(
            'New study sessions will appear here.',
            style: TextStyle(color: Palette.muted, fontSize: 10),
          ),
        ),
      for (final session in _store.sessions.reversed.take(4))
        _RecentSession(session: session),
    ],
  );

  Widget _courses() {
    final query = _courseSearch.text.trim().toLowerCase();
    final courses = _store.courses
        .where((c) => c.title.toLowerCase().contains(query))
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 7),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _courseSearch,
                  onChanged: (_) => setState(() {}),
                  decoration: inputStyle(
                    'Search courses...',
                    prefix: const Icon(
                      Icons.search_rounded,
                      color: Palette.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _editCourse,
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add'),
                style: primaryButton(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
          child: Row(
            children: [
              const Icon(
                Icons.filter_list_rounded,
                size: 15,
                color: Palette.muted,
              ),
              const SizedBox(width: 5),
              const Text(
                'All languages',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                '${courses.length} courses',
                style: const TextStyle(color: Palette.muted, fontSize: 9),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            itemCount: courses.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _CourseRow(
              course: courses[index],
              onCards: () => setState(() {
                _courseId = courses[index].id;
                _tab = 2;
              }),
              onEdit: () => _editCourse(course: courses[index]),
              onToggle: () => setState(() {
                courses[index].isActive = !courses[index].isActive;
                courses[index].updatedAt = DateTime.now();
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _flashcards() {
    final courses = _store.courses;
    if (courses.isEmpty) {
      return const Center(
        child: Text('Create a course before adding flashcards.'),
      );
    }
    final selectedId = courses.any((c) => c.id == _courseId)
        ? _courseId!
        : courses.first.id;
    final query = _cardSearch.text.trim().toLowerCase();
    final cards = _store
        .cardsFor(selectedId, activeOnly: false)
        .where(
          (c) =>
              c.frontText.toLowerCase().contains(query) ||
              c.backMeaning.toLowerCase().contains(query),
        )
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 9),
          child: Panel(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  color: Palette.blue,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedId,
                      isExpanded: true,
                      isDense: true,
                      items: [
                        for (final course in courses)
                          DropdownMenuItem(
                            value: course.id,
                            child: Text(
                              course.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() => _courseId = value),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cardSearch,
                  onChanged: (_) => setState(() {}),
                  decoration: inputStyle(
                    'Search flashcards...',
                    prefix: const Icon(
                      Icons.search_rounded,
                      color: Palette.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              IconButton.filled(
                onPressed: _editCard,
                tooltip: 'Add flashcard',
                style: IconButton.styleFrom(
                  backgroundColor: Palette.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 7),
          child: Row(
            children: [
              Text(
                'FRONT / BACK',
                style: TextStyle(
                  color: Palette.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Spacer(),
              Text(
                'ACTIONS',
                style: TextStyle(
                  color: Palette.muted,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: cards.isEmpty
              ? const Center(
                  child: Text(
                    'No flashcards in this course.',
                    style: TextStyle(color: Palette.muted, fontSize: 11),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  itemCount: cards.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 7),
                  itemBuilder: (context, index) => _FlashcardRow(
                    card: cards[index],
                    index: index + 1,
                    onEdit: () => _editCard(card: cards[index]),
                    onToggle: () => setState(() {
                      cards[index].isActive = !cards[index].isActive;
                      cards[index].updatedAt = DateTime.now();
                    }),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _statistics() {
    final ranked = [..._store.activeCourses]
      ..sort(
        (a, b) => _store
            .attemptsByCourse(b.id)
            .compareTo(_store.attemptsByCourse(a.id)),
      );
    final maxAttempts = ranked.isEmpty
        ? 1
        : ranked
              .map((c) => _store.attemptsByCourse(c.id))
              .fold<int>(1, (a, b) => a > b ? a : b);
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      children: [
        const Text(
          'Course statistics',
          style: TextStyle(
            color: Palette.ink,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
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
                'COURSE ENGAGEMENT',
                style: TextStyle(
                  color: Color(0xFFDCE2FF),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${_store.sessions.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Text(
                'Total study sessions',
                style: TextStyle(color: Color(0xFFE2E6FF), fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Learners per course',
                style: TextStyle(
                  color: Palette.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Ranked by study attempts',
                style: TextStyle(color: Palette.muted, fontSize: 9),
              ),
              const SizedBox(height: 13),
              for (final course in ranked) ...[
                _Engagement(course: course, maxAttempts: maxAttempts),
                const SizedBox(height: 9),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Course performance',
          style: TextStyle(
            color: Palette.ink,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < ranked.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: _Performance(course: ranked[i], rank: i + 1),
          ),
        const SizedBox(height: 10),
        const Text(
          'Learner activity',
          style: TextStyle(
            color: Palette.ink,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (_store.learners.isEmpty)
          const Panel(
            child: Text(
              'Learner activity will appear here.',
              style: TextStyle(color: Palette.muted, fontSize: 10),
            ),
          ),
        for (final learner in _store.learners)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Avatar(name: learner.username, radius: 18),
            title: Text(
              learner.username,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              '${_store.attemptsByUser(learner.id)} cards studied · ${_store.sessionsByUser(learner.id)} sessions',
              style: const TextStyle(color: Palette.muted, fontSize: 8),
            ),
            trailing: Text(
              '${(_store.accuracyByUser(learner.id) * 100).round()}%',
              style: const TextStyle(
                color: Palette.blue,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }

  Widget _profile() => ListView(
    padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
    children: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          onPressed: () =>
              _toast('Admin settings are not connected in this demo.'),
          tooltip: 'Admin settings',
          icon: const Icon(Icons.settings_outlined),
        ),
      ),
      const SizedBox(height: 4),
      Center(
        child: Column(
          children: [
            Avatar(name: _admin.username, radius: 42),
            const SizedBox(height: 10),
            const Text(
              'Admin User',
              style: TextStyle(
                color: Palette.ink,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _admin.email,
              style: const TextStyle(color: Palette.muted, fontSize: 10),
            ),
            const SizedBox(height: 7),
            const _AdminPill(),
          ],
        ),
      ),
      const SizedBox(height: 19),
      Panel(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            for (final item in [
              'Admin Settings',
              'Team Access',
              'Activity Log',
              'Help Center',
            ])
              _AdminRow(
                label: item,
                onTap: () => item == 'Activity Log'
                    ? setState(() => _tab = 3)
                    : _toast('$item is not connected in this demo.'),
                last: item == 'Help Center',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Log out',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    ],
  );

  Future<void> _editCourse({Course? course}) async {
    final result = await showModalBottomSheet<_CourseInput>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => _CourseForm(course: course),
    );
    if (result == null) return;
    setState(() {
      if (course == null) {
        _store.addCourse(
          _admin.id,
          result.title,
          result.description,
          result.coverPath,
        );
      } else {
        _store.updateCourse(
          course,
          result.title,
          result.description,
          result.coverPath,
          result.active,
        );
      }
    });
  }

  Future<void> _editCard({Flashcard? card}) async {
    if (_store.courses.isEmpty) {
      _toast('Create a course first.');
      return;
    }
    final result = await showModalBottomSheet<_CardInput>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) => _CardForm(
        card: card,
        courseId: card?.courseId ?? _courseId ?? _store.courses.first.id,
      ),
    );
    if (result == null) return;
    setState(() {
      if (card == null) {
        _store.addCard(
          result.courseId,
          result.front,
          result.back,
          result.imagePath,
        );
      } else {
        _store.updateCard(card, result.front, result.back, result.imagePath);
      }
      _courseId = result.courseId;
    });
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

class _CourseForm extends StatefulWidget {
  const _CourseForm({this.course});
  final Course? course;
  @override
  State<_CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<_CourseForm> {
  final _key = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.course?.title ?? '');
  late final _description = TextEditingController(
    text: widget.course?.description ?? '',
  );
  late final _cover = TextEditingController(
    text: widget.course?.coverImagePath ?? '',
  );
  late bool _active = widget.course?.isActive ?? true;
  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _cover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      18,
      15,
      18,
      MediaQuery.viewInsetsOf(context).bottom + 18,
    ),
    child: Form(
      key: _key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.course == null ? 'Add Course' : 'Edit Course',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                tooltip: 'Close',
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          Container(
            height: 86,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate_outlined, color: Palette.blue),
                SizedBox(height: 4),
                Text(
                  'Course cover image',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Enter an image path below',
                  style: TextStyle(color: Palette.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _cover,
            decoration: inputStyle('Optional cover image path'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _title,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter a course title' : null,
            decoration: inputStyle(
              'e.g. Thai for Beginners',
              prefix: const Icon(
                Icons.menu_book_outlined,
                color: Palette.muted,
              ),
            ),
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: _description,
            minLines: 2,
            maxLines: 3,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter a description' : null,
            decoration: inputStyle('Describe this course...'),
          ),
          if (widget.course != null)
            SwitchListTile(
              value: _active,
              onChanged: (v) => setState(() => _active = v),
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Active course',
                style: TextStyle(fontSize: 10),
              ),
              activeThumbColor: Palette.blue,
            ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: primaryButton(),
                  child: Text(
                    widget.course == null ? 'Create Course' : 'Save Course',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  void _save() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(
      context,
      _CourseInput(_title.text, _description.text, _cover.text, _active),
    );
  }
}

class _CardForm extends StatefulWidget {
  const _CardForm({this.card, required this.courseId});
  final Flashcard? card;
  final int courseId;
  @override
  State<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<_CardForm> {
  final _key = GlobalKey<FormState>();
  late int _courseId = widget.courseId;
  late final _front = TextEditingController(text: widget.card?.frontText ?? '');
  late final _back = TextEditingController(
    text: widget.card?.backMeaning ?? '',
  );
  late final _image = TextEditingController(
    text: widget.card?.frontImagePath ?? '',
  );
  @override
  void dispose() {
    _front.dispose();
    _back.dispose();
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      18,
      15,
      18,
      MediaQuery.viewInsetsOf(context).bottom + 18,
    ),
    child: Form(
      key: _key,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.card == null ? 'Add Flashcard' : 'Edit Flashcard',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                tooltip: 'Close',
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          DropdownButtonFormField<int>(
            initialValue: _courseId,
            items: [
              for (final course in LearningStore.instance.courses)
                DropdownMenuItem(value: course.id, child: Text(course.title)),
            ],
            onChanged: widget.card == null
                ? (v) => setState(() => _courseId = v ?? _courseId)
                : null,
            decoration: inputStyle('Course'),
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: _front,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter the Thai text' : null,
            decoration: inputStyle('Thai word or phrase'),
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: _back,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Enter the meaning' : null,
            decoration: inputStyle('Pronunciation · Meaning'),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _image,
            decoration: inputStyle(
              'Optional front image path',
              prefix: const Icon(Icons.image_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: primaryButton(),
                  child: Text(
                    widget.card == null ? 'Save Card' : 'Update Card',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  void _save() {
    if (!_key.currentState!.validate()) return;
    Navigator.pop(
      context,
      _CardInput(_courseId, _front.text, _back.text, _image.text),
    );
  }
}

class _CourseInput {
  const _CourseInput(this.title, this.description, this.coverPath, this.active);
  final String title;
  final String description;
  final String coverPath;
  final bool active;
}

class _CardInput {
  const _CardInput(this.courseId, this.front, this.back, this.imagePath);
  final int courseId;
  final String front;
  final String back;
  final String imagePath;
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({
    required this.course,
    required this.onCards,
    required this.onEdit,
    required this.onToggle,
  });
  final Course course;
  final VoidCallback onCards;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(8),
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
                'THAI · BEGINNER',
                style: TextStyle(
                  color: course.isActive ? Palette.blue : Palette.muted,
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
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${LearningStore.instance.cardsFor(course.id, activeOnly: false).length} flashcards · ${course.isActive ? 'Active' : 'Inactive'}',
                style: const TextStyle(color: Palette.muted, fontSize: 8),
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onCards,
              tooltip: 'Manage course flashcards',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.style_outlined,
                size: 17,
                color: Palette.blue,
              ),
            ),
            IconButton(
              onPressed: onEdit,
              tooltip: 'Edit course',
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: Palette.muted,
              ),
            ),
            IconButton(
              onPressed: onToggle,
              tooltip: course.isActive
                  ? 'Deactivate course'
                  : 'Activate course',
              visualDensity: VisualDensity.compact,
              icon: Icon(
                course.isActive
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 16,
                color: Palette.red,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _FlashcardRow extends StatelessWidget {
  const _FlashcardRow({
    required this.card,
    required this.index,
    required this.onEdit,
    required this.onToggle,
  });
  final Flashcard card;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Row(
      children: [
        SizedBox(
          width: 22,
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(color: Palette.muted, fontSize: 9),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.frontText,
                style: const TextStyle(
                  color: Palette.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (card.backMeaning.contains(' · '))
                Text(
                  card.backMeaning.split(' · ').first,
                  style: const TextStyle(color: Palette.muted, fontSize: 8),
                ),
              Text(
                card.backMeaning.split(' · ').last,
                style: const TextStyle(
                  color: Palette.blue,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (!card.isActive)
                const Text(
                  'Inactive',
                  style: TextStyle(color: Palette.red, fontSize: 8),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: onEdit,
          tooltip: 'Edit flashcard',
          icon: const Icon(Icons.edit_outlined, size: 16, color: Palette.muted),
        ),
        IconButton(
          onPressed: onToggle,
          tooltip: card.isActive
              ? 'Deactivate flashcard'
              : 'Activate flashcard',
          icon: Icon(
            card.isActive
                ? Icons.delete_outline_rounded
                : Icons.restore_rounded,
            size: 18,
            color: Palette.red,
          ),
        ),
      ],
    ),
  );
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Palette.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 17, color: Palette.blue),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Palette.muted,
            ),
          ],
        ),
      ),
    ),
  );
}

class _RecentSession extends StatelessWidget {
  const _RecentSession({required this.session});
  final StudySession session;
  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    final user = store.user(session.userId);
    final course = store.course(session.courseId);
    return ListTile(
      dense: true,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE9ECFF),
        child: Icon(Icons.person_outline, size: 17, color: Palette.blue),
      ),
      title: Text(
        '${user?.username ?? 'Learner'} studied ${course?.title ?? 'a course'}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        '${session.startedAt.month}/${session.startedAt.day}',
        style: const TextStyle(color: Palette.muted, fontSize: 8),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 16,
        color: Palette.muted,
      ),
    );
  }
}

class _Engagement extends StatelessWidget {
  const _Engagement({required this.course, required this.maxAttempts});
  final Course course;
  final int maxAttempts;
  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    final count = store.attemptsByCourse(course.id);
    final learners = store.sessions
        .where((s) => s.courseId == course.id)
        .map((s) => s.userId)
        .toSet()
        .length;
    return Row(
      children: [
        SizedBox(
          width: 82,
          child: Text(
            course.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Palette.muted, fontSize: 8),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: (count / maxAttempts).clamp(0, 1),
              color: Palette.blue,
              backgroundColor: const Color(0xFFEAECF3),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 7),
        SizedBox(
          width: 24,
          child: Text(
            '$learners',
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _Performance extends StatelessWidget {
  const _Performance({required this.course, required this.rank});
  final Course course;
  final int rank;
  @override
  Widget build(BuildContext context) {
    final store = LearningStore.instance;
    final ids = store.sessions
        .where((s) => s.courseId == course.id)
        .map((s) => s.id)
        .toSet();
    final attempts = store.attempts
        .where((a) => ids.contains(a.sessionId))
        .toList();
    final accuracy = attempts.isEmpty
        ? 0
        : attempts.where((a) => a.isCorrect).length / attempts.length;
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFFE9ECFF),
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Palette.blue,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${attempts.length} study records',
                  style: const TextStyle(color: Palette.muted, fontSize: 8),
                ),
              ],
            ),
          ),
          Text(
            '${(accuracy * 100).round()}%',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.star_rounded, color: Palette.yellow, size: 13),
          Text(
            store.ratingFor(course.id).toStringAsFixed(1),
            style: const TextStyle(color: Palette.muted, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _AdminPill extends StatelessWidget {
  const _AdminPill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFF0EAFF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      'Administrator',
      style: TextStyle(
        color: Color(0xFF7956C4),
        fontSize: 8,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _AdminRow extends StatelessWidget {
  const _AdminRow({
    required this.label,
    required this.onTap,
    required this.last,
  });
  final String label;
  final VoidCallback onTap;
  final bool last;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Material(
        type: MaterialType.transparency,
        child: ListTile(
          onTap: onTap,
          dense: true,
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.settings_outlined,
              size: 17,
              color: Palette.blue,
            ),
          ),
          title: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: Palette.muted,
          ),
        ),
      ),
      if (!last) const Divider(height: 1, indent: 50),
    ],
  );
}

String _today() {
  final now = DateTime.now();
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
}
