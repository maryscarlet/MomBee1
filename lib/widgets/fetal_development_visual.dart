import 'package:flutter/material.dart';
import '../models/fetal_stage_visual_data.dart';
import '../models/pregnancy_week.dart';
import '../data/pregnancy_weeks_data.dart';
import '../models/pregnancy_data.dart';
import '../theme/app_theme.dart';

/// Text-first Baby Development Card presenting medically verified
/// weekly fetal size comparisons, measurements, and milestones.
/// Completely free of AI-generated or generic fetal avatars.
class FetalDevelopmentVisual extends StatelessWidget {
  final int weekNumber;
  final bool isCompact;
  final VoidCallback? onTap;
  final bool showDisclaimer;
  final bool showMilestones;

  const FetalDevelopmentVisual({
    super.key,
    required this.weekNumber,
    this.isCompact = false,
    this.onTap,
    this.showDisclaimer = true,
    this.showMilestones = true,
  });

  @override
  Widget build(BuildContext context) {
    final clampedWeek = weekNumber.clamp(1, 40);
    final stageData = FetalStageVisualData.forWeek(clampedWeek);
    final weekData = allPregnancyWeeks.firstWhere(
      (w) => w.weekNumber == clampedWeek,
      orElse: () => allPregnancyWeeks.first,
    );

    if (isCompact) {
      return _buildCompactView(context, stageData, weekData);
    }

    return _buildFullCard(context, stageData, weekData);
  }

  Widget _buildCompactView(
    BuildContext context,
    FetalStageVisualData stageData,
    PregnancyWeek weekData,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: stageData.accentColor.withValues(alpha: 0.25),
          ),
          boxShadow: AppShadows.subtleCard,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: stageData.backgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: stageData.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.spa_rounded,
                  color: stageData.accentColor,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: stageData.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'স্টেজ ${toBanglaDigits(stageData.stageNumber)}: ${stageData.stageBadgeBangla}',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: stageData.accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'শিশুর আকার: ${weekData.babySizeComparison}',
                    style: const TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'দৈর্ঘ্য: প্রায় ${weekData.babyLength} • ওজন: প্রায় ${weekData.babyWeight}',
                    style: const TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: stageData.accentColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCard(
    BuildContext context,
    FetalStageVisualData stageData,
    PregnancyWeek weekData,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: stageData.accentColor.withValues(alpha: 0.22),
          width: 1.2,
        ),
        boxShadow: AppShadows.subtleCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: stageData.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg - 1.2),
                topRight: Radius.circular(AppRadius.lg - 1.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: stageData.accentColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'সপ্তাহ ${weekData.weekNumberBangla}',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: stageData.accentColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        weekData.trimesterBangla,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: stageData.accentColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: stageData.accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'স্টেজ ${toBanglaDigits(stageData.stageNumber)}',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: stageData.accentColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: stageData.accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        stageData.stageBadgeBangla,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: stageData.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stageData.stageTitleBangla,
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: stageData.accentColor,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fruit / Object Comparison Hero
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: stageData.accentColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: stageData.accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.eco_rounded,
                            color: stageData.accentColor,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'শিশুর আকারের তুলনা',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11.5,
                                color: AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'আপনার বাবু এখন প্রায় ${weekData.babySizeComparison}-এর সমান',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Length & Weight Bento Cards (with explicit "আনুমানিক" indicators)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.straighten_rounded,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'দৈর্ঘ্য (আনুমানিক)',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'প্রায় ${weekData.babyLength}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: AppColors.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.scale_rounded,
                                  size: 15,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'ওজন (আনুমানিক)',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'প্রায় ${weekData.babyWeight}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Weekly Development Highlights
                const SizedBox(height: 14),
                const Text(
                  'এই সপ্তাহের প্রধান বিকাশ',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  weekData.babyDevelopment,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                // Milestones of Current Gestational Stage
                if (showMilestones && stageData.milestonesBangla.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: stageData.accentColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'এই ধাপে শিশুর সক্ষমতা ও পরিবর্তন',
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: stageData.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: stageData.milestonesBangla.map((m) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6, right: 8),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: stageData.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                m,
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Action Link (if onTap provided)
                if (onTap != null) ...[
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'সপ্তাহ ভিত্তিক পূর্ণ গাইড দেখুন',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: stageData.accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: stageData.accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Approximate Medical Disclaimer
                if (showDisclaimer) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color:
                              AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'চিত্রটি আনুমানিক ভ্রূণের বৃদ্ধির চিত্ররূপ এবং এটি সরাসরি আল্ট্রাসনোগ্রাফি বা নির্ভুল ডায়াগনস্টিক স্ক্যান নয়।',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 10.5,
                                  height: 1.4,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'প্রতিটি শিশুর বৃদ্ধির হার স্বতন্ত্র। উল্লেখিত দৈর্ঘ্য ও ওজন চিকিৎসাগত সাধারণ গড়ের ভিত্তিতে আনুমানিক।',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 10,
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
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Type alias for semantic clarity
typedef BabyDevelopmentCard = FetalDevelopmentVisual;
