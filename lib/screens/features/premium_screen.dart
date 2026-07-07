import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Access')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: features.premiumEnabled,
            onChanged: features.setPremium,
            title: const Text('Premium Access'),
            subtitle: const Text('Unlock paid test series, PDFs and explanations'),
          ),
          const SizedBox(height: 16),
          ...[
            'Full length premium mocks',
            'Chapter-wise advanced explanations',
            'Premium previous year papers',
            'Priority current affairs packs',
          ].map((benefit) => ListTile(
                leading:
                    const Icon(Icons.check_circle_rounded, color: AppColors.success),
                title: Text(benefit),
              )),
        ],
      ),
    );
  }
}
