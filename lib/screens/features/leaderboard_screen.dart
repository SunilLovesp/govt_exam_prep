import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<FeatureProvider>().leaderboard;
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: entries.length,
        itemBuilder: (_, index) {
          final entry = entries[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  entry.name == 'You' ? AppColors.primary : AppColors.divider,
              child: Text('${index + 1}'),
            ),
            title: Text(entry.name),
            subtitle: Text('${entry.exam} • ${entry.accuracy.toStringAsFixed(0)}% accuracy'),
            trailing: Text('${entry.score}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          );
        },
      ),
    );
  }
}
