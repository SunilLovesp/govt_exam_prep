class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String targetExam;
  final int streakDays;
  final int totalTestsAttempted;
  final double overallAccuracy;
  final DateTime joinedAt;
  final bool notificationsEnabled;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.targetExam = 'SSC CGL',
    this.streakDays = 0,
    this.totalTestsAttempted = 0,
    this.overallAccuracy = 0.0,
    required this.joinedAt,
    this.notificationsEnabled = true,
  });

  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: 'Student',
      email: '',
      joinedAt: DateTime.now(),
    );
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? targetExam,
    int? streakDays,
    int? totalTestsAttempted,
    double? overallAccuracy,
    bool? notificationsEnabled,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      targetExam: targetExam ?? this.targetExam,
      streakDays: streakDays ?? this.streakDays,
      totalTestsAttempted: totalTestsAttempted ?? this.totalTestsAttempted,
      overallAccuracy: overallAccuracy ?? this.overallAccuracy,
      joinedAt: joinedAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'S';
  }
}
