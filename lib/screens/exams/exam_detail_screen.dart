import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../providers/exam_provider.dart';

class ExamDetailScreen extends StatelessWidget {
  final String examId;
  const ExamDetailScreen({super.key, required this.examId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ExamProvider>();
    final exam = provider.getExamById(examId);
    final category = provider.getCategoryForExam(examId);
    final color = category?.color ?? AppColors.primary;

    if (exam == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Exam Details')),
        body: const Center(child: Text('Exam not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(exam.name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(category?.icon ?? Icons.school,
                      size: 64, color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key Info
                  _InfoRow(label: 'Full Name', value: exam.fullName),
                  _InfoRow(label: 'Conducted By', value: exam.conductedBy),
                  _InfoRow(label: 'Eligibility', value: exam.eligibility),
                  if (exam.vacancies > 0)
                    _InfoRow(label: 'Vacancies', value: '${exam.vacancies}'),
                  const SizedBox(height: 20),

                  // Subjects
                  _SectionTitle(title: 'Subjects Covered', color: color),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: exam.subjects
                        .map((s) => Chip(
                              label: Text(s, style: const TextStyle(fontSize: 12)),
                              backgroundColor: color.withOpacity(0.1),
                              side: BorderSide(color: color.withOpacity(0.3)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Exam Pattern
                  _SectionTitle(title: 'Exam Pattern', color: color),
                  const SizedBox(height: 10),
                  ...exam.tiers.map((tier) => _TierCard(tier: tier, color: color)),
                  const SizedBox(height: 20),

                  // Test Series
                  _SectionTitle(title: 'Available Tests', color: color),
                  const SizedBox(height: 10),
                  ...exam.testSeries.map((ts) => _TestSeriesCard(
                        testSeries: ts,
                        color: color,
                        onTap: () => context.go('/home/quiz/${ts.id}'),
                      )),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  final ExamTier tier;
  final Color color;
  const _TierCard({required this.tier, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tier.name,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            children: [
              _TierStat('Questions', '${tier.totalQuestions}'),
              _TierStat('Marks', '${tier.totalMarks}'),
              _TierStat('Duration', '${tier.durationMinutes} min'),
              _TierStat('Negative', '-${tier.negativeMark}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierStat extends StatelessWidget {
  final String label;
  final String value;
  const _TierStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _TestSeriesCard extends StatelessWidget {
  final TestSeries testSeries;
  final Color color;
  final VoidCallback onTap;

  const _TestSeriesCard({
    required this.testSeries,
    required this.color,
    required this.onTap,
  });

  String get _typeLabel {
    switch (testSeries.type) {
      case 'full':
        return 'Full Test';
      case 'sectional':
        return 'Sectional';
      case 'previous_year':
        return 'Prev Year';
      default:
        return testSeries.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(testSeries.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('${testSeries.totalQuestions} Qs • ${testSeries.durationMinutes} min',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(_typeLabel,
                            style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            testSeries.isFree
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('FREE',
                        style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  )
                : ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Start', style: TextStyle(fontSize: 12)),
                  ),
          ],
        ),
      ),
    );
  }
}
