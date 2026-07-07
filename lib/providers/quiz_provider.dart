import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../services/api_service.dart';

enum QuizState { idle, loading, active, paused, completed }

class QuizProvider extends ChangeNotifier {
  QuizState _state = QuizState.idle;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _secondsElapsed = 0;
  int _totalSeconds = 0;
  String _testId = '';
  String _testTitle = '';
  Timer? _timer;

  QuizState get state => _state;
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get secondsElapsed => _secondsElapsed;
  int get secondsLeft => _totalSeconds - _secondsElapsed;
  String get testId => _testId;
  String get testTitle => _testTitle;

  Question? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentIndex] : null;

  String get timerFormatted {
    final left = secondsLeft;
    final m = left ~/ 60;
    final s = left % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get isTimerCritical => secondsLeft <= 300; // last 5 minutes

  int get answeredCount => _questions.where((q) => q.isAnswered).length;
  int get markedCount => _questions.where((q) => q.isMarkedForReview).length;
  int get skippedCount => _questions.where((q) => q.isSkipped).length;

  Future<void> loadTest({
    required String testId,
    required String testTitle,
    required int durationMinutes,
  }) async {
    _state = QuizState.loading;
    _testId = testId;
    _testTitle = testTitle;
    _totalSeconds = durationMinutes * 60;
    _secondsElapsed = 0;
    _currentIndex = 0;
    notifyListeners();

    try {
      // Try fetching from backend API first — use ALL available questions
      final allQuestions = await ApiService().fetchQuestions();
      allQuestions.shuffle();
      _questions = allQuestions; // no artificial limit
      _state = QuizState.active;
      _startTimer();
    } catch (_) {
      // API unavailable — fall back to bundled local JSON
      try {
        final jsonStr =
            await rootBundle.loadString('assets/data/questions.json');
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        final allQuestions = (data['questions'] as List)
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList();
        allQuestions.shuffle();
        _questions = allQuestions;
        _state = QuizState.active;
        _startTimer();
      } catch (_) {
        _questions = _generateDummyQuestions();
        _state = QuizState.active;
        _startTimer();
      }
    }
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      if (_secondsElapsed >= _totalSeconds) {
        _timer?.cancel();
        _state = QuizState.completed;
      }
      notifyListeners();
    });
  }

  void selectAnswer(int optionIndex) {
    if (_state != QuizState.active) return;
    _questions[_currentIndex] = _questions[_currentIndex].copyWith(
      selectedIndex: optionIndex,
    );
    notifyListeners();
  }

  void clearAnswer() {
    if (_state != QuizState.active) return;
    _questions[_currentIndex] = Question(
      id: _questions[_currentIndex].id,
      subject: _questions[_currentIndex].subject,
      topic: _questions[_currentIndex].topic,
      question: _questions[_currentIndex].question,
      options: _questions[_currentIndex].options,
      correctIndex: _questions[_currentIndex].correctIndex,
      explanation: _questions[_currentIndex].explanation,
      difficulty: _questions[_currentIndex].difficulty,
      selectedIndex: null,
      isMarkedForReview: _questions[_currentIndex].isMarkedForReview,
    );
    notifyListeners();
  }

  void toggleMarkForReview() {
    final q = _questions[_currentIndex];
    _questions[_currentIndex] =
        q.copyWith(isMarkedForReview: !q.isMarkedForReview);
    notifyListeners();
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void nextQuestion() => goToQuestion(_currentIndex + 1);
  void prevQuestion() => goToQuestion(_currentIndex - 1);

  QuizResult submitTest() {
    _timer?.cancel();
    _state = QuizState.completed;
    notifyListeners();
    return QuizResult(
      testId: _testId,
      testTitle: _testTitle,
      questions: List.from(_questions),
      timeTakenSeconds: _secondsElapsed,
      completedAt: DateTime.now(),
    );
  }

  void reset() {
    _timer?.cancel();
    _state = QuizState.idle;
    _questions = [];
    _currentIndex = 0;
    _secondsElapsed = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Question> _generateDummyQuestions() {
    final subjects = [
      'Quantitative Aptitude',
      'Reasoning',
      'English',
      'General Awareness',
    ];
    final questions = <Question>[];
    int id = 1;
    for (int i = 0; i < 20; i++) {
      final subject = subjects[i % subjects.length];
      questions.add(Question(
        id: 'q${id++}',
        subject: subject,
        topic: 'Practice',
        question:
            'Sample question ${i + 1} for $subject?\n(This is a placeholder. Add real questions in assets/data/questions.json)',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctIndex: i % 4,
        explanation:
            'The correct answer is Option ${String.fromCharCode(65 + (i % 4))}. Detailed explanation would appear here.',
        difficulty: ['easy', 'medium', 'hard'][i % 3],
      ));
    }
    return questions;
  }
}
