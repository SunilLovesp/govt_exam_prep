import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';

class TestListScreen extends StatelessWidget {
  const TestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allTests = examCategories
        .expand((c) => c.exams)
        .expand((e) => e.testSeries.map((t) => _TestEntry(
              test: t,
              examName: e.name,
              color: examCategories.firstWhere((c) => c.id == e.category).color,
            )))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tests'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _FilterBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allTests.length,
              itemBuilder: (context, i) => _TestCard(entry: allTests[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatefulWidget {
  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  int _selected = 0;
  final _filters = ['All', 'Free', 'Full Tests', 'Sectional', 'Prev Year'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _filters.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_filters[i]),
            selected: _selected == i,
            onSelected: (_) => setState(() => _selected = i),
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: _selected == i ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _TestEntry {
  final TestSeries test;
  final String examName;
  final Color color;
  _TestEntry({required this.test, required this.examName, required this.color});
}

class _TestCard extends StatelessWidget {
  final _TestEntry entry;
  const _TestCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final color = entry.color;
    return GestureDetector(
      onTap: () => context.go('/home/quiz/${entry.test.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.quiz_rounded, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.test.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    entry.examName,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Pill('${entry.test.totalQuestions} Qs', AppColors.textSecondary),
                      const SizedBox(width: 6),
                      _Pill('${entry.test.durationMinutes} min', AppColors.textSecondary),
                      const SizedBox(width: 6),
                      if (entry.test.isFree)
                        const _Pill('FREE', AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => context.go('/home/quiz/${entry.test.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Start', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
