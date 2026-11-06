import 'package:flutter/material.dart';

class BusuuLessonView extends StatefulWidget {
  const BusuuLessonView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onComplete,
  });

  final String title;
  final String subtitle;
  final Future<void> Function() onComplete;

  @override
  State<BusuuLessonView> createState() => _BusuuLessonViewState();
}

class _BusuuLessonViewState extends State<BusuuLessonView> {
  static const _lessonPhrases = <String, List<Map<String, String>>>{
    'Greetings & Introductions': [
      {'french': 'Bonjour !', 'english': 'Hello!'},
      {
        'french': 'Comment vous appelez-vous ?',
        'english': 'What is your name?',
      },
      {'french': 'Je m’appelle Léa.', 'english': 'My name is Lea.'},
    ],
    'Essential Phrases': [
      {'french': 'Merci beaucoup.', 'english': 'Thank you very much.'},
      {'french': 'Je ne comprends pas.', 'english': 'I do not understand.'},
      {'french': 'Pouvez-vous répéter ?', 'english': 'Can you repeat?'},
    ],
    'Ordering Food & Drinks': [
      {'french': 'Un café, s’il vous plaît.', 'english': 'A coffee, please.'},
      {
        'french': 'Je voudrais de l’eau.',
        'english': 'I would like some water.',
      },
      {
        'french': 'L’addition, s’il vous plaît.',
        'english': 'The bill, please.',
      },
      {'french': 'C’est délicieux !', 'english': 'It is delicious!'},
      {'french': 'Combien ça coûte ?', 'english': 'How much does it cost?'},
    ],
    'Asking for Directions': [
      {'french': 'Où se trouve la gare ?', 'english': 'Where is the station?'},
      {
        'french': 'Tournez à gauche au feu.',
        'english': 'Turn left at the light.',
      },
      {'french': 'C’est loin d’ici ?', 'english': 'Is it far from here?'},
    ],
    'Hotel & Accommodation': [
      {'french': 'J’ai une réservation.', 'english': 'I have a reservation.'},
      {
        'french': 'Le petit-déjeuner est-il inclus ?',
        'english': 'Is breakfast included?',
      },
      {
        'french': 'À quelle heure faut-il libérer la chambre ?',
        'english': 'What time is checkout?',
      },
    ],
    'Daily Life & Routines': [
      {
        'french': 'J’ai l’habitude de marcher le matin.',
        'english': 'I usually walk in the morning.',
      },
      {'french': 'Je prépare le dîner.', 'english': 'I am preparing dinner.'},
      {
        'french': 'Nous nous retrouvons après le travail.',
        'english': 'We are meeting after work.',
      },
    ],
    'Sharing Opinions': [
      {
        'french': 'À mon avis, c’est une bonne idée.',
        'english': 'In my opinion, it is a good idea.',
      },
      {'french': 'Je suis d’accord avec vous.', 'english': 'I agree with you.'},
      {
        'french': 'Cela dépend de la situation.',
        'english': 'It depends on the situation.',
      },
    ],
    'Debate & Discussion': [
      {
        'french': 'Bien que ce soit coûteux, cela vaut la peine.',
        'english': 'Although it is expensive, it is worth it.',
      },
      {
        'french': 'Il faut tenir compte des conséquences.',
        'english': 'We must take the consequences into account.',
      },
      {
        'french': 'Je comprends votre point de vue, toutefois…',
        'english': 'I understand your view; however…',
      },
    ],
    'Professional Communication': [
      {
        'french': 'Pourrions-nous reporter la réunion ?',
        'english': 'Could we reschedule the meeting?',
      },
      {
        'french': 'Je vous envoie le compte rendu.',
        'english': 'I will send you the minutes.',
      },
      {
        'french': 'Nous devons respecter le délai.',
        'english': 'We must meet the deadline.',
      },
    ],
    'News & Current Affairs': [
      {
        'french': 'Selon les dernières informations…',
        'english': 'According to the latest reports…',
      },
      {
        'french': 'Cette mesure a suscité de vives réactions.',
        'english': 'This measure prompted strong reactions.',
      },
      {
        'french': 'Les chiffres doivent être interprétés avec prudence.',
        'english': 'The figures should be interpreted with caution.',
      },
    ],
    'Formal & Academic French': [
      {
        'french': 'Je me permets de vous contacter au sujet de…',
        'english': 'I am writing to you regarding…',
      },
      {
        'french': 'Cette hypothèse mérite d’être examinée.',
        'english': 'This hypothesis deserves to be examined.',
      },
      {
        'french': 'Les résultats mettent en évidence une tendance.',
        'english': 'The results highlight a trend.',
      },
    ],
    'Idioms & Expressions': [
      {
        'french': 'Elle a d’autres chats à fouetter.',
        'english': 'She has other fish to fry.',
      },
      {
        'french': 'Nous sommes sur la même longueur d’onde.',
        'english': 'We are on the same wavelength.',
      },
      {'french': 'Il a mis la main à la pâte.', 'english': 'He got hands-on.'},
    ],
    'Nuance & Register': [
      {
        'french': 'Il va sans dire que la décision n’était pas anodine.',
        'english': 'Needless to say, the decision was not insignificant.',
      },
      {
        'french': 'Son propos prêtait à confusion.',
        'english': 'What they said was open to misinterpretation.',
      },
      {
        'french': 'Tout est dans la manière de le formuler.',
        'english': 'It is all in how you phrase it.',
      },
    ],
  };

  List<Map<String, String>> get _phrases =>
      _lessonPhrases[widget.title] ?? _lessonPhrases.values.first;

  int _phraseIndex = 0;
  bool _showTranslation = false;
  bool _isComplete = false;

  void _advance() {
    setState(() {
      if (_phraseIndex == _phrases.length - 1) {
        _isComplete = true;
      } else {
        _phraseIndex++;
        _showTranslation = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final phrase = _phrases[_phraseIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isComplete
              ? _buildCompletion(context)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.subtitle,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phrase ${_phraseIndex + 1} of ${_phrases.length}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${_phraseIndex + 1}/${_phrases.length}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_phraseIndex + 1) / _phrases.length,
                      color: const Color(0xFF0056C6),
                      backgroundColor: const Color(0xFFEBF3FF),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setState(
                              () => _showTranslation = !_showTranslation,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _showTranslation
                                          ? 'TRANSLATION'
                                          : 'FRENCH',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      _showTranslation
                                          ? phrase['english']!
                                          : phrase['french']!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      _showTranslation
                                          ? 'Tap to see the French phrase'
                                          : 'Tap to reveal the translation',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _showTranslation
                          ? _advance
                          : () => setState(() => _showTranslation = true),
                      icon: Icon(
                        _showTranslation
                            ? Icons.arrow_forward
                            : Icons.visibility_outlined,
                      ),
                      label: Text(
                        _showTranslation
                            ? (_phraseIndex == _phrases.length - 1
                                  ? 'Complete Lesson'
                                  : 'Next Phrase')
                            : 'Show Translation',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0056C6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCompletion(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 72, color: Color(0xFF00C853)),
          const SizedBox(height: 16),
          const Text(
            'Lesson complete!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.title, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await widget.onComplete();
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.map_outlined),
            label: const Text('Back to lessons'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0056C6),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
