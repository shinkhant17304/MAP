import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lesson_view.dart';

class BusuuLearnView extends StatefulWidget {
  const BusuuLearnView({super.key, required this.learnerId});

  final String learnerId;

  @override
  State<BusuuLearnView> createState() => _BusuuLearnViewState();
}

class _BusuuLearnViewState extends State<BusuuLearnView> {
  String get _progressKey =>
      'busuu_completed_french_lessons_${widget.learnerId}';
  final Set<String> _completedLessonIds = {};
  bool _isLoading = true;

  final List<Map<String, Object>> _lessons = [
    {
      'id': 'a1_greetings',
      'title': 'Greetings & Introductions',
      'level': 'A1',
      'subtitle': 'Say hello and introduce yourself',
      'status': 'completed', // completed, active, locked
      'icon': Icons.handshake_outlined,
    },
    {
      'id': 'a1_essential',
      'title': 'Essential Phrases',
      'level': 'A1',
      'subtitle': 'Please, thank you & basic responses',
      'status': 'completed',
      'icon': Icons.chat_bubble_outline,
    },
    {
      'id': 'a1_food',
      'title': 'Ordering Food & Drinks',
      'level': 'A1',
      'subtitle': 'At cafes and restaurants',
      'status': 'active',
      'icon': Icons.restaurant_menu,
    },
    {
      'id': 'a2_directions',
      'title': 'Asking for Directions',
      'level': 'A2',
      'subtitle': 'Navigating the city',
      'status': 'locked',
      'icon': Icons.explore_outlined,
    },
    {
      'id': 'a2_hotel',
      'title': 'Hotel & Accommodation',
      'level': 'A2',
      'subtitle': 'Booking rooms and checking in',
      'status': 'locked',
      'icon': Icons.hotel_outlined,
    },
    {
      'id': 'b1_daily_life',
      'title': 'Daily Life & Routines',
      'level': 'B1',
      'subtitle': 'Talk about habits and everyday plans',
      'status': 'locked',
      'icon': Icons.today_outlined,
    },
    {
      'id': 'b1_opinions',
      'title': 'Sharing Opinions',
      'level': 'B1',
      'subtitle': 'Explain what you think and why',
      'status': 'locked',
      'icon': Icons.forum_outlined,
    },
    {
      'id': 'b2_discussion',
      'title': 'Debate & Discussion',
      'level': 'B2',
      'subtitle': 'Develop and support an argument',
      'status': 'locked',
      'icon': Icons.groups_outlined,
    },
    {
      'id': 'b2_workplace',
      'title': 'Professional Communication',
      'level': 'B2',
      'subtitle': 'Meetings, proposals and collaboration',
      'status': 'locked',
      'icon': Icons.work_outline,
    },
    {
      'id': 'c1_media',
      'title': 'News & Current Affairs',
      'level': 'C1',
      'subtitle': 'Discuss complex topics and reporting',
      'status': 'locked',
      'icon': Icons.newspaper_outlined,
    },
    {
      'id': 'c1_formal',
      'title': 'Formal & Academic French',
      'level': 'C1',
      'subtitle': 'Use precise language in formal settings',
      'status': 'locked',
      'icon': Icons.school_outlined,
    },
    {
      'id': 'c2_idioms',
      'title': 'Idioms & Expressions',
      'level': 'C2',
      'subtitle': 'Understand idiomatic and figurative French',
      'status': 'locked',
      'icon': Icons.auto_awesome_outlined,
    },
    {
      'id': 'c2_nuance',
      'title': 'Nuance & Register',
      'level': 'C2',
      'subtitle': 'Recognize subtle meaning and tone',
      'status': 'locked',
      'icon': Icons.tune_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final preferences = await SharedPreferences.getInstance();
    final savedIds = preferences.getStringList(_progressKey) ?? [];
    if (!mounted) return;
    setState(() {
      _completedLessonIds.addAll(savedIds);
      _isLoading = false;
    });
  }

  Future<void> _completeLesson(String lessonId) async {
    final completedIds = {..._completedLessonIds, lessonId};
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_progressKey, completedIds.toList());
    if (!mounted) return;
    setState(() => _completedLessonIds.add(lessonId));
  }

  int get _activeLessonIndex => _lessons.indexWhere(
    (lesson) => !_completedLessonIds.contains(lesson['id']),
  );

  @override
  Widget build(BuildContext context) {
    final progress = _completedLessonIds.length / _lessons.length;
    final activeIndex = _activeLessonIndex;
    final currentLevel = activeIndex == -1
        ? 'C2'
        : _lessons[activeIndex]['level']! as String;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF3FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text('🇫🇷', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Text(
                    'French $currentLevel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0056C6),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF0056C6),
                    size: 18,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Streak counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF8D00),
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '7 Days',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8D00),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Goal Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0056C6), Color(0xFF0080FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lessons completed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${_completedLessonIds.length}/${_lessons.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'French Learning Path',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stepped Timeline Nodes
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];
                      final lessonId = lesson['id']! as String;
                      final isCompleted = _completedLessonIds.contains(
                        lessonId,
                      );
                      final isActive = !isCompleted && index == activeIndex;
                      final isLocked = !isCompleted && !isActive;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Node Icon & Connecting Vertical Line
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: isCompleted
                                    ? const Color(0xFF00C853)
                                    : isActive
                                    ? const Color(0xFF0056C6)
                                    : Colors.grey.shade300,
                                child: Icon(
                                  isCompleted
                                      ? Icons.check
                                      : isLocked
                                      ? Icons.lock
                                      : lesson['icon'] as IconData,
                                  color: isLocked
                                      ? Colors.grey.shade600
                                      : Colors.white,
                                  size: 22,
                                ),
                              ),
                              if (index < _lessons.length - 1)
                                Container(
                                  width: 3,
                                  height: 54,
                                  color: isCompleted
                                      ? const Color(0xFF00C853)
                                      : Colors.grey.shade300,
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Lesson Card
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isActive
                                      ? const Color(0xFF0056C6)
                                      : Colors.grey.shade200,
                                  width: isActive ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? const Color(0xFFEBF3FF)
                                              : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          lesson['level']! as String,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isActive
                                                ? const Color(0xFF0056C6)
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (!isLocked)
                                        FilledButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (_) => BusuuLessonView(
                                                  title:
                                                      lesson['title']!
                                                          as String,
                                                  subtitle:
                                                      lesson['subtitle']!
                                                          as String,
                                                  onComplete: () =>
                                                      _completeLesson(lessonId),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.play_arrow,
                                            size: 18,
                                          ),
                                          label: Text(
                                            isCompleted ? 'Review' : 'Start',
                                          ),
                                          style: FilledButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF0056C6,
                                            ),
                                            foregroundColor: Colors.white,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                        ),
                                      if (isLocked)
                                        const Icon(
                                          Icons.lock_outline,
                                          color: Colors.grey,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    lesson['title']! as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isLocked
                                          ? Colors.grey
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lesson['subtitle']! as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (isLocked) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Complete the previous lesson to unlock',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
