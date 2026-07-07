import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class SubjectListScreen extends StatelessWidget {
  const SubjectListScreen({super.key});

  static const _subjects = [
    {
      'name': 'Quantitative Aptitude',
      'icon': Icons.calculate_rounded,
      'color': AppColors.quantColor,
      'chapters': _quantChapters,
    },
    {
      'name': 'Reasoning',
      'icon': Icons.psychology_rounded,
      'color': AppColors.reasoningColor,
      'chapters': _reasoningChapters,
    },
    {
      'name': 'English Language',
      'icon': Icons.translate_rounded,
      'color': AppColors.englishColor,
      'chapters': _englishChapters,
    },
    {
      'name': 'General Awareness',
      'icon': Icons.public_rounded,
      'color': AppColors.gkColor,
      'chapters': _gkChapters,
    },
  ];

  static const _quantChapters = [
    'Number System', 'HCF & LCM', 'Percentage', 'Profit & Loss',
    'Simple Interest', 'Compound Interest', 'Ratio & Proportion',
    'Averages', 'Time & Work', 'Time, Speed & Distance',
    'Mensuration', 'Algebra', 'Trigonometry', 'Statistics',
  ];

  static const _reasoningChapters = [
    'Series', 'Analogy', 'Classification', 'Coding-Decoding',
    'Blood Relations', 'Direction Sense', 'Syllogism',
    'Puzzles & Seating', 'Input-Output', 'Statement & Conclusion',
    'Mirror Image', 'Paper Folding', 'Venn Diagrams',
  ];

  static const _englishChapters = [
    'Reading Comprehension', 'Cloze Test', 'Fill in the Blanks',
    'Error Spotting', 'Sentence Improvement', 'Parajumbles',
    'One Word Substitution', 'Idioms & Phrases', 'Synonyms & Antonyms',
    'Active & Passive Voice', 'Direct & Indirect Speech',
  ];

  static const _gkChapters = [
    'Indian History', 'Indian Geography', 'Indian Polity',
    'Indian Economy', 'Science & Technology', 'Environment',
    'Sports', 'Awards & Honours', 'Books & Authors',
    'Current Affairs', 'International Relations', 'Art & Culture',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Material')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _subjects.length,
        itemBuilder: (context, i) {
          final subj = _subjects[i];
          final color = subj['color'] as Color;
          final chapters = subj['chapters'] as List<String>;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(subj['icon'] as IconData, color: color, size: 24),
                ),
                title: Text(subj['name'] as String,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                subtitle: Text('${chapters.length} Chapters',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                children: chapters
                    .map((ch) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          leading: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle),
                          ),
                          title: Text(ch,
                              style: const TextStyle(fontSize: 14)),
                          trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.textHint),
                          onTap: () => context.go(
                            '/home/study-material/topic',
                            extra: {
                              'subject': subj['name'] as String,
                              'chapter': ch,
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
