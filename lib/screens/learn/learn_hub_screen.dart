import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/article.dart';
import '../../widgets/article_widgets.dart';
import '../../services/app_localization.dart';

class LearnHubScreen extends StatefulWidget {
  const LearnHubScreen({super.key});

  @override
  State<LearnHubScreen> createState() => _LearnHubScreenState();
}

class _LearnHubScreenState extends State<LearnHubScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'গর্ভাবস্থা',
      'icon': Icons.pregnant_woman_rounded,
      'bg': AppColors.primaryFixed,
      'color': AppColors.primary,
    },
    {
      'title': 'শিশুর যত্ন',
      'icon': Icons.child_care_rounded,
      'bg': AppColors.secondaryFixed,
      'color': AppColors.secondary,
    },
    {
      'title': 'মায়ের যত্ন',
      'icon': Icons.spa_rounded,
      'bg': AppColors.tertiaryFixed,
      'color': AppColors.tertiary,
    },
    {
      'title': 'বাবার ভূমিকা',
      'icon': Icons.family_restroom_rounded,
      'bg': AppColors.primaryFixed,
      'color': AppColors.primary,
    },
    {
      'title': 'পুষ্টি',
      'icon': Icons.restaurant_rounded,
      'bg': AppColors.secondaryFixed,
      'color': AppColors.secondary,
    },
    {
      'title': 'টিকা',
      'icon': Icons.vaccines_rounded,
      'bg': AppColors.tertiaryFixed,
      'color': AppColors.tertiary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredArticles = allMomBeeArticles.where((article) {
      final matchesSearch = _searchQuery.isEmpty ||
          article.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article.summary.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null ||
          article.category.toLowerCase().contains(_selectedCategory!.toLowerCase()) ||
          (_selectedCategory == 'গর্ভাবস্থা' && article.journeyTag == 'pregnant') ||
          (_selectedCategory == 'শিশুর যত্ন' && article.journeyTag == 'baby') ||
          (_selectedCategory == 'মায়ের যত্ন' &&
              (article.journeyTag == 'general' || article.journeyTag == 'planning')) ||
          (_selectedCategory == 'বাবার ভূমিকা' &&
              (article.category.contains('বাবা') || article.title.contains('বাবা'))) ||
          (_selectedCategory == 'পুষ্টি' &&
              (article.category.contains('পুষ্টি') ||
                  article.title.contains('পুষ্টি') ||
                  article.title.contains('খাবার') ||
                  article.title.contains('ডায়েট'))) ||
          (_selectedCategory == 'টিকা' &&
              (article.category.contains('টিকা') ||
                  article.title.contains('টিকা') ||
                  article.paragraphs.any((p) => p.contains('টিকা'))));
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalization.isEnglish ? 'Learning Hub' : 'জ্ঞান ভাণ্ডার',
          style: const TextStyle(
            fontFamily: 'Noto Sans Bengali',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Search Input Bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.subtleCard,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 14,
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'MomBee-তে কী জানতে চান?',
                hintStyle: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 14,
                  color: AppColors.outline.withValues(alpha: 0.8),
                ),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.outline),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Categories Grid Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ক্যাটাগরি',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
              ),
              if (_selectedCategory != null)
                TextButton(
                  onPressed: () => setState(() => _selectedCategory = null),
                  child: const Text('রিসেট',
                      style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          color: AppColors.primary)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat['title'];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_selectedCategory == cat['title']) {
                        _selectedCategory = null;
                      } else {
                        _selectedCategory = cat['title'] as String;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryFixed.withValues(alpha: 0.5)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                      boxShadow: AppShadows.subtleCard,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cat['bg'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: cat['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['title'] as String,
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),

          // Featured Articles ("বিশেষ প্রবন্ধ")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'বিশেষ প্রবন্ধ',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
              ),
              Text(
                '${filteredArticles.length} টি প্রবন্ধ',
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (filteredArticles.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded,
                      size: 48, color: AppColors.outline),
                  const SizedBox(height: 8),
                  const Text(
                    'কোনো প্রবন্ধ খুঁজে পাওয়া যায়নি',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return ArticleCard(
                  article: article,
                  onTap: () => showMomBeeArticleDetails(context, article),
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}
}
