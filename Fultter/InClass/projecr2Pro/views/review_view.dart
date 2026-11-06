import 'package:flutter/material.dart';

class BusuuReviewView extends StatefulWidget {
  const BusuuReviewView({super.key});

  @override
  State<BusuuReviewView> createState() => _BusuuReviewViewState();
}

class _BusuuReviewViewState extends State<BusuuReviewView> {
  bool _isFlipped = false;
  int _cardIndex = 0;

  final List<Map<String, String>> _vocabularyDeck = [
    {
      'word': 'Bonjour',
      'phonetic': '/bɔ̃ʒuʁ/',
      'meaning': 'Hello / Good morning',
      'example': 'Bonjour! Comment allez-vous?',
      'translation': 'Hello! How are you?',
    },
    {
      'word': 'S\'il vous plaît',
      'phonetic': '/sil vu plɛ/',
      'meaning': 'Please',
      'example': 'Un café, s\'il vous plaît.',
      'translation': 'A coffee, please.',
    },
  ];

  void _nextCard() {
    setState(() {
      _isFlipped = false;
      _cardIndex = (_cardIndex + 1) % _vocabularyDeck.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _vocabularyDeck[_cardIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Vocabulary Review', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${_cardIndex + 1}/${_vocabularyDeck.length}',
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Top Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_cardIndex + 1) / _vocabularyDeck.length,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0056C6)),
              ),
            ),
            const SizedBox(height: 32),

            // Flashcard Box
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isFlipped = !_isFlipped),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentCard['word']!,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0056C6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF0056C6), size: 28),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔊 Playing native audio pronunciation'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        currentCard['phonetic']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const Divider(height: 36, thickness: 1),

                      if (_isFlipped) ...[
                        Text(
                          currentCard['meaning']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C853),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '"${currentCard['example']!}"',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                currentCard['translation']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Icon(Icons.touch_app_outlined, color: Colors.grey, size: 36),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap card to reveal definition',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Recall Buttons
            if (_isFlipped)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFFF8D00), width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _nextCard,
                      child: const Text(
                        'Need Review',
                        style: TextStyle(color: Color(0xFFFF8D00), fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C853),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _nextCard,
                      child: const Text(
                        'I Know This',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              )
            else
              const SizedBox(height: 52), // Placeholder height when unrevealed
          ],
        ),
      ),
    );
  }
}
