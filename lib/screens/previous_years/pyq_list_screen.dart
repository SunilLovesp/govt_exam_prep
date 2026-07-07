import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../services/pyq_service.dart';

class PYQListScreen extends StatefulWidget {
  const PYQListScreen({super.key});

  @override
  State<PYQListScreen> createState() => _PYQListScreenState();
}

class _PYQListScreenState extends State<PYQListScreen> {
  List<PYQPaper> _papers = [];
  bool _loading = true;
  String? _error;
  String _selectedExam = 'All';

  static const _examFilters = [
    'All',
    'SSC CGL',
    'SSC CHSL',
    'SSC MTS',
    'UPSC CSE',
    'UPSC NDA',
    'IBPS PO',
    'SBI PO',
    'RRB NTPC',
    'RRB Group D',
    'UPPSC PCS',
    'CTET',
  ];

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  Future<void> _loadPapers() async {
    setState(() { _loading = true; _error = null; });
    try {
      final papers = await PYQService().fetchPapers();
      setState(() { _papers = papers; _loading = false; });
    } catch (e) {
      setState(() { _error = 'Could not load papers. Make sure the backend is running.'; _loading = false; });
    }
  }

  List<PYQPaper> get _filtered {
    if (_selectedExam == 'All') return _papers;
    return _papers.where((p) => p.examName == _selectedExam).toList();
  }

  /// Group papers by examName → year (desc)
  Map<String, Map<int, List<PYQPaper>>> get _grouped {
    final result = <String, Map<int, List<PYQPaper>>>{};
    for (final p in _filtered) {
      result.putIfAbsent(p.examName, () => {});
      result[p.examName]!.putIfAbsent(p.year, () => []);
      result[p.examName]![p.year]!.add(p);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Previous Year Papers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Column(
        children: [
          // Exam filter chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _examFilters.length,
              itemBuilder: (_, i) {
                final exam = _examFilters[i];
                final selected = _selectedExam == exam;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(exam),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedExam = exam),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Body
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _ErrorView(message: _error!, onRetry: _loadPapers)
                    : _filtered.isEmpty
                        ? const _EmptyView()
                        : _PapersList(grouped: _grouped),
          ),
        ],
      ),
    );
  }
}

class _PapersList extends StatelessWidget {
  final Map<String, Map<int, List<PYQPaper>>> grouped;
  const _PapersList({required this.grouped});

  @override
  Widget build(BuildContext context) {
    final exams = grouped.keys.toList()..sort();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (_, ei) {
        final examName = exams[ei];
        final years = grouped[examName]!.keys.toList()..sort((a, b) => b.compareTo(a));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exam header
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 4),
              child: Text(
                examName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Years
            ...years.map((year) {
              final papers = grouped[examName]![year]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$year',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...papers.map((paper) => _PaperCard(paper: paper)),
                  const SizedBox(height: 8),
                ],
              );
            }),
            const Divider(),
          ],
        );
      },
    );
  }
}

class _PaperCard extends StatelessWidget {
  final PYQPaper paper;
  const _PaperCard({required this.paper});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(
        '/home/pyq/viewer',
        extra: {'paper': paper},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paper.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    paper.fileSizeLabel,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_rounded, size: 64, color: AppColors.textHint),
          SizedBox(height: 12),
          Text('No papers uploaded yet.',
              style: TextStyle(color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text('Upload papers from the admin panel.',
              style: TextStyle(color: AppColors.textHint, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 64, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
