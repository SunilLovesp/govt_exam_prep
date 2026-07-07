import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfile(context, userProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      user.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user.email,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Target: ${user.targetExam}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            // Stats row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProfileStat(
                      label: 'Tests', value: '${user.totalTestsAttempted}'),
                  _Divider(),
                  _ProfileStat(
                      label: 'Streak', value: '${user.streakDays} days'),
                  _Divider(),
                  _ProfileStat(
                      label: 'Accuracy',
                      value: '${user.overallAccuracy.toStringAsFixed(0)}%'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Settings sections
            _SettingsSection(
              title: 'Preferences',
              tiles: [
                _SettingsTile(
                  icon: Icons.flag_outlined,
                  title: 'Target Exam',
                  subtitle: user.targetExam,
                  onTap: () => _showExamPicker(context, userProvider),
                ),
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: userProvider.isDarkMode,
                    onChanged: (_) => userProvider.toggleDarkMode(),
                    activeColor: AppColors.primary,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  trailing: Switch(
                    value: user.notificationsEnabled,
                    onChanged: (_) {},
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),

            _SettingsSection(
              title: 'Study',
              tiles: [
                _SettingsTile(
                  icon: Icons.bar_chart_rounded,
                  title: 'My Performance',
                  onTap: () => context.go('/home/performance'),
                ),
                _SettingsTile(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'Bookmarked Questions',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.history_rounded,
                  title: 'Test History',
                  onTap: () {},
                ),
              ],
            ),

            _SettingsSection(
              title: 'App',
              tiles: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About ExamPrep India',
                  onTap: () => _showAbout(context),
                ),
                _SettingsTile(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: 'Rate Us',
                  onTap: () {},
                ),
              ],
            ),

            // Logout button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context, userProvider),
                  icon:
                      const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: const Text('Logout',
                      style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, UserProvider provider) {
    final nameCtrl = TextEditingController(text: provider.user.name);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Profile', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.updateProfile(name: nameCtrl.text.trim());
                  Navigator.pop(ctx);
                },
                child: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showExamPicker(BuildContext context, UserProvider provider) {
    final exams = [
      'SSC CGL',
      'SSC CHSL',
      'SSC MTS',
      'UPSC CSE',
      'IBPS PO',
      'SBI PO',
      'RRB NTPC',
      'RRB Group D',
      'CTET',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text('Select Target Exam',
              style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          ...exams.map((e) => ListTile(
                title: Text(e),
                trailing: provider.user.targetExam == e
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  provider.updateProfile(targetExam: e);
                  Navigator.pop(ctx);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ExamPrep India',
      applicationVersion: '1.0.0',
      applicationIcon:
          const Icon(Icons.school_rounded, size: 48, color: AppColors.primary),
      children: const [
        Text(
          'ExamPrep India helps you prepare for SSC, UPSC, Banking, Railway and all major government exams with mock tests, study material, and current affairs.',
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, UserProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final router = GoRouter.of(context);
              Navigator.pop(context);
              await provider.logout();
              router.go(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.divider);
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> tiles;
  const _SettingsSection({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(title,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary))
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textHint)
              : null),
      onTap: onTap,
    );
  }
}
