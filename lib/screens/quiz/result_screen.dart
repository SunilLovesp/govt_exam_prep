import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/quiz_result.dart';
import '../../providers/feature_provider.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _recorded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_recorded) return;
    _recorded = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FeatureProvider>().recordAttempt(widget.result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final pct = result.accuracy;
    final color = pct >= 70
        ? AppColors.success
        : pct >= 40
            ? AppColors.warning
            : AppColors.error;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Trophy icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  pct >= 70 ? Icons.emoji_events_rounded : Icons.bar_chart_rounded,
                  size: 48,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              Text('Test Completed!',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 6),
              Text(result.testTitle,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 14),
                  textAlign: TextAlign.center),
              const SizedBox(height: 28),

              // Score card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${pct.toStringAsFixed(1)}%',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text('Accuracy',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _StatBox(
                      label: 'Correct',
                      value: '${result.correctCount}',
                      color: AppColors.success),
                  _StatBox(
                      label: 'Incorrect',
                      value: '${result.incorrectCount}',
                      color: AppColors.error),
                  _StatBox(
                      label: 'Skipped',
                      value: '${result.skippedCount}',
                      color: AppColors.warning),
                  _StatBox(
                      label: 'Time Taken',
                      value: result.timeTakenFormatted,
                      color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 20),

              // Subject-wise stats
              if (result.subjectWiseStats.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Subject-wise Performance',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(height: 12),
                ...result.subjectWiseStats.entries.map(
                  (e) => _SubjectBar(stats: e.value),
                ),
                const SizedBox(height: 8),
              ],

              // Actions
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/home/review', extra: result),
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('View Solutions'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Back to Home'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectBar extends StatelessWidget {
  final SubjectStats stats;
  const _SubjectBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    final acc = stats.accuracy / 100;
    final color = stats.accuracy >= 70
        ? AppColors.success
        : stats.accuracy >= 40
            ? AppColors.warning
            : AppColors.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stats.subject,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('${stats.accuracy.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color)),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: acc,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.15),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
