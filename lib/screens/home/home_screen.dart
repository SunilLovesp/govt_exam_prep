import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../providers/stats_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${_greeting()},',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Target: ${user.targetExam}',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.accent,
                        child: Text(
                          user.initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  _StatsRow(user: user),
                  const SizedBox(height: 24),

                  // Daily Quiz Banner
                  _DailyQuizBanner(),
                  const SizedBox(height: 24),

                  // Popular Exams
                  _SectionHeader(title: 'Popular Exams', onSeeAll: () {}),
                  const SizedBox(height: 12),
                  _PopularExamsGrid(),
                  const SizedBox(height: 24),

                  // Quick Practice
                  _SectionHeader(title: 'Quick Practice', onSeeAll: () {}),
                  const SizedBox(height: 12),
                  _QuickPracticeList(),
                  const SizedBox(height: 24),

                  // Previous Year Papers
                  _SectionHeader(
                    title: 'Previous Year Papers',
                    onSeeAll: () => context.go('/home/pyq'),
                  ),
                  const SizedBox(height: 12),
                  _PYQBanner(),
                  const SizedBox(height: 24),

                  // Study Material
                  _SectionHeader(title: 'Study Material', onSeeAll: () {}),
                  const SizedBox(height: 12),
                  _SubjectCards(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final dynamic user;
  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: Colors.orange,
          label: 'Day Streak',
          value: '${user.streakDays}',
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.quiz_rounded,
          iconColor: AppColors.primary,
          label: 'Tests Done',
          value: '${user.totalTestsAttempted}',
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.track_changes_rounded,
          iconColor: AppColors.success,
          label: 'Accuracy',
          value: '${user.overallAccuracy.toStringAsFixed(0)}%',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _DailyQuizBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    final qLabel = stats.loaded && stats.total > 0
        ? '${stats.total} questions available'
        : '10 questions • 10 minutes';

    return GestureDetector(
      onTap: () => context.go('/home/quiz/daily_quiz'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, AppColors.accentDark],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Quiz',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$qLabel\nBoost your daily streak!',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  const _StartBadge(),
                ],
              ),
            ),
            const Icon(Icons.bolt_rounded, color: Colors.white, size: 70),
          ],
        ),
      ),
    );
  }
}

class _StartBadge extends StatelessWidget {
  const _StartBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Start Now →',
        style: TextStyle(
            color: AppColors.accentDark,
            fontWeight: FontWeight.bold,
            fontSize: 13),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All'),
        ),
      ],
    );
  }
}

class _PopularExamsGrid extends StatelessWidget {
  final List<_ExamEntry> _exams = const [
    _ExamEntry('SSC CGL', 'ssc_cgl', AppColors.sscColor, Icons.account_balance),
    _ExamEntry('IBPS PO', 'ibps_po', AppColors.bankingColor, Icons.account_balance_wallet),
    _ExamEntry('RRB NTPC', 'rrb_ntpc', AppColors.railwayColor, Icons.train),
    _ExamEntry('UPSC CSE', 'upsc_cse', AppColors.upscColor, Icons.gavel),
    _ExamEntry('SBI PO', 'sbi_po', AppColors.bankingColor, Icons.savings),
    _ExamEntry('CTET', 'ctet', AppColors.teachingColor, Icons.school),
    _ExamEntry('Army GD', 'army_gd', AppColors.armyColor, Icons.shield),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _exams.length,
      itemBuilder: (_, i) => _ExamTile(entry: _exams[i]),
    );
  }
}

class _ExamEntry {
  final String name;
  final String id;
  final Color color;
  final IconData icon;
  const _ExamEntry(this.name, this.id, this.color, this.icon);
}

class _ExamTile extends StatelessWidget {
  final _ExamEntry entry;
  const _ExamTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home/exams/${entry.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: entry.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: entry.color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(entry.icon, color: entry.color, size: 30),
            const SizedBox(height: 6),
            Text(
              entry.name,
              style: TextStyle(
                  color: entry.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickPracticeList extends StatelessWidget {
  // title shown in UI, dbSubject = exact subject name in MongoDB
  static const _items = [
    {'title': 'Quantitative Aptitude', 'dbSubject': 'Quantitative Aptitude', 'color': AppColors.quantColor, 'icon': Icons.calculate_rounded},
    {'title': 'Logical Reasoning', 'dbSubject': 'Reasoning', 'color': AppColors.reasoningColor, 'icon': Icons.psychology_rounded},
    {'title': 'English Language', 'dbSubject': 'English', 'color': AppColors.englishColor, 'icon': Icons.translate_rounded},
    {'title': 'General Awareness', 'dbSubject': 'General Awareness', 'color': AppColors.gkColor, 'icon': Icons.public_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    return Column(
      children: _items.map((item) {
        final count = stats.countForSubject(item['dbSubject'] as String);
        final sub = stats.loaded
            ? (count > 0 ? '$count questions' : 'No questions yet')
            : 'Loading…';
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _PracticeCard(item: {...item, 'sub': sub}),
        );
      }).toList(),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _PracticeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item['color'] as Color;
    return GestureDetector(
      onTap: () => context.go('/home/quiz/practice_${item['title'].toString().toLowerCase().replaceAll(' ', '_')}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
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
              child: Icon(item['icon'] as IconData, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(item['sub'] as String,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _SubjectCards extends StatelessWidget {
  final List<Map<String, dynamic>> _subjects = const [
    {'name': 'Quant', 'chapters': '24 Chapters', 'color': AppColors.quantColor, 'icon': Icons.calculate_rounded},
    {'name': 'Reasoning', 'chapters': '18 Chapters', 'color': AppColors.reasoningColor, 'icon': Icons.psychology_rounded},
    {'name': 'English', 'chapters': '15 Chapters', 'color': AppColors.englishColor, 'icon': Icons.translate_rounded},
    {'name': 'GK / GS', 'chapters': '30 Chapters', 'color': AppColors.gkColor, 'icon': Icons.public_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _subjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final s = _subjects[i];
          final color = s['color'] as Color;
          return GestureDetector(
            onTap: () => context.go('/home/study-material'),
            child: Container(
              width: 110,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(s['icon'] as IconData, color: color, size: 28),
                  const Spacer(),
                  Text(s['name'] as String,
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(s['chapters'] as String,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PYQBanner extends StatelessWidget {
  static const _exams = [
    {'label': 'SSC CGL', 'color': AppColors.sscColor},
    {'label': 'IBPS PO', 'color': AppColors.bankingColor},
    {'label': 'RRB NTPC', 'color': AppColors.railwayColor},
    {'label': 'UPSC CSE', 'color': AppColors.upscColor},
    {'label': 'Army GD', 'color': AppColors.armyColor},
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/home/pyq'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      color: AppColors.error, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Previous Year Question Papers',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      Text('PDFs with year-wise papers for all exams',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.textHint),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _exams.map((e) {
                final color = e['color'] as Color;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    e['label'] as String,
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
