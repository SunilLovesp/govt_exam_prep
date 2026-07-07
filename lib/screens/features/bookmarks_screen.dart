import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/feature_provider.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = context.watch<FeatureProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Questions')),
      body: features.bookmarks.isEmpty
          ? const Center(child: Text('Save questions from review to practice later.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: features.bookmarks.length,
              itemBuilder: (_, index) {
                final q = features.bookmarks[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text('${q.subject} • ${q.topic}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_remove_rounded),
                            onPressed: () => features.toggleBookmark(q),
                          ),
                        ],
                      ),
                      Text(q.question,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, height: 1.4)),
                      const SizedBox(height: 8),
                      Text('Answer: ${q.options[q.correctIndex]}',
                          style: const TextStyle(color: AppColors.success)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
