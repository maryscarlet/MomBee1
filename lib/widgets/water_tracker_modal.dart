import 'package:flutter/material.dart';
import '../models/pregnancy_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'hydration_silhouette_painter.dart';

/// Modal bottom sheet for interactive, animated daily water hydration tracking.
class WaterTrackerModal extends StatelessWidget {
  const WaterTrackerModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const WaterTrackerModal(),
    );
  }

  void _showConfigDialog(BuildContext context) {
    int tempGlass = AppState.instance.glassSizeMl;
    int tempTarget = AppState.instance.dailyWaterTargetMl;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          title: const Row(
            children: [
              Icon(Icons.tune_rounded, color: Color(0xFF0288D1), size: 22),
              SizedBox(width: 8),
              Text(
                'পানি পানের সেটিংস',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'গ্লাসের মাপ নির্বাচন করুন:',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [150, 200, 250, 300, 350].map((size) {
                    final isSel = tempGlass == size;
                    return ChoiceChip(
                      label: Text('${toBanglaDigits(size)} মিলি'),
                      selected: isSel,
                      selectedColor:
                          const Color(0xFF0288D1).withValues(alpha: 0.18),
                      onSelected: (val) {
                        if (val) setDialogState(() => tempGlass = size);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                const Text(
                  'দৈনিক লক্ষ্যমাত্রা:',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [1500, 2000, 2500, 3000].map((target) {
                    final isSel = tempTarget == target;
                    final litre = (target / 1000.0).toStringAsFixed(1);
                    return ChoiceChip(
                      label: Text(
                          '${toBanglaDigits(target)} মিলি ($litre লিটার)'),
                      selected: isSel,
                      selectedColor:
                          const Color(0xFF0288D1).withValues(alpha: 0.18),
                      onSelected: (val) {
                        if (val) setDialogState(() => tempTarget = target);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0288D1),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await AppState.instance.setWaterConfig(
                  glassSizeMl: tempGlass,
                  dailyTargetMl: tempTarget,
                );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text(
          'আজকের হিসাব রিসেট করবেন?',
          style: TextStyle(
            fontFamily: 'Noto Sans Bengali',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'আজকের গ্রহণ করা পানির সমস্ত গ্লাস সংখ্যা ০ হয়ে যাবে।',
          style: TextStyle(
            fontFamily: 'Noto Sans Bengali',
            fontSize: 13.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('না'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await AppState.instance.resetTodayWater();
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('হ্যাঁ, রিসেট করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final waterGlasses = state.waterGlasses;
        final percent = state.waterProgress;
        final isReached = state.isWaterTargetReached;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDim,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF29B6F6).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: Color(0xFF0288D1),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'পানি পানের ট্র্যাকার',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'সুস্থ মাতৃত্বে পর্যাপ্ত পানিশূন্যতা রোধ',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'সেটিংস',
                        icon: const Icon(Icons.settings_outlined, size: 20),
                        onPressed: () => _showConfigDialog(context),
                      ),
                      IconButton(
                        tooltip: 'বন্ধ করুন',
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Celebration state banner if target reached
                  if (isReached) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE1F5FE), Color(0xFFE8F5E9)],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: const Color(0xFF81C784)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.celebration_rounded,
                              color: Color(0xFF2E7D32), size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'অভিনন্দন! আজকের পানি পানের দৈনিক লক্ষ্যমাত্রা পূর্ণ হয়েছে 🎉',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Animated Body Silhouette Metaphor
                  Center(
                    child: Column(
                      children: [
                        HydrationSilhouetteWidget(
                          progress: percent,
                          isGoalReached: isReached,
                          width: 140,
                          height: 200,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'প্রতীকী চিত্র: জলযোজন ট্র্যাকিংয়ের শৈল্পিক রূপক',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 10.5,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Intake Metrics Dual Display (mL and Litres)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: const Color(0xFF0288D1).withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'আজকের মোট গ্রহণ',
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 4,
                                    children: [
                                      Text(
                                        toBanglaDigits(state.totalWaterMl),
                                        style: const TextStyle(
                                          fontFamily: 'Noto Sans Bengali',
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0288D1),
                                        ),
                                      ),
                                      const Text(
                                        'মি.লি.',
                                        style: TextStyle(
                                          fontFamily: 'Noto Sans Bengali',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        '(${(state.totalWaterLitres).toStringAsFixed(2)} লিটার)',
                                        style: const TextStyle(
                                          fontFamily: 'Noto Sans Bengali',
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0288D1)
                                    .withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                              ),
                              child: Text(
                                '${toBanglaDigits((percent * 100).toInt())}% পূরণ',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0288D1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF0288D1)),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 4,
                          children: [
                            Text(
                              '${toBanglaDigits(waterGlasses)} / ${toBanglaDigits(state.dailyWaterGoal)} গ্লাস (${toBanglaDigits(state.glassSizeMl)} মিলি)',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'লক্ষ্য: ${toBanglaDigits(state.dailyWaterTargetMl)} মিলি (${state.waterTargetLitres.toStringAsFixed(1)}L)',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons: Primary Add (+1) & Secondary Undo (-1) / Reset
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        foregroundColor: Colors.white,
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      onPressed: () => state.addWaterGlass(),
                      icon: const Icon(Icons.add_circle_outline_rounded,
                          size: 22),
                      label: Text(
                        '+১ গ্লাস (${toBanglaDigits(state.glassSizeMl)} মিলি) যোগ করুন',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onSurface,
                            side: const BorderSide(
                                color: AppColors.outlineVariant),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: waterGlasses > 0
                              ? () => state.removeWaterGlass()
                              : null,
                          icon: const Icon(Icons.remove_circle_outline_rounded,
                              size: 18),
                          label: const Text(
                            '-১ গ্লাস মুছুন',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: waterGlasses > 0
                              ? () => _confirmReset(context)
                              : null,
                          icon: const Icon(Icons.restart_alt_rounded, size: 18),
                          label: const Text(
                            'আজকের রিসেট',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
