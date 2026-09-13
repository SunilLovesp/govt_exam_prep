import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../services/api_service.dart';

enum QuizState { idle, loading, active, paused, completed, error }

class QuizProvider extends ChangeNotifier {
  QuizState _state = QuizState.idle;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _secondsElapsed = 0;
  int _totalSeconds = 0;
  String _testId = '';
  String _testTitle = '';
  String? _subject;
  String? _examType;
  int _questionLimit = 200;
  String _errorMessage = '';
  Timer? _timer;

  QuizState get state => _state;
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get secondsElapsed => _secondsElapsed;
  int get secondsLeft => _totalSeconds - _secondsElapsed;
  String get testId => _testId;
  String get testTitle => _testTitle;
  String get errorMessage => _errorMessage;

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
    String? subject,
    String? examType,
    int questionLimit = 200,
  }) async {
    _testId = testId;
    _testTitle = testTitle;
    _subject = subject;
    _examType = examType;
    _questionLimit = questionLimit;
    _totalSeconds = durationMinutes * 60;
    await _fetchQuestions();
  }

  Future<void> retry() => _fetchQuestions();

  Future<void> _fetchQuestions() async {
    _timer?.cancel();
    _state = QuizState.loading;
    _errorMessage = '';
    _questions = [];
    _secondsElapsed = 0;
    _currentIndex = 0;
    notifyListeners();

    try {
      final questions = await ApiService().fetchQuestions(
        subject: _subject,
        examType: _examType,
        limit: _questionLimit,
      );
      if (questions.isEmpty) {
        _state = QuizState.error;
        _errorMessage =
            'No questions available for this test yet. Add questions from the admin panel and try again.';
      } else {
        questions.shuffle();
        _questions = questions;
        _state = QuizState.active;
        _startTimer();
      }
    } catch (e) {
      _state = QuizState.error;
      _errorMessage = e is ApiException ? e.message : e.toString();
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
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
