import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../providers/exam_provider.dart';

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExamProvider(),
      child: const _ExamListBody(),
    );
  }
}

class _ExamListBody extends StatelessWidget {
  const _ExamListBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExamProvider>();
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Exams'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: provider.setSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Search exams...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),

          // Category chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _CategoryChip(
                  label: 'All',
                  id: 'all',
                  selected: provider.selectedCategoryId == 'all',
                  onTap: () => provider.selectCategory('all'),
                ),
                ...categories.map((c) => _CategoryChip(
                      label: c.shortName,
                      id: c.id,
                      selected: provider.selectedCategoryId == c.id,
                      onTap: () => provider.selectCategory(c.id),
                    )),
              ],
            ),
          ),

          const Divider(height: 1),

          // Exam list
          Expanded(
            child: provider.filteredExams.isEmpty
                ? const Center(
                    child: Text('No exams found',
                        style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.filteredExams.length,
                    itemBuilder: (context, i) {
                      final exam = provider.filteredExams[i];
                      final cat = provider.getCategoryForExam(exam.id);
                      return _ExamCard(exam: exam, category: cat);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String id;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.id,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final Exam exam;
  final ExamCategory? category;

  const _ExamCard({required this.exam, this.category});

  @override
  Widget build(BuildContext context) {
    final color = category?.color ?? AppColors.primary;

    return GestureDetector(
      onTap: () => context.go('/home/exams/${exam.id}'),
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
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(category?.icon ?? Icons.school, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exam.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(exam.fullName,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _InfoBadge(
                          icon: Icons.assignment_rounded,
                          text: '${exam.testSeries.length} Tests',
                          color: color),
                      const SizedBox(width: 8),
                      if (exam.vacancies > 0)
                        _InfoBadge(
                            icon: Icons.people_outline,
                            text: '${exam.vacancies} Vacancies',
                            color: AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoBadge(
      {required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
