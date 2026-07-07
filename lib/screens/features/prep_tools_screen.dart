import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class PrepToolsScreen extends StatelessWidget {
  const PrepToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    final tools = [
      _ToolItem(
        title: 'Daily Study Plan',
        subtitle:
            '${features.completedTaskCount}/${features.tasks.length} tasks completed',
        icon: Icons.today_rounded,
        route: '/home/tools/study-plan',
        color: AppColors.primary,
      ),
      _ToolItem(
        title: 'Bookmarked Questions',
        subtitle: '${features.bookmarks.length} saved questions',
        icon: Icons.bookmark_rounded,
        route: '/home/tools/bookmarks',
        color: AppColors.warning,
      ),
      _ToolItem(
        title: 'Weak Area Practice',
        subtitle: features.weakAreas.isEmpty
            ? 'Attempt tests to unlock insights'
            : '${features.weakAreas.length} areas need attention',
        icon: Icons.psychology_alt_rounded,
        route: '/home/tools/weak-areas',
        color: AppColors.error,
      ),
      const _ToolItem(
        title: 'Mock Test Analysis',
        subtitle: 'Rank, percentile and subject report',
        icon: Icons.analytics_rounded,
        route: '/home/tools/mock-analysis',
        color: AppColors.success,
      ),
      const _ToolItem(
        title: 'Current Affairs Quiz',
        subtitle: 'Daily MCQs with quick review',
        icon: Icons.newspaper_rounded,
        route: '/home/tools/current-affairs-quiz',
        color: AppColors.accent,
      ),
      const _ToolItem(
        title: 'Leaderboard',
        subtitle: 'Daily, weekly and exam-wise ranks',
        icon: Icons.leaderboard_rounded,
        route: '/home/tools/leaderboard',
        color: Colors.indigo,
      ),
      _ToolItem(
        title: 'Premium Access',
        subtitle: features.premiumEnabled ? 'Premium active' : 'Free plan',
        icon: Icons.workspace_premium_rounded,
        route: '/home/tools/premium',
        color: Colors.deepPurple,
      ),
      const _ToolItem(
        title: 'Notifications',
        subtitle: 'Quiz, streak and content reminders',
        icon: Icons.notifications_active_rounded,
        route: '/home/tools/notifications',
        color: Colors.teal,
      ),
      _ToolItem(
        title: 'Offline Downloads',
        subtitle: '${features.offlineItems.length} items available offline',
        icon: Icons.download_for_offline_rounded,
        route: '/home/tools/offline',
        color: Colors.blueGrey,
      ),
      const _ToolItem(
        title: 'Admin Upload Tags',
        subtitle: 'CSV/PDF import fields supported',
        icon: Icons.sell_rounded,
        route: '/home/tools/admin-tags',
        color: Colors.brown,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Prep Tools')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => _ToolCard(item: tools[index]),
      ),
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;

  const _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.color,
  });
}

class _ToolCard extends StatelessWidget {
  final _ToolItem item;
  const _ToolCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(item.subtitle,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
