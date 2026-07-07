import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    final progress = features.tasks.isEmpty
        ? 0.0
        : features.completedTaskCount / features.tasks.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Study Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          Text('${features.completedTaskCount}/${features.tasks.length} tasks completed',
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          ...features.tasks.map(
            (task) => CheckboxListTile(
              value: task.completed,
              onChanged: (_) => features.toggleTask(task.id),
              contentPadding: EdgeInsets.zero,
              secondary: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: Text('${task.minutes}',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
              title: Text(task.title),
              subtitle: Text(task.type),
            ),
          ),
        ],
      ),
    );
  }
}
