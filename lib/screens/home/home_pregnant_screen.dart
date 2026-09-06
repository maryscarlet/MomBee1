import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/article.dart';
import '../../models/journey_type.dart';
import '../../models/pregnancy_data.dart';
import '../../data/pregnancy_weeks_data.dart';
import '../../state/app_state.dart';
import '../../widgets/daily_message_card.dart';
import '../../widgets/article_widgets.dart';
import '../pregnancy/pregnancy_week_guide_screen.dart';
import '../tracker/period_tracker_screen.dart';
import '../tracker/pregnancy_tracker_screen.dart';
import '../tracker/baby_development_screen.dart';
import '../tracker/vaccination_screen.dart';

class HomePregnantScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;
  const HomePregnantScreen({super.key, this.onNavigateTab});

  @override
  State<HomePregnantScreen> createState() => _HomePregnantScreenState();
}

class _HomePregnantScreenState extends State<HomePregnantScreen> {
  void _openWeekGuide([int? week]) {
    final targetWeek = week ?? AppState.instance.currentPregnancyWeek;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PregnancyWeekGuideScreen(initialWeek: targetWeek),
      ),
    );
  }

  void _showSetupModal({bool isEditing = false}) {
    final existingLmp = AppState.instance.pregnancyData.lmpDate;
    DateTime selectedDate = existingLmp ??
        DateTime.now().subtract(const Duration(days: 168));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final diffDays = DateTime.now().difference(selectedDate).inDays;
          final calcWeek = diffDays >= 0
              ? ((diffDays / 7).floor() + 1).clamp(1, 40)
              : 1;
          final calcEdd = selectedDate.add(const Duration(days: 280));

          return Container(
            padding: EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  isEditing
                      ? 'গর্ভাবস্থার তথ্য পরিবর্তন করুন'
                      : 'আপনার Pregnancy Journey সেটআপ করুন',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'আপনার শেষ মাসিকের ১ম দিন (LMP) নির্বাচন করুন যাতে আমরা সঠিক গর্ভকালীন সপ্তাহ, ট্রাইমেস্টার ও শিশুর বিকাশ গণনা করতে পারি।',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 280)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded,
                            color: AppColors.primary, size: 22),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'শেষ মাসিকের ১ম দিন (LMP)',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${toBanglaDigits(selectedDate.day)}/${toBanglaDigits(selectedDate.month)}/${toBanglaDigits(selectedDate.year)}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'তারিখ পরিবর্তন',
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Live calculation preview box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6D6),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                        color: const Color(0xFFFECB17).withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insights_rounded,
                          color: Color(0xFF745B00), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'হিসাব অনুযায়ী: ${toBanglaDigits(calcWeek)}তম সপ্তাহ চলছে • সম্ভাব্য প্রসব: ${toBanglaDigits(calcEdd.day)}/${toBanglaDigits(calcEdd.month)}/${toBanglaDigits(calcEdd.year)}',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF584400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    onPressed: () async {
                      await AppState.instance
                          .updatePregnancyWithLMP(selectedDate);
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'গর্ভাবস্থার তথ্য সফলভাবে আপডেট করা হয়েছে!',
                              style: TextStyle(fontFamily: 'Noto Sans Bengali'),
                            ),
                            backgroundColor: AppColors.primary,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text(
                      isEditing ? 'তথ্য আপডেট করুন' : 'সেটআপ সম্পন্ন করুন',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isSetup = AppState.instance.pregnancyData.isSetup;
        final currentWeek = AppState.instance.currentPregnancyWeek;
        final currentDay = AppState.instance.currentPregnancyDay;
        final trimester = AppState.instance.currentTrimester;
        final progress = AppState.instance.pregnancyProgress;

        final weekInfo = allPregnancyWeeks.firstWhere(
          (w) => w.weekNumber == currentWeek,
          orElse: () => allPregnancyWeeks.first,
        );

        String trimesterLabel = '১ম ট্রাইমেস্টার';
        if (trimester == 2) trimesterLabel = '২য় ট্রাইমেস্টার';
        if (trimester == 3) trimesterLabel = '৩য় ট্রাইমেস্টার';

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Row(
                children: [
                  Text(
                    'সুপ্রভাত',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(width: 6),
                  const Text('💛', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'কেমন অনুভব করছেন আজ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),

              // Dynamic Daily Message
              const DailyMessageCard(),

              // ---------------- MAIN PREGNANCY PROGRESS CARD ----------------
              if (!isSetup)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.subtleCard,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.pregnant_woman_rounded,
                          size: 48, color: AppColors.primary),
                      const SizedBox(height: 10),
                      const Text(
                        'আপনার Pregnancy Journey সেটআপ করুন',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'শেষ মাসিকের তারিখ দিয়ে আপনার গর্ভকালীন সপ্তাহ ও শিশুর বৃদ্ধির ধাপগুলো জানুন।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _showSetupModal(),
                          child: const Text(
                            'সেটআপ শুরু করুন',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.naturalBloom,
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryContainer
                                          .withValues(alpha: 0.2),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.full),
                                    ),
                                    child: Text(
                                      trimesterLabel,
                                      style: const TextStyle(
                                        fontFamily: 'Noto Sans Bengali',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.full),
                                    onTap: () =>
                                        _showSetupModal(isEditing: true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.full),
                                        border: Border.all(
                                            color: AppColors.primary
                                                .withValues(alpha: 0.2)),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.edit_calendar_rounded,
                                              size: 12,
                                              color: AppColors.primary),
                                          SizedBox(width: 4),
                                          Text(
                                            'এডিট করুন',
                                            style: TextStyle(
                                              fontFamily: 'Noto Sans Bengali',
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans Bengali',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                  children: [
                                    const TextSpan(text: 'আপনি এখন '),
                                    TextSpan(
                                      text:
                                          '${toBanglaDigits(currentWeek)} সপ্তাহে',
                                      style: const TextStyle(
                                          color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${toBanglaDigits(currentDay)} দিন চলছে • ${weekInfo.babySizeComparison}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),

                          // Baby size icon badge
                          GestureDetector(
                            onTap: () => _openWeekGuide(currentWeek),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF6D6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.child_care_rounded,
                                    color: Color(0xFF745B00),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Progress Bar
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            child: Container(
                              height: 8,
                              width: double.infinity,
                              color: AppColors.surfaceVariant,
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.full),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '১ম সপ্তাহ',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'সম্ভাব্য প্রসব: ${toBanglaDigits(AppState.instance.estimatedDueDate.day)}/${toBanglaDigits(AppState.instance.estimatedDueDate.month)}/${toBanglaDigits(AppState.instance.estimatedDueDate.year)}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Text(
                                '৪০তম সপ্তাহ',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action CTA: Opens EXACT current week guide!
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () => _openWeekGuide(currentWeek),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          child: Text(
                            '${toBanglaDigits(currentWeek)}তম সপ্তাহ সম্পর্কে জানুন',
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // ---------------- QUICK ACTIONS 4-ITEM GRID ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickActionButton(
                    icon: Icons.water_drop_rounded,
                    label: 'পিরিয়ড\nট্র্যাকার',
                    iconColor: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PeriodTrackerScreen()),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.pregnant_woman_rounded,
                    label: 'প্রেগন্যান্সি\nট্র্যাকার',
                    iconColor: AppColors.primary,
                    isActive: true,
                    hasActiveDot: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PregnancyTrackerScreen()),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.child_care_rounded,
                    label: 'শিশুর\nবিকাশ',
                    iconColor: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BabyDevelopmentScreen()),
                      );
                    },
                  ),
                  _buildQuickActionButton(
                    icon: Icons.vaccines_rounded,
                    label: 'টিকা ও\nইপিআই',
                    iconColor: AppColors.tertiary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VaccinationScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Today's Tip ("আজকের MomBee")
              Text(
                'আজকের MomBee',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.onSurface,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6D6),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.subtleCard,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wb_sunny_rounded,
                        color: Color(0xFF745B00),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${toBanglaDigits(currentWeek)}তম সপ্তাহের বিশেষ টিপস',
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            weekInfo.healthAndCare,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 13,
                              height: 1.4,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // For You Articles Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'আপনার জন্য',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.onSurface,
                        ),
                  ),
                  TextButton(
                    onPressed: () =>
                        widget.onNavigateTab?.call(2), // Navigate to Learn Hub
                    child: const Text(
                      'সব দেখুন',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ...getArticlesForJourney(JourneyType.pregnant,
                      pregnancyWeek: currentWeek)
                  .take(2)
                  .map(
                    (art) => ArticleCard(
                      article: art,
                      onTap: () => showMomBeeArticleDetails(context, art),
                    ),
                  ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
    bool isActive = false,
    bool hasActiveDot = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                    boxShadow: AppShadows.subtleCard,
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                if (hasActiveDot)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.onSurface,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
