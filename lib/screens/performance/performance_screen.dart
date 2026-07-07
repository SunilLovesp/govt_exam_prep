import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('My Performance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview cards
            Row(
              children: [
                _OverviewCard(
                  label: 'Tests Attempted',
                  value: '${user.totalTestsAttempted}',
                  icon: Icons.quiz_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                _OverviewCard(
                  label: 'Overall Accuracy',
                  value: '${user.overallAccuracy.toStringAsFixed(1)}%',
                  icon: Icons.track_changes_rounded,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _OverviewCard(
                  label: 'Day Streak',
                  value: '${user.streakDays}',
                  icon: Icons.local_fire_department_rounded,
                  color: Colors.orange,
                ),
                const SizedBox(width: 12),
                const _OverviewCard(
                  label: 'Avg Score',
                  value: '72%',
                  icon: Icons.star_rounded,
                  color: AppColors.accent,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly performance bar chart
            const _SectionTitle(title: 'Weekly Performance'),
            const SizedBox(height: 12),
            _WeeklyBarChart(),
            const SizedBox(height: 24),

            // Subject-wise accuracy
            const _SectionTitle(title: 'Subject-wise Accuracy'),
            const SizedBox(height: 12),
            _SubjectAccuracyList(),
            const SizedBox(height: 24),

            // Leaderboard teaser
            const _SectionTitle(title: 'Leaderboard'),
            const SizedBox(height: 12),
            _LeaderboardCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}

class _OverviewCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                      maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<double> _scores = const [65, 72, 58, 80, 75, 88, 70];
  final List<String> _days = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: 100,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  _days[value.toInt()],
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
                interval: 25,
              ),
            ),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: AppColors.divider,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            _scores.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _scores[i],
                  color: _scores[i] >= 75
                      ? AppColors.success
                      : _scores[i] >= 60
                          ? AppColors.primary
                          : AppColors.warning,
                  width: 20,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectAccuracyList extends StatelessWidget {
  final List<Map<String, dynamic>> _subjects = const [
    {
      'name': 'Quantitative Aptitude',
      'accuracy': 78.0,
      'color': AppColors.quantColor,
      'questions': 240
    },
    {
      'name': 'Logical Reasoning',
      'accuracy': 85.0,
      'color': AppColors.reasoningColor,
      'questions': 180
    },
    {
      'name': 'English Language',
      'accuracy': 62.0,
      'color': AppColors.englishColor,
      'questions': 150
    },
    {
      'name': 'General Awareness',
      'accuracy': 55.0,
      'color': AppColors.gkColor,
      'questions': 200
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: _subjects.map((s) {
          final color = s['color'] as Color;
          final acc = s['accuracy'] as double;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(s['name'] as String,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                    Text('${acc.toInt()}%',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: acc / 100,
                    minHeight: 8,
                    backgroundColor: color.withOpacity(0.15),
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text('${s['questions']} questions attempted',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final List<Map<String, dynamic>> _toppers = const [
    {'rank': 1, 'name': 'Priya Sharma', 'score': 94, 'exam': 'SSC CGL'},
    {'rank': 2, 'name': 'Rahul Kumar', 'score': 91, 'exam': 'IBPS PO'},
    {'rank': 3, 'name': 'Anjali Singh', 'score': 89, 'exam': 'SSC CGL'},
    {'rank': 4, 'name': 'Vikram Patel', 'score': 87, 'exam': 'RRB NTPC'},
    {'rank': 5, 'name': 'Neha Gupta', 'score': 86, 'exam': 'UPSC CSE'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: _toppers.map((t) {
          final rank = t['rank'] as int;
          final medal = rank == 1
              ? '🥇'
              : rank == 2
                  ? '🥈'
                  : rank == 3
                      ? '🥉'
                      : '#$rank';
          return ListTile(
            leading: SizedBox(
              width: 32,
              child: Text(
                medal,
                style: TextStyle(
                    fontSize: rank <= 3 ? 22 : 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            title: Text(t['name'] as String,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle:
                Text(t['exam'] as String, style: const TextStyle(fontSize: 12)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${t['score']}%',
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
