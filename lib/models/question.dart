class Question {
  final String id;
  final String subject;
  final String topic;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty;
  final String questionHi;
  final List<String> optionsHi;
  final String explanationHi;
  final String topicHi;

  int? selectedIndex;
  bool isMarkedForReview;

  Question({
    required this.id,
    required this.subject,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = 'medium',
    this.questionHi = '',
    this.optionsHi = const [],
    this.explanationHi = '',
    this.topicHi = '',
    this.selectedIndex,
    this.isMarkedForReview = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final rawOptionsHi = json['optionsHi'];
    return Question(
      // Support both local JSON ('id') and MongoDB response ('_id')
      id: (json['_id'] ?? json['id']) as String,
      subject: json['subject'] as String,
      topic: json['topic'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correct'] as int,
      explanation: json['explanation'] as String,
      difficulty: json['difficulty'] as String? ?? 'medium',
      questionHi: json['questionHi'] as String? ?? '',
      optionsHi:
          rawOptionsHi != null ? List<String>.from(rawOptionsHi as List) : [],
      explanationHi: json['explanationHi'] as String? ?? '',
      topicHi: json['topicHi'] as String? ?? '',
    );
  }

  bool get isAnswered => selectedIndex != null;
  bool get isCorrect => selectedIndex == correctIndex;
  bool get isSkipped => selectedIndex == null;
  bool get hasHindi => questionHi.isNotEmpty;

  Question copyWith({int? selectedIndex, bool? isMarkedForReview}) {
    return Question(
      id: id,
      subject: subject,
      topic: topic,
      question: question,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
      difficulty: difficulty,
      questionHi: questionHi,
      optionsHi: optionsHi,
      explanationHi: explanationHi,
      topicHi: topicHi,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isMarkedForReview: isMarkedForReview ?? this.isMarkedForReview,
    );
  }
}
