import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel.empty();
  bool _isDarkMode = false;
  bool _isLoggedIn = false;

  UserModel get user => _user;
  bool get isDarkMode => _isDarkMode;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    if (_isLoggedIn) {
      _user = UserModel(
        id: prefs.getString('user_id') ?? '',
        name: prefs.getString('user_name') ?? 'Student',
        email: prefs.getString('user_email') ?? '',
        targetExam: prefs.getString('target_exam') ?? 'SSC CGL',
        streakDays: prefs.getInt('streak_days') ?? 0,
        totalTestsAttempted: prefs.getInt('total_tests') ?? 0,
        overallAccuracy: prefs.getDouble('overall_accuracy') ?? 0.0,
        joinedAt: DateTime.now(),
      );
    }
    notifyListeners();
  }

  Future<void> login(String name, String email) async {
    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      joinedAt: DateTime.now(),
    );
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_id', _user.id);
    await prefs.setString('user_name', _user.name);
    await prefs.setString('user_email', _user.email);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _user = UserModel.empty();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? targetExam}) async {
    _user = _user.copyWith(name: name, targetExam: targetExam);
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('user_name', name);
    if (targetExam != null) await prefs.setString('target_exam', targetExam);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }

  Future<void> incrementStreak() async {
    _user = _user.copyWith(streakDays: _user.streakDays + 1);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak_days', _user.streakDays);
    notifyListeners();
  }

  Future<void> updateStats({required int testsAttempted, required double accuracy}) async {
    _user = _user.copyWith(
      totalTestsAttempted: testsAttempted,
      overallAccuracy: accuracy,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_tests', testsAttempted);
    await prefs.setDouble('overall_accuracy', accuracy);
    notifyListeners();
  }
}
