import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    const items = [
      ('quant_formula', 'Quant Formula Pack'),
      ('reasoning_notes', 'Reasoning Short Notes'),
      ('pyq_ssc', 'SSC PYQ PDF Set'),
      ('ca_monthly', 'Monthly Current Affairs'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Downloads')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items
            .map(
              (item) => ListTile(
                leading: Icon(
                  features.offlineItems.contains(item.$1)
                      ? Icons.download_done_rounded
                      : Icons.download_rounded,
                  color: features.offlineItems.contains(item.$1)
                      ? AppColors.success
                      : AppColors.primary,
                ),
                title: Text(item.$2),
                subtitle: Text(features.offlineItems.contains(item.$1)
                    ? 'Available offline'
                    : 'Tap to download'),
                onTap: () => features.toggleOfflineItem(item.$1),
              ),
            )
            .toList(),
      ),
    );
  }
}
