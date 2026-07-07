class StudyTask {
  final String id;
  final String title;
  final String type;
  final int minutes;
  final bool completed;

  const StudyTask({
    required this.id,
    required this.title,
    required this.type,
    required this.minutes,
    this.completed = false,
  });

  StudyTask copyWith({bool? completed}) {
    return StudyTask(
      id: id,
      title: title,
      type: type,
      minutes: minutes,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'minutes': minutes,
        'completed': completed,
      };

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      minutes: json['minutes'] as int,
      completed: json['completed'] as bool? ?? false,
    );
  }
}
