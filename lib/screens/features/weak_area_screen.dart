import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class WeakAreaScreen extends StatelessWidget {
  const WeakAreaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final areas = context.watch<FeatureProvider>().weakAreas;
    return Scaffold(
      appBar: AppBar(title: const Text('Weak Area Practice')),
      body: areas.isEmpty
          ? const Center(child: Text('Complete a quiz to discover weak areas.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: areas.length,
              itemBuilder: (_, index) {
                final area = areas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(area.subject,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: area.accuracy / 100,
                        color: area.accuracy < 40
                            ? AppColors.error
                            : AppColors.warning,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          '${area.accuracy.toStringAsFixed(0)}% accuracy across ${area.total} questions'),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => context.go('/home/quiz/weak_area'),
                          child: const Text('Practice 20 Questions'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
