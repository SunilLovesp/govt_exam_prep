import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../models/study_task.dart';

class WeakArea {
  final String subject;
  final int total;
  final double accuracy;

  const WeakArea({
    required this.subject,
    required this.total,
    required this.accuracy,
  });
}

class LeaderboardEntry {
  final String name;
  final int score;
  final double accuracy;
  final String exam;

  const LeaderboardEntry({
    required this.name,
    required this.score,
    required this.accuracy,
    required this.exam,
  });
}

class NotificationPreference {
  final String id;
  final String title;
  final String time;
  final bool enabled;

  const NotificationPreference({
    required this.id,
    required this.title,
    required this.time,
    required this.enabled,
  });

  NotificationPreference copyWith({bool? enabled}) {
    return NotificationPreference(
      id: id,
      title: title,
      time: time,
      enabled: enabled ?? this.enabled,
    );
  }
}

class FeatureProvider extends ChangeNotifier {
  static const _bookmarksKey = 'bookmarked_questions';
  static const _tasksKey = 'daily_study_tasks';
  static const _attemptsKey = 'quiz_attempts';
  static const _premiumKey = 'premium_enabled';
  static const _offlineKey = 'offline_downloads';
  static const _notificationsKey = 'notification_preferences';

  final List<Question> _bookmarks = [];
  final List<StudyTask> _tasks = [];
  final List<QuizResult> _attempts = [];
  final Set<String> _offlineItems = {};
  bool _premiumEnabled = false;
  List<NotificationPreference> _notifications = const [
    NotificationPreference(
      id: 'daily_quiz',
      title: 'Daily quiz reminder',
      time: '7:00 AM',
      enabled: true,
    ),
    NotificationPreference(
      id: 'streak',
      title: 'Streak reminder',
      time: '9:00 PM',
      enabled: true,
    ),
    NotificationPreference(
      id: 'current_affairs',
      title: 'Current affairs update',
      time: '6:00 PM',
      enabled: false,
    ),
  ];

  List<Question> get bookmarks => List.unmodifiable(_bookmarks);
  List<StudyTask> get tasks => List.unmodifiable(_tasks);
  List<QuizResult> get attempts => List.unmodifiable(_attempts);
  bool get premiumEnabled => _premiumEnabled;
  Set<String> get offlineItems => Set.unmodifiable(_offlineItems);
  List<NotificationPreference> get notifications =>
      List.unmodifiable(_notifications);

  int get completedTaskCount => _tasks.where((task) => task.completed).length;

  List<LeaderboardEntry> get leaderboard {
    final seeded = [
      const LeaderboardEntry(
          name: 'Aarav', score: 184, accuracy: 86, exam: 'SSC CGL'),
      const LeaderboardEntry(
          name: 'Meera', score: 172, accuracy: 82, exam: 'Banking'),
      const LeaderboardEntry(
          name: 'Kabir', score: 159, accuracy: 78, exam: 'Railways'),
    ];
    final mine = _attempts.isEmpty
        ? const <LeaderboardEntry>[]
        : [
            LeaderboardEntry(
              name: 'You',
              score: _attempts.map((a) => a.score).reduce((a, b) => a + b),
              accuracy: _attempts
                      .map((a) => a.accuracy)
                      .reduce((a, b) => a + b) /
                  _attempts.length,
              exam: 'Target',
            )
          ];
    final entries = [...seeded, ...mine]
      ..sort((a, b) => b.score.compareTo(a.score));
    return entries;
  }

  List<WeakArea> get weakAreas {
    final Map<String, _MutableWeakArea> stats = {};
    for (final attempt in _attempts) {
      for (final question in attempt.questions) {
        final stat = stats.putIfAbsent(
          question.subject,
          () => _MutableWeakArea(),
        );
        stat.total++;
        if (question.isCorrect) stat.correct++;
      }
    }
    final areas = stats.entries
        .map((entry) => WeakArea(
              subject: entry.key,
              total: entry.value.total,
              accuracy: entry.value.total == 0
                  ? 0
                  : (entry.value.correct / entry.value.total) * 100,
            ))
        .where((area) => area.total >= 1 && area.accuracy < 70)
        .toList()
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
    return areas;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _premiumEnabled = prefs.getBool(_premiumKey) ?? false;
    _offlineItems
      ..clear()
      ..addAll(prefs.getStringList(_offlineKey) ?? const []);

    _bookmarks
      ..clear()
      ..addAll((prefs.getStringList(_bookmarksKey) ?? const [])
          .map((raw) => Question.fromJson(jsonDecode(raw)))
          .toList());

    _tasks
      ..clear()
      ..addAll((prefs.getStringList(_tasksKey) ?? const [])
          .map((raw) => StudyTask.fromJson(jsonDecode(raw)))
          .toList());
    if (_tasks.isEmpty) _tasks.addAll(_defaultTasks());

    final prefsRaw = prefs.getString(_notificationsKey);
    if (prefsRaw != null) {
      final enabledById = Map<String, bool>.from(jsonDecode(prefsRaw));
      _notifications = _notifications
          .map((n) => n.copyWith(enabled: enabledById[n.id] ?? n.enabled))
          .toList();
    }
    notifyListeners();
  }

  Future<void> toggleBookmark(Question question) async {
    final index = _bookmarks.indexWhere((q) => q.id == question.id);
    if (index >= 0) {
      _bookmarks.removeAt(index);
    } else {
      _bookmarks.insert(0, question.copyWith());
    }
    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(String questionId) =>
      _bookmarks.any((question) => question.id == questionId);

  Future<void> toggleTask(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(completed: !_tasks[index].completed);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> recordAttempt(QuizResult result) async {
    _attempts.insert(0, result);
    if (_attempts.length > 20) _attempts.removeLast();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _attemptsKey,
      _attempts
          .map((attempt) => jsonEncode({
                'title': attempt.testTitle,
                'score': attempt.score,
                'accuracy': attempt.accuracy,
                'completedAt': attempt.completedAt.toIso8601String(),
              }))
          .toList(),
    );
    notifyListeners();
  }

  Future<void> setPremium(bool enabled) async {
    _premiumEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, enabled);
    notifyListeners();
  }

  Future<void> toggleOfflineItem(String id) async {
    if (_offlineItems.contains(id)) {
      _offlineItems.remove(id);
    } else {
      _offlineItems.add(id);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_offlineKey, _offlineItems.toList());
    notifyListeners();
  }

  Future<void> toggleNotification(String id) async {
    _notifications = _notifications
        .map((n) => n.id == id ? n.copyWith(enabled: !n.enabled) : n)
        .toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _notificationsKey,
      jsonEncode({for (final n in _notifications) n.id: n.enabled}),
    );
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _bookmarksKey,
      _bookmarks.map((q) => jsonEncode(_questionToJson(q))).toList(),
    );
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _tasksKey,
      _tasks.map((task) => jsonEncode(task.toJson())).toList(),
    );
  }

  List<StudyTask> _defaultTasks() => const [
        StudyTask(
          id: 'daily_quiz',
          title: 'Attempt daily mixed quiz',
          type: 'Quiz',
          minutes: 10,
        ),
        StudyTask(
          id: 'pyq',
          title: 'Solve one previous year paper section',
          type: 'PYQ',
          minutes: 25,
        ),
        StudyTask(
          id: 'chapter',
          title: 'Revise one weak chapter',
          type: 'Study',
          minutes: 30,
        ),
        StudyTask(
          id: 'current_affairs',
          title: 'Read and quiz current affairs',
          type: 'Current Affairs',
          minutes: 15,
        ),
        StudyTask(
          id: 'revision',
          title: 'Review bookmarked mistakes',
          type: 'Revision',
          minutes: 20,
        ),
      ];

  Map<String, dynamic> _questionToJson(Question q) => {
        'id': q.id,
        'subject': q.subject,
        'topic': q.topic,
        'question': q.question,
        'options': q.options,
        'correct': q.correctIndex,
        'explanation': q.explanation,
        'difficulty': q.difficulty,
        'questionHi': q.questionHi,
        'optionsHi': q.optionsHi,
        'explanationHi': q.explanationHi,
        'topicHi': q.topicHi,
      };
}

class _MutableWeakArea {
  int total = 0;
  int correct = 0;
}
