import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_config.dart';

class PYQPaper {
  final String id;
  final String examId;
  final String examName;
  final int year;
  final String title;
  final int fileSize;
  final DateTime createdAt;

  PYQPaper({
    required this.id,
    required this.examId,
    required this.examName,
    required this.year,
    required this.title,
    required this.fileSize,
    required this.createdAt,
  });

  factory PYQPaper.fromJson(Map<String, dynamic> json) {
    return PYQPaper(
      id: json['_id'] as String,
      examId: json['examId'] as String,
      examName: json['examName'] as String,
      year: json['year'] as int,
      title: json['title'] as String,
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String get fileSizeLabel {
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(0)} KB';
    return '${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB';
  }
}

class PYQService {
  static String get _baseUrl => AppConfig.baseUrl;

  Future<List<PYQPaper>> fetchPapers({String? examId}) async {
    final uri = Uri.parse('$_baseUrl/pyq').replace(queryParameters: {
      if (examId != null) 'examId': examId,
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw Exception('Server returned ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['papers'] as List;
    return list.map((p) => PYQPaper.fromJson(p as Map<String, dynamic>)).toList();
  }

  /// URL to stream/download a specific paper's PDF
  static String fileUrl(String paperId) => '${AppConfig.baseUrl}/pyq/$paperId/file';
}
