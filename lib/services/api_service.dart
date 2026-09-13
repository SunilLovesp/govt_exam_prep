import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import '../core/constants/app_config.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static String get _baseUrl => AppConfig.baseUrl;

  /// Returns { total, bySubject: Map<subject, count>, byDifficulty: Map<difficulty, count> }
  Future<Map<String, dynamic>> fetchStats() async {
    final uri = Uri.parse('$_baseUrl/questions/stats');
    final response = await _get(uri);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final bySubjectList = data['bySubject'] as List;
    final byDiffList = data['byDifficulty'] as List;
    final bySubject = <String, int>{};
    for (final item in bySubjectList) {
      bySubject[item['_id'] as String] = item['count'] as int;
    }
    final byDifficulty = <String, int>{};
    for (final item in byDiffList) {
      byDifficulty[item['_id'] as String] = item['count'] as int;
    }
    return {
      'total': data['total'] as int,
      'bySubject': bySubject,
      'byDifficulty': byDifficulty,
    };
  }

  Future<List<Question>> fetchQuestions({
    String? subject,
    String? difficulty,
    String? examType,
    int limit = 200,
  }) async {
    final uri = Uri.parse('$_baseUrl/questions').replace(queryParameters: {
      if (subject != null) 'subject': subject,
      if (difficulty != null) 'difficulty': difficulty,
      if (examType != null) 'examType': examType,
      'limit': limit.toString(),
    });

    final response = await _get(uri);

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['questions'] as List;
    return list
        .map((q) => Question.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  Future<http.Response> _get(Uri uri) async {
    http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw ApiException('The server at $_baseUrl took too long to respond.');
    } on http.ClientException catch (e) {
      throw ApiException('Cannot reach the server at $_baseUrl. ${e.message}');
    } catch (e) {
      throw ApiException('Cannot reach the server at $_baseUrl. $e');
    }
    if (response.statusCode != 200) {
      throw ApiException(
          'Server returned ${response.statusCode} for ${uri.path}.');
    }
    return response;
  }
}
