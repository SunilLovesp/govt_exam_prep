import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/quiz_result.dart';
import '../../models/question.dart';
import '../../providers/feature_provider.dart';

class ReviewScreen extends StatefulWidget {
  final QuizResult result;
  const ReviewScreen({super.key, required this.result});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _filter = 'all'; // 'all', 'correct', 'incorrect', 'skipped'
  bool _showHindi = false;

  List<Question> get _filtered {
    switch (_filter) {
      case 'correct':
        return widget.result.questions.where((q) => q.isCorrect).toList();
      case 'incorrect':
        return widget.result.questions
            .where((q) => q.isAnswered && !q.isCorrect)
            .toList();
      case 'skipped':
        return widget.result.questions.where((q) => q.isSkipped).toList();
      default:
        return widget.result.questions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Solutions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          // Show language toggle only if any question has Hindi content
          if (widget.result.questions.any((q) => q.hasHindi))
            GestureDetector(
              onTap: () => setState(() => _showHindi = !_showHindi),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: _showHindi ? Colors.white : Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _showHindi ? 'हिं' : 'EN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: _showHindi ? AppColors.primary : Colors.white,
                      fontFamily: _showHindi ? GoogleFonts.notoSansDevanagari().fontFamily : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'All (${widget.result.totalQuestions})', value: 'all', current: _filter, onTap: (v) => setState(() => _filter = v)),
                  const SizedBox(width: 8),
                  _FilterChip(label: '✓ Correct (${widget.result.correctCount})', value: 'correct', current: _filter, onTap: (v) => setState(() => _filter = v), color: AppColors.success),
                  const SizedBox(width: 8),
                  _FilterChip(label: '✗ Wrong (${widget.result.incorrectCount})', value: 'incorrect', current: _filter, onTap: (v) => setState(() => _filter = v), color: AppColors.error),
                  const SizedBox(width: 8),
                  _FilterChip(label: '— Skipped (${widget.result.skippedCount})', value: 'skipped', current: _filter, onTap: (v) => setState(() => _filter = v), color: AppColors.warning),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Questions list
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('No questions in this category',
                        style: TextStyle(color: AppColors.textSecondary)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _ReviewCard(
                      question: _filtered[i],
                      qNumber: widget.result.questions.indexOf(_filtered[i]) + 1,
                      showHindi: _showHindi,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final void Function(String) onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : AppColors.divider),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final Question question;
  final int qNumber;
  final bool showHindi;
  const _ReviewCard({required this.question, required this.qNumber, this.showHindi = false});

  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final hi = widget.showHindi && q.hasHindi;
    final questionText = hi ? q.questionHi : q.question;
    final optionsList = (hi && q.optionsHi.length == 4) ? q.optionsHi : q.options;
    final explanationText = (hi && q.explanationHi.isNotEmpty) ? q.explanationHi : q.explanation;
    final devanagariStyle = GoogleFonts.notoSansDevanagari(fontSize: 13, height: 1.6);
    final statusColor = q.isCorrect
        ? AppColors.success
        : q.isAnswered
            ? AppColors.error
            : AppColors.warning;
    final statusLabel = q.isCorrect ? 'Correct' : q.isAnswered ? 'Wrong' : 'Skipped';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text('Q${widget.qNumber}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: statusColor)),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    context.watch<FeatureProvider>().isBookmarked(q.id)
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  onPressed: () =>
                      context.read<FeatureProvider>().toggleBookmark(q),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusLabel,
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(questionText,
                    style: hi ? GoogleFonts.notoSansDevanagari(fontSize: 14, height: 1.6) : const TextStyle(fontSize: 14, height: 1.5)),
                const SizedBox(height: 12),

                // Options
                ...List.generate(optionsList.length, (i) {
                  final isCorrect = i == q.correctIndex;
                  final isSelected = i == q.selectedIndex;
                  Color? bg;
                  Color? border;
                  if (isCorrect) {
                    bg = AppColors.successLight;
                    border = AppColors.success;
                  } else if (isSelected && !isCorrect) {
                    bg = AppColors.errorLight;
                    border = AppColors.error;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: bg ?? AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: border ?? AppColors.divider, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${String.fromCharCode(65 + i)}. ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: border ?? AppColors.textSecondary),
                        ),
                        Expanded(
                          child: Text(optionsList[i],
                              style: hi ? devanagariStyle : const TextStyle(fontSize: 13)),
                        ),
                        if (isCorrect)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.success, size: 18),
                        if (isSelected && !isCorrect)
                          const Icon(Icons.cancel_rounded,
                              color: AppColors.error, size: 18),
                      ],
                    ),
                  );
                }),

                // Explanation toggle
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () =>
                      setState(() => _showExplanation = !_showExplanation),
                  child: Row(
                    children: [
                      Icon(
                        _showExplanation
                            ? Icons.expand_less_rounded
                            : Icons.lightbulb_outline_rounded,
                        size: 18,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showExplanation ? 'Hide Explanation' : 'View Explanation',
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (_showExplanation) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(explanationText,
                        style: hi ? devanagariStyle : const TextStyle(fontSize: 13, height: 1.5)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
