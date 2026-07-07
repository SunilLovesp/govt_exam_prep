import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/feature_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: features.notifications
            .map((notification) => SwitchListTile(
                  value: notification.enabled,
                  onChanged: (_) =>
                      features.toggleNotification(notification.id),
                  title: Text(notification.title),
                  subtitle: Text(notification.time),
                ))
            .toList(),
      ),
    );
  }
}
