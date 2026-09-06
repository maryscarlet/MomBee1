import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/pregnancy_data.dart';
import '../../state/app_state.dart';
import '../pregnancy/pregnancy_week_guide_screen.dart';

class PregnancyTrackerScreen extends StatefulWidget {
  const PregnancyTrackerScreen({super.key});

  @override
  State<PregnancyTrackerScreen> createState() => _PregnancyTrackerScreenState();
}

class _PregnancyTrackerScreenState extends State<PregnancyTrackerScreen> {
  DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
    if (value.isBefore(min)) return min;
    if (value.isAfter(max)) return max;
    return value;
  }

  void _showSetupPregnancyDialog() {
    DateTime selectedDate = AppState.instance.pregnancyData.lmpDate ??
        DateTime.now().subtract(const Duration(days: 168));
    bool isLmpMode = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
              const Text(
                'প্রেগন্যান্সি ট্র্যাকার সেটআপ',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Toggle LMP vs EDD
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(
                        child: Text(
                          'শেষ মাসিকের দিন (LMP)',
                          style: TextStyle(fontFamily: 'Noto Sans Bengali'),
                        ),
                      ),
                      selected: isLmpMode,
                      onSelected: (val) {
                        setModalState(() {
                          isLmpMode = true;
                          selectedDate = DateTime.now()
                              .subtract(const Duration(days: 168));
                        });
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isLmpMode ? Colors.white : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(
                        child: Text(
                          'সম্ভাব্য প্রসব তারিখ (EDD)',
                          style: TextStyle(fontFamily: 'Noto Sans Bengali'),
                        ),
                      ),
                      selected: !isLmpMode,
                      onSelected: (val) {
                        setModalState(() {
                          isLmpMode = false;
                          selectedDate =
                              DateTime.now().add(const Duration(days: 112));
                        });
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: !isLmpMode ? Colors.white : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              Text(
                isLmpMode
                    ? 'আপনার শেষ মাসিকের ১ম দিন নির্বাচন করুন:'
                    : 'ডাক্তারের দেওয়া সম্ভাব্য প্রসবের তারিখ নির্বাচন করুন:',
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: () async {
                  final initial = isLmpMode
                      ? _clampDate(
                          selectedDate,
                          DateTime.now().subtract(const Duration(days: 280)),
                          DateTime.now(),
                        )
                      : _clampDate(
                          selectedDate,
                          DateTime.now(),
                          DateTime.now().add(const Duration(days: 280)),
                        );

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initial,
                    firstDate: isLmpMode
                        ? DateTime.now().subtract(const Duration(days: 280))
                        : DateTime.now(),
                    lastDate: isLmpMode
                        ? DateTime.now()
                        : DateTime.now().add(const Duration(days: 280)),
                  );
                  if (picked != null) {
                    setModalState(() => selectedDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_note_rounded,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 12),
                      Text(
                        '${toBanglaDigits(selectedDate.day)}/${toBanglaDigits(selectedDate.month)}/${toBanglaDigits(selectedDate.year)}',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'তারিখ বাছুন',
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
              const SizedBox(height: 24),

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
                    if (isLmpMode) {
                      await AppState.instance
                          .updatePregnancyWithLMP(selectedDate);
                    } else {
                      await AppState.instance
                          .updatePregnancyWithEDD(selectedDate);
                    }
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text(
                    'হিসাব আপডেট করুন',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentWeek = AppState.instance.currentPregnancyWeek;
        final currentDay = AppState.instance.currentPregnancyDay;
        final trimester = AppState.instance.currentTrimester;
        final progress = AppState.instance.pregnancyProgress;
        final edd = AppState.instance.estimatedDueDate;
        final remaining = AppState.instance.remainingDays;

        String trimesterStr = '১ম ট্রাইমেস্টার';
        if (trimester == 2) trimesterStr = '২য় ট্রাইমেস্টার';
        if (trimester == 3) trimesterStr = '৩য় ট্রাইমেস্টার';

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceContainerLowest,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'প্রেগন্যান্সি ট্র্যাকার',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_calendar_rounded,
                    color: AppColors.primary),
                tooltip: 'তারিখ পরিবর্তন',
                onPressed: _showSetupPregnancyDialog,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // 1. HERO PREGNANCY CARD
              Container(
                padding: const EdgeInsets.all(20),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryFixed,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            trimesterStr,
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF745B00),
                            ),
                          ),
                        ),
                        Text(
                          'বাকি ${toBanglaDigits(remaining)} দিন',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                        children: [
                          const TextSpan(text: 'আপনি এখন '),
                          TextSpan(
                            text: '${toBanglaDigits(currentWeek)} সপ্তাহ',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(
                            text: ' ${toBanglaDigits(currentDay)} দিনে',
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      child: Container(
                        height: 10,
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
                          '${toBanglaDigits((progress * 100).round())}% সম্পন্ন',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
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
                    const SizedBox(height: 18),

                    // Open 40-Week Guide Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PregnancyWeekGuideScreen(
                                initialWeek: currentWeek,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_stories_rounded, size: 20),
                        label: Text(
                          '${toBanglaDigits(currentWeek)}তম সপ্তাহের পূর্ণ গাইড দেখুন',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. IMPORTANT DETAILS BENTO
              Row(
                children: [
                  Expanded(
                    child: _buildBentoCard(
                      icon: Icons.cake_rounded,
                      title: 'সম্ভাব্য প্রসবের তারিখ',
                      value:
                          '${toBanglaDigits(edd.day)}/${toBanglaDigits(edd.month)}/${toBanglaDigits(edd.year)}',
                      color: AppColors.primary,
                      bgColor: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBentoCard(
                      icon: Icons.calendar_today_rounded,
                      title: 'অতিক্রান্ত সময়',
                      value: '${toBanglaDigits(currentWeek * 7)} দিন',
                      color: const Color(0xFF745B00),
                      bgColor: const Color(0xFFFFF6D6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. ALL WEEKS BROWSER CTA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timeline_rounded,
                        color: AppColors.secondary, size: 36),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '১ থেকে ৪০ সপ্তাহের টাইমলাইন',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'প্রতিটি সপ্তাহের বিস্তারিত শিশুর ও মায়ের পরিবর্তন দেখুন।',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded,
                          size: 16, color: AppColors.primary),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PregnancyWeekGuideScreen(
                              initialWeek: currentWeek,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Noto Sans Bengali',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Noto Sans Bengali',
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
