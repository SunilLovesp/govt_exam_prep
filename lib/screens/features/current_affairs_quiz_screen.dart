import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CurrentAffairsQuizScreen extends StatefulWidget {
  const CurrentAffairsQuizScreen({super.key});

  @override
  State<CurrentAffairsQuizScreen> createState() =>
      _CurrentAffairsQuizScreenState();
}

class _CurrentAffairsQuizScreenState extends State<CurrentAffairsQuizScreen> {
  final List<_CAQuestion> _questions = const [
    _CAQuestion(
      question: 'Which institution releases India State of Forest Report?',
      options: ['NITI Aayog', 'FSI', 'RBI', 'NABARD'],
      correct: 1,
    ),
    _CAQuestion(
      question: 'Repo rate is announced by which body?',
      options: ['SEBI', 'MPC', 'GST Council', 'UPSC'],
      correct: 1,
    ),
    _CAQuestion(
      question: 'Article 280 is related to which constitutional body?',
      options: ['Finance Commission', 'Election Commission', 'CAG', 'UPSC'],
      correct: 0,
    ),
  ];
  final Map<int, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    final score = _answers.entries
        .where((entry) => _questions[entry.key].correct == entry.value)
        .length;
    return Scaffold(
      appBar: AppBar(title: const Text('Current Affairs Quiz')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today • $score/${_questions.length}',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...List.generate(_questions.length, (index) {
            final q = _questions[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q${index + 1}. ${q.question}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...List.generate(q.options.length, (optionIndex) {
                    final selected = _answers[index] == optionIndex;
                    final correct = q.correct == optionIndex;
                    final answered = _answers.containsKey(index);
                    return RadioListTile<int>(
                      dense: true,
                      value: optionIndex,
                      groupValue: _answers[index],
                      onChanged: (value) =>
                          setState(() => _answers[index] = value!),
                      title: Text(q.options[optionIndex]),
                      activeColor: answered && correct
                          ? AppColors.success
                          : AppColors.primary,
                      tileColor: answered && correct
                          ? AppColors.successLight
                          : selected
                              ? AppColors.primaryLight.withOpacity(0.18)
                              : null,
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CAQuestion {
  final String question;
  final List<String> options;
  final int correct;

  const _CAQuestion({
    required this.question,
    required this.options,
    required this.correct,
  });
}
