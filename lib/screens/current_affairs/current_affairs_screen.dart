import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CurrentAffairsScreen extends StatefulWidget {
  const CurrentAffairsScreen({super.key});

  @override
  State<CurrentAffairsScreen> createState() => _CurrentAffairsScreenState();
}

class _CurrentAffairsScreenState extends State<CurrentAffairsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  final _categories = ['All', 'National', 'International', 'Economy', 'Sports', 'Science'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Affairs'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Category filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_categories[i]),
                  selected: _selectedCategory == _categories[i],
                  onSelected: (_) =>
                      setState(() => _selectedCategory = _categories[i]),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _selectedCategory == _categories[i]
                        ? Colors.white
                        : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ArticleList(period: 'Daily', category: _selectedCategory),
                _ArticleList(period: 'Weekly', category: _selectedCategory),
                _ArticleList(period: 'Monthly', category: _selectedCategory),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  final String period;
  final String category;
  const _ArticleList({required this.period, required this.category});

  List<_Article> get _articles => [
    const _Article(
      title: 'India ranks 44th in Global Innovation Index 2025',
      category: 'National',
      date: '23 Feb 2026',
      summary: 'India has climbed 6 positions in the Global Innovation Index 2025, securing the 44th rank among 132 economies. The report highlights India\'s strength in IT services and scientific publications.',
      isImportant: true,
    ),
    const _Article(
      title: 'RBI keeps repo rate unchanged at 6.5%',
      category: 'Economy',
      date: '22 Feb 2026',
      summary: 'The Reserve Bank of India\'s Monetary Policy Committee voted to keep the benchmark repo rate unchanged at 6.5%, maintaining its stance of withdrawal of accommodation.',
      isImportant: true,
    ),
    const _Article(
      title: 'India wins 5 gold medals at Commonwealth Games',
      category: 'Sports',
      date: '21 Feb 2026',
      summary: 'Indian athletes delivered a stellar performance at the Commonwealth Games 2026, bagging 5 gold, 7 silver and 4 bronze medals on the third day of competition.',
      isImportant: false,
    ),
    const _Article(
      title: 'ISRO successfully launches NISAR satellite',
      category: 'Science',
      date: '20 Feb 2026',
      summary: 'ISRO and NASA jointly launched the NISAR (NASA-ISRO Synthetic Aperture Radar) satellite, which will monitor Earth\'s ecosystems, ice masses, and natural hazards.',
      isImportant: true,
    ),
    const _Article(
      title: 'UN Security Council passes resolution on climate',
      category: 'International',
      date: '19 Feb 2026',
      summary: 'The United Nations Security Council passed a landmark resolution recognizing climate change as a threat to international peace and security, with 12 votes in favour.',
      isImportant: false,
    ),
    const _Article(
      title: 'PM Modi inaugurates 500 km new highway stretch',
      category: 'National',
      date: '18 Feb 2026',
      summary: 'Prime Minister Modi inaugurated a 500-km four-lane national highway connecting three major cities, boosting connectivity and reducing travel time by 40%.',
      isImportant: false,
    ),
    const _Article(
      title: 'India\'s GDP grows at 7.2% in Q3 FY2025-26',
      category: 'Economy',
      date: '17 Feb 2026',
      summary: 'India\'s GDP growth accelerated to 7.2% in the third quarter of FY2025-26, driven by robust manufacturing activity and strong services exports.',
      isImportant: true,
    ),
  ].where((a) => category == 'All' || a.category == category).toList();

  @override
  Widget build(BuildContext context) {
    if (_articles.isEmpty) {
      return const Center(
        child: Text('No articles in this category',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _articles.length,
      itemBuilder: (_, i) => _ArticleCard(article: _articles[i]),
    );
  }
}

class _Article {
  final String title;
  final String category;
  final String date;
  final String summary;
  final bool isImportant;

  const _Article({
    required this.title,
    required this.category,
    required this.date,
    required this.summary,
    required this.isImportant,
  });
}

class _ArticleCard extends StatefulWidget {
  final _Article article;
  const _ArticleCard({required this.article});

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool _expanded = false;
  bool _bookmarked = false;

  Color get _categoryColor {
    switch (widget.article.category) {
      case 'National': return AppColors.sscColor;
      case 'International': return AppColors.upscColor;
      case 'Economy': return AppColors.bankingColor;
      case 'Sports': return AppColors.railwayColor;
      case 'Science': return AppColors.pscColor;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(widget.article.category,
                          style: TextStyle(
                              fontSize: 11,
                              color: _categoryColor,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    if (widget.article.isImportant)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Important',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.error,
                                fontWeight: FontWeight.w600)),
                      ),
                    const Spacer(),
                    Text(widget.article.date,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.article.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.4)),
                if (_expanded) ...[
                  const SizedBox(height: 8),
                  Text(widget.article.summary,
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.5)),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? 'Show Less' : 'Read More',
                      style: const TextStyle(fontSize: 13)),
                ),
              ),
              IconButton(
                icon: Icon(
                  _bookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  color: _bookmarked ? AppColors.accent : AppColors.textHint,
                  size: 20,
                ),
                onPressed: () => setState(() => _bookmarked = !_bookmarked),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
