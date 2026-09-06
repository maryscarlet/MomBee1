import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/pregnancy_data.dart';
import '../../data/pregnancy_weeks_data.dart';
import '../../state/app_state.dart';
import '../../models/article.dart';
import '../../widgets/article_widgets.dart';

class PregnancyWeekGuideScreen extends StatefulWidget {
  final int initialWeek;
  const PregnancyWeekGuideScreen({super.key, this.initialWeek = 24});

  @override
  State<PregnancyWeekGuideScreen> createState() =>
      _PregnancyWeekGuideScreenState();
}

class _PregnancyWeekGuideScreenState extends State<PregnancyWeekGuideScreen> {
  late int _selectedWeek;
  late final ScrollController _timelineScrollController;
  final Set<String> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    _selectedWeek = widget.initialWeek.clamp(1, 40);
    _timelineScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedWeek();
    });
  }

  @override
  void dispose() {
    _timelineScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedWeek() {
    if (_timelineScrollController.hasClients) {
      final targetOffset = (_selectedWeek - 1) * 64.0;
      _timelineScrollController.animateTo(
        targetOffset.clamp(
            0.0, _timelineScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onSelectWeek(int week) {
    setState(() {
      _selectedWeek = week.clamp(1, 40);
    });
    _scrollToSelectedWeek();
  }

  void _showArticleDetails(Article article) {
    showMomBeeArticleDetails(context, article);
  }

  @override
  Widget build(BuildContext context) {
    final currentWeekData = allPregnancyWeeks.firstWhere(
      (w) => w.weekNumber == _selectedWeek,
      orElse: () => allPregnancyWeeks.first,
    );

    final userCurrentWeek = AppState.instance.currentPregnancyWeek;
    final isCurrentActualWeek = _selectedWeek == userCurrentWeek;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${toBanglaDigits(_selectedWeek)}তম সপ্তাহ',
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              currentWeekData.trimesterBangla,
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          if (!isCurrentActualWeek)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: ActionChip(
                backgroundColor: AppColors.secondaryFixed,
                side: BorderSide.none,
                label: Text(
                  'বর্তমান সপ্তাহ (${toBanglaDigits(userCurrentWeek)})',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF745B00),
                  ),
                ),
                onPressed: () => _onSelectWeek(userCurrentWeek),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // ---------------- HORIZONTAL WEEK SELECTOR (1 to 40) ----------------
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              controller: _timelineScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 40,
              itemBuilder: (context, index) {
                final weekNum = index + 1;
                final isSelected = weekNum == _selectedWeek;
                final isActualCurrent = weekNum == userCurrentWeek;

                return GestureDetector(
                  onTap: () => _onSelectWeek(weekNum),
                  child: Container(
                    width: 54,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isActualCurrent
                              ? AppColors.secondaryFixed
                              : AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : isActualCurrent
                              ? Border.all(
                                  color: const Color(0xFF745B00), width: 1)
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          toBanglaDigits(weekNum),
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            color: isSelected
                                ? AppColors.onPrimary
                                : isActualCurrent
                                    ? const Color(0xFF745B00)
                                    : AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'সপ্তাহ',
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 10,
                            height: 1.1,
                            color: isSelected
                                ? AppColors.onPrimary.withValues(alpha: 0.85)
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ---------------- MAIN CONTENT AREA ----------------
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! < -250 && _selectedWeek < 40) {
                    _onSelectWeek(_selectedWeek + 1);
                  } else if (details.primaryVelocity! > 250 &&
                      _selectedWeek > 1) {
                    _onSelectWeek(_selectedWeek - 1);
                  }
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: ListView(
                  key: ValueKey<int>(_selectedWeek),
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // 1. BABY SIZE & HERO MILESTONE
                    Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.subtleCard,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryFixed,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.child_care_rounded,
                          color: Color(0xFF745B00),
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                currentWeekData.trimesterBangla,
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'শিশুর আকার: ${currentWeekData.babySizeComparison}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'দৈর্ঘ্য: ${currentWeekData.babyLength} • ওজন: ${currentWeekData.babyWeight}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 2. BABY'S DEVELOPMENT (শিশুর বিকাশ)
                _buildSectionCard(
                  icon: Icons.auto_awesome_rounded,
                  iconColor: const Color(0xFF8DA358),
                  title: 'শিশুর বিকাশ',
                  content: currentWeekData.babyDevelopment,
                ),
                const SizedBox(height: 14),

                // 3. MOTHER'S BODY CHANGES (মায়ের পরিবর্তন)
                _buildSectionCard(
                  icon: Icons.pregnant_woman_rounded,
                  iconColor: AppColors.primary,
                  title: 'মায়ের শারীরিক পরিবর্তন ও অনুভূতি',
                  content: currentWeekData.motherChanges,
                ),
                const SizedBox(height: 14),

                // 4. NUTRITION (পুষ্টি)
                _buildSectionCard(
                  icon: Icons.restaurant_rounded,
                  iconColor: const Color(0xFFE65100),
                  title: 'পুষ্টি ও খাদ্যতালিকা',
                  content: currentWeekData.nutrition,
                ),
                const SizedBox(height: 14),

                // 5. HEALTH & CARE (স্বাস্থ্য ও যত্ন)
                _buildSectionCard(
                  icon: Icons.favorite_rounded,
                  iconColor: const Color(0xFFD81B60),
                  title: 'স্বাস্থ্য ও আত্ম-যত্ন',
                  content: currentWeekData.healthAndCare,
                ),
                const SizedBox(height: 14),

                // 6. WEEKLY TO-DOS & CHECKLIST (এই সপ্তাহের করণীয়)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.subtleCard,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.checklist_rounded,
                              color: AppColors.secondary, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'এই সপ্তাহের করণীয় ও চেকলিস্ট',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...currentWeekData.weeklyTodos.map((todo) {
                        final key = 'w${_selectedWeek}_todo_$todo';
                        final isDone = _checkedItems.contains(key);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isDone) {
                                  _checkedItems.remove(key);
                                } else {
                                  _checkedItems.add(key);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  isDone
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  color: isDone
                                      ? const Color(0xFF2E7D32)
                                      : AppColors.outline,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    todo,
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 13,
                                      height: 1.4,
                                      decoration: isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: isDone
                                          ? AppColors.outline
                                          : AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 7. CRITICAL WARNING SIGNS (গুরুত্বপূর্ণ লক্ষণ)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: AppColors.error, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'কখন জরুরি ডাক্তারের পরামর্শ নেবেন',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ...currentWeekData.warningSigns.map(
                        (sign) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ',
                                  style: TextStyle(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(
                                  sign,
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans Bengali',
                                    fontSize: 13,
                                    height: 1.4,
                                    color: Color(0xFF7A1C20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 8. RELATED MOM BEE CONTENT
                Text(
                  'সপ্তাহ $_selectedWeek-এর বিশেষজ্ঞ পরামর্শ ও গাইড',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                ...getArticlesForPregnancyWeek(_selectedWeek).map(
                      (art) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _showArticleDetails(art),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLowest,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                                border: Border.all(color: AppColors.borderCard),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.sm),
                                    child: Image.network(
                                      art.imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 60,
                                        height: 60,
                                        color: AppColors.surfaceContainerHigh,
                                        child: const Icon(Icons.article_rounded,
                                            size: 20, color: AppColors.outline),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          art.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Noto Sans Bengali',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                art.author,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'Noto Sans Bengali',
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              art.readTime,
                                              style: const TextStyle(
                                                fontFamily: 'Noto Sans Bengali',
                                                fontSize: 11,
                                                color: AppColors.outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: AppColors.outline),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                // 9. WEEK 40 COMPLETION STATE IF WEEK 40
                if (_selectedWeek == 40) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6D6),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadows.subtleCard,
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.celebration_rounded,
                            size: 48, color: Color(0xFF745B00)),
                        const SizedBox(height: 8),
                        const Text(
                          'অভিনন্দন! আপনার গর্ভকালীন যাত্রা পূর্ণ হয়েছে',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF745B00),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'আপনার এবং আপনার অনাগত শিশুর জন্য শুভকামনা। ডেলিভারির পর MomBee-এর বেবি কেয়ার ট্র্যাকার সক্রিয় করুন।',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),

          // ---------------- BOTTOM PREVIOUS / NEXT NAVIGATION BAR ----------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: const Border(
                top: BorderSide(color: AppColors.borderCard, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Week Button
                OutlinedButton.icon(
                  onPressed: _selectedWeek > 1
                      ? () => _onSelectWeek(_selectedWeek - 1)
                      : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                  label: const Text(
                    'পূর্ববর্তী সপ্তাহ',
                    style: TextStyle(fontFamily: 'Noto Sans Bengali'),
                  ),
                ),

                // Next Week Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _selectedWeek < 40
                      ? () => _onSelectWeek(_selectedWeek + 1)
                      : null,
                  label: const Text(
                    'পরবর্তী সপ্তাহ',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.subtleCard,
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'Noto Sans Bengali',
              fontSize: 13.5,
              height: 1.6,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
