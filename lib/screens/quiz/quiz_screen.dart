import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/exam.dart';
import '../../models/question.dart';
import '../../providers/quiz_provider.dart';

// ─── Palette status colours ───────────────────────────────────────────────────
const _kNotVisited   = Color(0xFFBDBDBD); // grey   — not yet visited
const _kAnswered     = Color(0xFF2E7D32); // green  — answered
const _kMarked       = Color(0xFFF57F17); // orange — marked for review
const _kAnsweredMark = Color(0xFF6A1B9A); // purple — answered + marked

class QuizScreen extends StatefulWidget {
  final String testId;
  const QuizScreen({super.key, required this.testId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _showHindi   = false;
  bool _paletteOpen = true;
  final ScrollController _paletteScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTest());
  }

  @override
  void dispose() {
    _paletteScroll.dispose();
    super.dispose();
  }

  void _loadTest() {
    TestSeries? found;
    String title = 'Practice Test';
    for (final cat in examCategories) {
      for (final exam in cat.exams) {
        for (final ts in exam.testSeries) {
          if (ts.id == widget.testId) { found = ts; title = ts.title; break; }
        }
      }
    }
    context.read<QuizProvider>().loadTest(
      testId: widget.testId,
      testTitle: title,
      durationMinutes: found?.durationMinutes ?? 60,
      questionLimit: found?.totalQuestions ?? 200,
    );
  }

  void _scrollPaletteToIndex(int index) {
    const itemW = 40.0; // cell width + gap
    final offset = index * itemW;
    if (_paletteScroll.hasClients) {
      _paletteScroll.animateTo(
        offset.clamp(0.0, _paletteScroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _submitTest() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Submit Test?'),
        content: const Text(
            'Are you sure you want to submit? You cannot change answers after submission.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final result = context.read<QuizProvider>().submitTest();
              context.go('/home/result', extra: result);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Color _statusColor(Question q) {
    if (q.isAnswered && q.isMarkedForReview) return _kAnsweredMark;
    if (q.isAnswered)        return _kAnswered;
    if (q.isMarkedForReview) return _kMarked;
    return _kNotVisited;
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();

    if (quiz.state == QuizState.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (quiz.state == QuizState.completed) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (quiz.state == QuizState.error) {
      return Scaffold(
        appBar: AppBar(title: Text(quiz.testTitle, style: const TextStyle(fontSize: 15))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 56, color: _kNotVisited),
                const SizedBox(height: 16),
                const Text(
                  'Could not load questions',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  quiz.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.read<QuizProvider>().retry(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = quiz.currentQuestion;
    if (q == null) return const SizedBox();

    // Auto-scroll palette to keep current question visible
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollPaletteToIndex(quiz.currentIndex),
    );

    final showHindi    = _showHindi && q.hasHindi;
    final questionText = showHindi ? q.questionHi : q.question;
    final optionsList  = (showHindi && q.optionsHi.length == 4) ? q.optionsHi : q.options;

    final answered = quiz.questions.where((x) => x.isAnswered && !x.isMarkedForReview).length;
    final marked   = quiz.questions.where((x) => x.isMarkedForReview && !x.isAnswered).length;
    final both     = quiz.questions.where((x) => x.isAnswered && x.isMarkedForReview).length;
    final notDone  = quiz.questions.where((x) => !x.isAnswered).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.testTitle, style: const TextStyle(fontSize: 15)),
        actions: [
          if (q.hasHindi)
            GestureDetector(
              onTap: () => setState(() => _showHindi = !_showHindi),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
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
                      fontFamily: _showHindi ? 'NotoSansDevanagari' : null,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: _TimerWidget(
                timeStr: quiz.timerFormatted,
                isCritical: quiz.isTimerCritical,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [

          // ── Progress bar ──────────────────────────────────────────────────
          LinearProgressIndicator(
            value: (quiz.currentIndex + 1) / quiz.questions.length,
            backgroundColor: AppColors.divider,
            color: AppColors.primary,
            minHeight: 4,
          ),

          // ── Question palette panel ────────────────────────────────────────
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Summary strip + collapse toggle
                InkWell(
                  onTap: () => setState(() => _paletteOpen = !_paletteOpen),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                    child: Row(
                      children: [
                        _SummaryChip(color: _kAnswered,     count: answered, label: 'Done'),
                        const SizedBox(width: 8),
                        _SummaryChip(color: _kMarked,       count: marked,   label: 'Marked'),
                        const SizedBox(width: 8),
                        _SummaryChip(color: _kAnsweredMark, count: both,     label: 'Ans+Mark'),
                        const SizedBox(width: 8),
                        _SummaryChip(color: _kNotVisited,   count: notDone,  label: 'Pending'),
                        const Spacer(),
                        Icon(
                          _paletteOpen
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),

                // Numbered grid (collapsible)
                if (_paletteOpen) ...[
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      controller: _paletteScroll,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 2, 12, 6),
                      itemCount: quiz.questions.length,
                      itemBuilder: (_, i) {
                        final qItem     = quiz.questions[i];
                        final isCurrent = i == quiz.currentIndex;
                        final bg        = _statusColor(qItem);

                        return GestureDetector(
                          onTap: () => quiz.goToQuestion(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 34,
                            height: 34,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: isCurrent ? Colors.white : bg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isCurrent ? AppColors.primary : bg.withOpacity(0.8),
                                width: isCurrent ? 2.5 : 1,
                              ),
                              boxShadow: isCurrent
                                  ? [BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 6)]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? AppColors.primary : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Colour legend
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 2, 12, 8),
                    child: Wrap(
                      spacing: 14,
                      children: [
                        _LegendItem(color: _kAnswered,     label: 'Answered'),
                        _LegendItem(color: _kMarked,       label: 'Marked'),
                        _LegendItem(color: _kAnsweredMark, label: 'Ans+Mark'),
                        _LegendItem(color: _kNotVisited,   label: 'Pending'),
                      ],
                    ),
                  ),
                ],

                const Divider(height: 1, thickness: 1),
              ],
            ),
          ),

          // ── Question counter + mark for review ────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Q ${quiz.currentIndex + 1} / ${quiz.questions.length}',
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                TextButton.icon(
                  onPressed: quiz.toggleMarkForReview,
                  icon: Icon(
                    q.isMarkedForReview
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    size: 18,
                    color: q.isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
                  ),
                  label: Text(
                    q.isMarkedForReview ? 'Marked' : 'Mark',
                    style: TextStyle(
                      color: q.isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Question + Options ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(q.subject,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(width: 8),
                            _DifficultyBadge(difficulty: q.difficulty),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          questionText,
                          style: showHindi
                              ? GoogleFonts.notoSansDevanagari(
                                  fontSize: 16,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500)
                              : const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Options
                  ...List.generate(optionsList.length, (i) {
                    final isSelected = q.selectedIndex == i;
                    return _OptionTile(
                      index: i,
                      text: optionsList[i],
                      isSelected: isSelected,
                      isHindi: showHindi,
                      onTap: () => quiz.selectAnswer(i),
                    );
                  }),

                  const SizedBox(height: 12),
                  if (q.isAnswered)
                    Center(
                      child: TextButton(
                        onPressed: quiz.clearAnswer,
                        child: const Text('Clear Response',
                            style: TextStyle(color: AppColors.error)),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Bottom navigation ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: quiz.currentIndex > 0 ? quiz.prevQuestion : null,
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 12),
                if (quiz.currentIndex < quiz.questions.length - 1)
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: quiz.nextQuestion,
                      child: const Text('Next'),
                    ),
                  )
                else
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitTest,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success),
                      child: const Text('Submit Test'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Summary chip ─────────────────────────────────────────────────────────────
class _SummaryChip extends StatelessWidget {
  final Color  color;
  final int    count;
  final String label;
  const _SummaryChip(
      {required this.color, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text('$count',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(width: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Legend item ──────────────────────────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final Color  color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Timer widget ─────────────────────────────────────────────────────────────
class _TimerWidget extends StatelessWidget {
  final String timeStr;
  final bool   isCritical;
  const _TimerWidget({required this.timeStr, required this.isCritical});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCritical
            ? AppColors.errorLight
            : AppColors.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined,
              size: 16,
              color: isCritical ? AppColors.error : Colors.white),
          const SizedBox(width: 4),
          Text(timeStr,
              style: TextStyle(
                color: isCritical ? AppColors.error : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

// ─── Difficulty badge ─────────────────────────────────────────────────────────
class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = difficulty == 'easy'
        ? AppColors.success
        : difficulty == 'hard'
            ? AppColors.error
            : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        difficulty[0].toUpperCase() + difficulty.substring(1),
        style:
            TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ─── Option tile ──────────────────────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final int      index;
  final String   text;
  final bool     isSelected;
  final bool     isHindi;
  final VoidCallback onTap;

  const _OptionTile({
    required this.index,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.isHindi = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = String.fromCharCode(65 + index);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE3F2FD)
              : const Color(0xFFE3F2FD).withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF42A5F5) : const Color(0xFF90CAF9),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF42A5F5) : const Color(0xFF90CAF9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: isHindi
                    ? GoogleFonts.notoSansDevanagari(
                        fontSize: 14, height: 1.5)
                    : const TextStyle(fontSize: 14, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
