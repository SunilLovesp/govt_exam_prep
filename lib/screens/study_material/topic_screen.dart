import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TopicScreen extends StatelessWidget {
  final String subject;
  final String chapter;

  const TopicScreen({super.key, required this.subject, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final content = _getContent(chapter);

    return Scaffold(
      appBar: AppBar(title: Text(chapter)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(chapter, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sections
            ...content.map((section) => _ContentSection(section: section)),

            const SizedBox(height: 24),
            // Practice button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.quiz_rounded),
                label: Text('Practice $chapter Questions'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<_Section> _getContent(String chapter) {
    // Generic educational content for any chapter
    return [
      _Section(
        title: 'Introduction',
        content:
            '$chapter is an important topic for government exams. Understanding the core concepts will help you solve questions quickly and accurately.',
        type: 'text',
      ),
      const _Section(
        title: 'Key Concepts',
        content: '',
        type: 'bullets',
        bullets: [
          'Understand the fundamental definition and properties',
          'Learn the standard formulas and their derivations',
          'Practice applying concepts to different question types',
          'Identify shortcuts and tricks for faster solving',
        ],
      ),
      _Section(
        title: 'Important Formulas',
        content:
            'Formulas for $chapter:\n\n• Basic formula 1: Apply when direct values are given\n• Basic formula 2: Apply for percentage-based problems\n• Shortcut: Use this approach for competitive exam speed',
        type: 'formula',
      ),
      _Section(
        title: 'Solved Example',
        content:
            'Example: A standard $chapter problem\n\nSolution:\nStep 1: Identify the given information\nStep 2: Choose the appropriate formula\nStep 3: Substitute values and calculate\nStep 4: Verify the answer\n\nAnswer: Option (B)',
        type: 'example',
      ),
      const _Section(
        title: 'Tips & Tricks',
        content: '',
        type: 'bullets',
        bullets: [
          'Always read the question twice before solving',
          'Elimination technique saves time in MCQs',
          'Approximate values help in complex calculations',
          'Time yourself while practicing',
        ],
      ),
    ];
  }
}

class _Section {
  final String title;
  final String content;
  final String type; // 'text', 'bullets', 'formula', 'example'
  final List<String> bullets;

  const _Section({
    required this.title,
    required this.content,
    required this.type,
    this.bullets = const [],
  });
}

class _ContentSection extends StatelessWidget {
  final _Section section;
  const _ContentSection({required this.section});

  @override
  Widget build(BuildContext context) {
    Color headerColor;
    IconData icon;
    switch (section.type) {
      case 'formula':
        headerColor = AppColors.primary;
        icon = Icons.functions_rounded;
        break;
      case 'example':
        headerColor = AppColors.success;
        icon = Icons.lightbulb_outline_rounded;
        break;
      case 'bullets':
        headerColor = AppColors.accent;
        icon = Icons.list_rounded;
        break;
      default:
        headerColor = AppColors.textSecondary;
        icon = Icons.article_outlined;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerColor.withOpacity(0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: headerColor),
                  const SizedBox(width: 8),
                  Text(section.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                          fontSize: 14)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: section.type == 'bullets'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: section.bullets
                          .map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                          color: headerColor,
                                          shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(b,
                                            style: const TextStyle(
                                                fontSize: 14, height: 1.5))),
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  : Text(section.content,
                      style: const TextStyle(fontSize: 14, height: 1.6)),
            ),
          ],
        ),
      ),
    );
  }
}
