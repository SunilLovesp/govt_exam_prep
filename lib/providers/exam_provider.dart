import 'package:flutter/foundation.dart';
import '../models/exam.dart';

class ExamProvider extends ChangeNotifier {
  String _selectedCategoryId = 'all';
  String _searchQuery = '';

  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  List<ExamCategory> get categories => examCategories;

  List<ExamCategory> get filteredCategories {
    if (_selectedCategoryId == 'all') return examCategories;
    return examCategories.where((c) => c.id == _selectedCategoryId).toList();
  }

  List<Exam> get allExams => examCategories.expand((c) => c.exams).toList();
  List<Exam> get filteredExams {
    List<Exam> exams;
    if (_selectedCategoryId == 'all') {
      exams = allExams;
    } else {
      exams = examCategories
          .where((c) => c.id == _selectedCategoryId)
          .expand((c) => c.exams)
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      exams = exams
          .where((e) =>
              e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.fullName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return exams;
  }

  Exam? getExamById(String id) {
    try {
      return allExams.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  ExamCategory? getCategoryForExam(String examId) {
    try {
      return examCategories.firstWhere(
        (c) => c.exams.any((e) => e.id == examId),
      );
    } catch (_) {
      return null;
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
