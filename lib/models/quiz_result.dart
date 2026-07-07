import 'question.dart';

class QuizResult {
  final String testId;
  final String testTitle;
  final List<Question> questions;
  final int timeTakenSeconds;
  final DateTime completedAt;

  QuizResult({
    required this.testId,
    required this.testTitle,
    required this.questions,
    required this.timeTakenSeconds,
    required this.completedAt,
  });

  int get totalQuestions => questions.length;

  int get correctCount => questions.where((q) => q.isCorrect).length;

  int get incorrectCount => questions.where((q) => q.isAnswered && !q.isCorrect).length;

  int get skippedCount => questions.where((q) => q.isSkipped).length;

  double get accuracy => totalQuestions == 0 ? 0 : (correctCount / totalQuestions) * 100;

  int get score => correctCount * 2 - incorrectCount; // 2 marks correct, -1 wrong (example)

  String get timeTakenFormatted {
    final minutes = timeTakenSeconds ~/ 60;
    final seconds = timeTakenSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Map<String, SubjectStats> get subjectWiseStats {
    final Map<String, SubjectStats> stats = {};
    for (final q in questions) {
      final subject = q.subject;
      if (!stats.containsKey(subject)) {
        stats[subject] = SubjectStats(subject: subject);
      }
      if (q.isCorrect) {
        stats[subject]!.correct++;
      } else if (q.isAnswered) {
        stats[subject]!.incorrect++;
      } else {
        stats[subject]!.skipped++;
      }
    }
    return stats;
  }
}

class SubjectStats {
  final String subject;
  int correct = 0;
  int incorrect = 0;
  int skipped = 0;

  SubjectStats({required this.subject});

  int get total => correct + incorrect + skipped;
  double get accuracy => total == 0 ? 0 : (correct / total) * 100;
}
