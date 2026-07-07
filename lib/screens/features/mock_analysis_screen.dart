import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class MockAnalysisScreen extends StatelessWidget {
  const MockAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    final last = features.attempts.isEmpty ? null : features.attempts.first;
    final percentile = last == null ? 0 : (last.accuracy * 0.9 + 8).clamp(0, 99);

    return Scaffold(
      appBar: AppBar(title: const Text('Mock Test Analysis')),
      body: last == null
          ? const Center(child: Text('Submit a mock test to see analysis.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    _MetricCard(
                        label: 'Rank',
                        value: '#${features.leaderboard.indexWhere((e) => e.name == 'You') + 1}',
                        color: AppColors.primary),
                    const SizedBox(width: 12),
                    _MetricCard(
                        label: 'Percentile',
                        value: percentile.toStringAsFixed(1),
                        color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MetricCard(
                        label: 'Score',
                        value: '${last.score}',
                        color: AppColors.accent),
                    const SizedBox(width: 12),
                    _MetricCard(
                        label: 'Time',
                        value: last.timeTakenFormatted,
                        color: AppColors.warning),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Subject Report',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                ...last.subjectWiseStats.values.map((stats) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(stats.subject),
                              Text('${stats.accuracy.toStringAsFixed(0)}%'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: stats.accuracy / 100,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
