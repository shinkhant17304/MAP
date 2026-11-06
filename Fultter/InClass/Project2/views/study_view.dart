import 'package:flutter/material.dart';

import '../models/entities.dart';
import '../models/learning_store.dart';
import 'common.dart';

class StudyView extends StatefulWidget {
  const StudyView({super.key, required this.sessionId});

  final int sessionId;

  @override
  State<StudyView> createState() => _StudyViewState();
}

class _StudyViewState extends State<StudyView> {
  final _store = LearningStore.instance;
  int _cardIndex = 0;
  bool _revealed = false;

  StudySession get _session =>
      _store.sessions.firstWhere((s) => s.id == widget.sessionId);
  List<Flashcard> get _cards => _store.cardsFor(_session.courseId);
  List<StudyAttempt> get _attempts =>
      _store.attemptsForSession(widget.sessionId);
  List<int> get _toLearn => [
    for (var index = 0; index < _cards.length; index++)
      if (!_attempts.any(
        (a) => a.flashcardId == _cards[index].id && a.isCorrect,
      ))
        index,
  ];

  void _answer(bool correct) {
    if (_cards.isEmpty) return;
    final card = _cards[_cardIndex];
    _store.recordAttempt(widget.sessionId, card.id, correct);
    final next = _toLearn;
    setState(() {
      _revealed = false;
      if (next.isEmpty) {
        _store.endSession(widget.sessionId, completed: true);
      } else if (correct) {
        _cardIndex = next.first;
      } else {
        _cardIndex = next.firstWhere(
          (index) => index != _cardIndex,
          orElse: () => _cardIndex,
        );
      }
    });
  }

  void _leave() {
    _store.endSession(widget.sessionId, completed: false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    final course = _store.course(session.courseId);
    final cards = _cards;
    final remaining = _toLearn;
    final complete =
        session.status == SessionStatus.completed || remaining.isEmpty;
    final card = cards.isEmpty || complete ? null : cards[_cardIndex];
    final mastered = cards.length - remaining.length;
    final correctCount = _attempts.where((a) => a.isCorrect).length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Study flashcards',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          onPressed: _leave,
          tooltip: 'End study session',
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            onPressed: _leave,
            tooltip: 'End study session',
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
            child: complete
                ? _complete(
                    course?.title ?? 'Thai course',
                    cards.length,
                    correctCount,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'SESSION PROGRESS',
                            style: TextStyle(
                              color: Palette.muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${mastered + 1} / ${cards.length}',
                            style: const TextStyle(
                              color: Palette.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: cards.isEmpty
                              ? 0
                              : (mastered + 1) / cards.length,
                          color: Palette.blue,
                          backgroundColor: const Color(0xFFE1E5F0),
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: Text(
                          course?.title ?? 'Thai course',
                          style: const TextStyle(
                            color: Palette.muted,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _revealed = !_revealed),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Palette.line),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x080D1C4A),
                                  blurRadius: 18,
                                  offset: Offset(0, 7),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _revealed ? 'MEANING' : 'THAI',
                                  style: const TextStyle(
                                    color: Palette.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  _revealed
                                      ? card!.backMeaning.split(' · ').last
                                      : card!.frontText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Palette.ink,
                                    fontSize: _revealed ? 23 : 39,
                                    height: 1.2,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (!_revealed &&
                                    card.backMeaning.contains(' · ')) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    card.backMeaning.split(' · ').first,
                                    style: const TextStyle(
                                      color: Palette.muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Icon(
                                  _revealed
                                      ? Icons.translate_rounded
                                      : Icons.touch_app_outlined,
                                  color: Palette.blue,
                                  size: 18,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _revealed
                                      ? 'Tap to see the Thai word'
                                      : 'Tap card to reveal the meaning',
                                  style: const TextStyle(
                                    color: Palette.muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (!_revealed)
                        SizedBox(
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: () => setState(() => _revealed = true),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 18,
                            ),
                            label: const Text('Reveal Answer'),
                            style: primaryButton(),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _answer(false),
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 17,
                                ),
                                label: const Text('Need practice'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Palette.ink,
                                  side: const BorderSide(color: Palette.line),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _answer(true),
                                icon: const Icon(Icons.check_rounded, size: 17),
                                label: const Text('Got it'),
                                style: primaryButton(),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _complete(String title, int total, int correct) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 74,
        height: 74,
        decoration: const BoxDecoration(
          color: Color(0xFFE1F3EA),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, color: Palette.green, size: 38),
      ),
      const SizedBox(height: 16),
      const Text(
        'Session complete',
        style: TextStyle(
          color: Palette.ink,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 5),
      Text(title, style: const TextStyle(color: Palette.muted, fontSize: 11)),
      const SizedBox(height: 18),
      Panel(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Score(value: '$total', label: 'Cards mastered'),
            _Score(
              value:
                  '${total == 0 ? 0 : (correct / _attempts.length * 100).round()}%',
              label: 'Accuracy',
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => Navigator.pop(context),
          style: primaryButton(),
          child: const Text('Back to learning'),
        ),
      ),
    ],
  );
}

class _Score extends StatelessWidget {
  const _Score({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Palette.blue,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Palette.muted, fontSize: 9)),
    ],
  );
}
