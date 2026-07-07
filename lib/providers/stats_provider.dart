import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class StatsProvider extends ChangeNotifier {
  int _total = 0;
  Map<String, int> _bySubject = {};
  Map<String, int> _byDifficulty = {};
  bool _loaded = false;

  int get total => _total;
  bool get loaded => _loaded;
  Map<String, int> get bySubject => _bySubject;
  Map<String, int> get byDifficulty => _byDifficulty;

  int countForSubject(String subject) => _bySubject[subject] ?? 0;

  Future<void> loadStats() async {
    try {
      final stats = await ApiService().fetchStats();
      _total = stats['total'] as int;
      _bySubject = Map<String, int>.from(stats['bySubject'] as Map);
      _byDifficulty = Map<String, int>.from(stats['byDifficulty'] as Map);
      _loaded = true;
      notifyListeners();
    } catch (_) {
      // Backend offline — keep zeros, UI will fall back gracefully
    }
  }
}
