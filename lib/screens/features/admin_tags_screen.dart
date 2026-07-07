import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AdminTagsScreen extends StatelessWidget {
  const AdminTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const fields = [
      'subject',
      'topic',
      'examType',
      'difficulty',
      'year',
      'isPremium',
      'question',
      'optionA',
      'optionB',
      'optionC',
      'optionD',
      'correct',
      'explanation',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Upload Tags')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Bulk upload supports CSV/PDF imports with these tags.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fields
                .map((field) => Chip(
                      label: Text(field),
                      backgroundColor: AppColors.primaryLight.withOpacity(0.18),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
