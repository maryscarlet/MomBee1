import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/period_data.dart';
import '../../models/pregnancy_data.dart';
import '../../state/app_state.dart';
import '../../services/app_localization.dart';

class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  DateTime _displayedMonth = DateTime.now();

  void _showEditCycleDialog() {
    final periodData = AppState.instance.periodData;
    DateTime selectedLmp = periodData.lastPeriodDate;
    int cycleLen = periodData.cycleLength;
    int duration = periodData.periodDuration;

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
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
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
                'মাসিক চক্রের তথ্য পরিবর্তন করুন',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Last Period Date
              const Text(
                'সর্বশেষ পিরিয়ডের শুরুর দিন',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedLmp,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 120)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setModalState(() => selectedLmp = picked);
                  }
                },
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.borderCard),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${toBanglaDigits(selectedLmp.day)}/${toBanglaDigits(selectedLmp.month)}/${toBanglaDigits(selectedLmp.year)}',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'পরিবর্তন',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Cycle Length (21 to 45 days)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'গড় সাইকেল দৈর্ঘ্য (Cycle Length)',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${toBanglaDigits(cycleLen)} দিন',
                    style: const TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: cycleLen.toDouble(),
                min: 21,
                max: 45,
                divisions: 24,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  setModalState(() => cycleLen = v.round());
                },
              ),
              const SizedBox(height: 10),

              // 3. Period Duration (3 to 10 days)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'পিরিয়ডের স্থায়িত্ব (Period Duration)',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${toBanglaDigits(duration)} দিন',
                    style: const TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: duration.toDouble(),
                min: 3,
                max: 10,
                divisions: 7,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  setModalState(() => duration = v.round());
                },
              ),
              const SizedBox(height: 20),

              // Save Button
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
                    final cleanLmp = DateTime(selectedLmp.year, selectedLmp.month, selectedLmp.day);
                    await AppState.instance.updatePeriodDetails(
                      lastPeriodDate: cleanLmp,
                      cycleLength: cycleLen,
                      periodDuration: duration,
                    );
                    if (mounted) {
                      setState(() {
                        _displayedMonth = DateTime(cleanLmp.year, cleanLmp.month, 1);
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'সংরক্ষণ করুন',
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
    ),
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final periodData = AppState.instance.periodData;

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
              'পিরিয়ড ট্র্যাকার',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                tooltip: 'সাইকেল সেটিংস',
                onPressed: _showEditCycleDialog,
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // 1. CYCLE HERO BANNER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      const Color(0xFFFFF6D6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.subtleCard,
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: (periodData.currentCycleDay /
                                    periodData.cycleLength)
                                .clamp(0.0, 1.0),
                            strokeWidth: 8,
                            backgroundColor: Colors.white,
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.primary),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              toBanglaDigits(periodData.currentCycleDay),
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                height: 1.0,
                              ),
                            ),
                            const Text(
                              'তম দিন',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'সাইকেল: ${toBanglaDigits(periodData.cycleLength)} দিন',
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans Bengali',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: _showEditCycleDialog,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppColors.primary.withValues(alpha: 0.3)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.edit_rounded,
                                          size: 11, color: AppColors.primary),
                                      SizedBox(width: 3),
                                      Text(
                                        'এডিট',
                                        style: TextStyle(
                                          fontFamily: 'Noto Sans Bengali',
                                          fontSize: 10,
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
                          const SizedBox(height: 6),
                          Text(
                            periodData.isFertileDay(DateTime.now())
                                ? (AppLocalization.isEnglish
                                    ? 'Fertile Window (High Conception Chance)'
                                    : 'গর্ভধারণের সম্ভাবনাময় উর্বর সময় (Fertile Window)')
                                : (AppLocalization.isEnglish
                                    ? 'Next Expected Period'
                                    : 'পরবর্তী পিরিয়ডের সম্ভাব্য তারিখ'),
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${toBanglaDigits(periodData.upcomingNextPeriod.day)}/${toBanglaDigits(periodData.upcomingNextPeriod.month)}/${toBanglaDigits(periodData.upcomingNextPeriod.year)}',
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. STATS 3-COLUMN BENTO
              Row(
                children: [
                  _buildStatCard(
                    title: AppLocalization.isEnglish
                        ? 'Ovulation (Est.)'
                        : 'ওভুলেশন (আনুমানিক)',
                    value:
                        '${toBanglaDigits(periodData.upcomingOvulationDate.day)}/${toBanglaDigits(periodData.upcomingOvulationDate.month)}',
                    subtitle: AppLocalization.isEnglish
                        ? 'Peak Fertility'
                        : 'সর্বাধিক উর্বর দিন',
                    color: const Color(0xFF745B00),
                    bgColor: const Color(0xFFFFF6D6),
                    icon: Icons.star_rounded,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    title: AppLocalization.isEnglish
                        ? 'Fertile (Est.)'
                        : 'উর্বর সময় (আনুমানিক)',
                    value: periodData.upcomingFertileWindowStart.month ==
                            periodData.upcomingFertileWindowEnd.month
                        ? '${toBanglaDigits(periodData.upcomingFertileWindowStart.day)} - ${toBanglaDigits(periodData.upcomingFertileWindowEnd.day)}'
                        : '${toBanglaDigits(periodData.upcomingFertileWindowStart.day)}/${toBanglaDigits(periodData.upcomingFertileWindowStart.month)} - ${toBanglaDigits(periodData.upcomingFertileWindowEnd.day)}/${toBanglaDigits(periodData.upcomingFertileWindowEnd.month)}',
                    subtitle: AppLocalization.isEnglish
                        ? 'Conception Window'
                        : 'গর্ভধারণ উইন্ডো',
                    color: const Color(0xFF7B1FA2),
                    bgColor: const Color(0xFFF3E5F5),
                    icon: Icons.favorite_rounded,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    title: AppLocalization.isEnglish ? 'Duration' : 'স্থায়িত্ব',
                    value:
                        '${toBanglaDigits(periodData.periodDuration)} ${AppLocalization.days}',
                    subtitle: AppLocalization.isEnglish
                        ? 'Bleeding Days'
                        : 'রক্তস্রাবের সময়',
                    color: AppColors.primary,
                    bgColor: AppColors.primary.withValues(alpha: 0.1),
                    icon: Icons.water_drop_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. INTERACTIVE CALENDAR
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.subtleCard,
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: Column(
                  children: [
                    // Month Selector Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: const Icon(Icons.chevron_left_rounded),
                          onPressed: () {
                            setState(() {
                              _displayedMonth = DateTime(
                                _displayedMonth.year,
                                _displayedMonth.month - 1,
                              );
                            });
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${_getMonthNameBangla(_displayedMonth.month)} ${toBanglaDigits(_displayedMonth.year)}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          icon: const Icon(Icons.chevron_right_rounded),
                          onPressed: () {
                            setState(() {
                              _displayedMonth = DateTime(
                                _displayedMonth.year,
                                _displayedMonth.month + 1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Day of Week Headers
                    const Row(
                      children: [
                        Expanded(child: Center(child: _WeekDayHeader('রবি'))),
                        Expanded(child: Center(child: _WeekDayHeader('সোম'))),
                        Expanded(child: Center(child: _WeekDayHeader('মঙ্গল'))),
                        Expanded(child: Center(child: _WeekDayHeader('বুধ'))),
                        Expanded(child: Center(child: _WeekDayHeader('বৃহঃ'))),
                        Expanded(child: Center(child: _WeekDayHeader('শুক্র'))),
                        Expanded(child: Center(child: _WeekDayHeader('শনি'))),
                      ],
                    ),
                    const Divider(height: 16),

                    // Calendar Grid Days
                    _buildCalendarGrid(periodData),

                    const Divider(height: 20),
                    // Legend
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildLegendItem(
                            AppColors.primary,
                            AppLocalization.isEnglish
                                ? 'Period'
                                : 'পিরিয়ডের দিন'),
                        _buildLegendItem(
                            const Color(0xFFBA68C8),
                            AppLocalization.isEnglish
                                ? 'Fertile Window'
                                : 'উর্বর উইন্ডো'),
                        _buildLegendItem(
                            const Color(0xFFFECB17),
                            AppLocalization.isEnglish
                                ? 'Ovulation Day'
                                : 'ওভুলেশন ডে'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. LOG / RECORD TODAY CTA
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                onPressed: () async {
                  await AppState.instance.togglePeriodDay(DateTime.now());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalization.isEnglish
                              ? "Today's period status updated!"
                              : 'আজকের দিনের পিরিয়ড স্ট্যাটাস আপডেট হয়েছে!',
                          style: const TextStyle(fontFamily: 'Noto Sans Bengali'),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.water_drop_rounded, size: 20),
                label: Text(
                  periodData.isPeriodDay(DateTime.now())
                      ? (AppLocalization.isEnglish
                          ? 'Mark Today Period Ended'
                          : 'আজকের পিরিয়ড সমাপ্ত চিহ্নিত করুন')
                      : (AppLocalization.isEnglish
                          ? 'Mark Period Started Today'
                          : 'আজকে পিরিয়ড শুরু হয়েছে চিহ্নিত করুন'),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. IMPORTANT MEDICAL UX DISCLAIMER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.outline, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppLocalization.isEnglish
                            ? 'Medical Disclaimer: Period dates, ovulation, and fertile window predictions are scientific estimates based on standard menstrual cycle calculations. Actual cycle timing may vary based on individual bodily conditions, physical and mental stress, hormonal fluctuations, medication, or cycle irregularity. This information should not be used as a definitive contraceptive method or as a substitute for professional medical advice. For family planning or health concerns, please consult a qualified healthcare specialist.'
                            : 'মেডিকেল সতর্কবার্তা: পিরিয়ডের সম্ভাব্য তারিখ, ওভুলেশন এবং উর্বর সময় (ফার্টিল উইন্ডো)-এর সকল তথ্য চিকিৎসাবিজ্ঞানভিত্তিক আনুমানিক হিসাব। শারীরিক অবস্থা, মানসিক চাপ, হরমোনের তারতম্য, দৈনন্দিন জীবনযাত্রা বা অসুস্থতার কারণে প্রতিটি নারীর মাসিক চক্র ব্যক্তিভেদে পরিবর্তিত হতে পারে। এই হিসাবকে কোনো সুনির্দিষ্ট গর্ভনিরোধক পদ্ধতি (জন্মনিয়ন্ত্রণ) বা চূড়ান্ত চিকিৎসা পরামর্শের বিকল্প হিসেবে ব্যবহার করবেন না। পরিবার পরিকল্পনা বা যেকোনো স্বাস্থ্য সমস্যার ক্ষেত্রে অবশ্যই বিশেষজ্ঞ চিকিৎসকের পরামর্শ নিন।',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                maxLines: 1,
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(PeriodData periodData) {
    final year = _displayedMonth.year;
    final month = _displayedMonth.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstDayWeekday = DateTime(year, month, 1).weekday % 7; // 0 for Sunday

    final List<Widget> dayWidgets = [];

    // Empty lead slots
    for (int i = 0; i < firstDayWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 38, height: 38));
    }

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      final isPeriod = periodData.isPeriodDay(date);
      final isOvulation = periodData.isOvulationDay(date);
      final isFertile = periodData.isFertileDay(date);
      final isToday = DateUtils.isSameDay(date, DateTime.now());

      Color? bg;
      Color textColor = AppColors.onSurface;
      BoxBorder? border;

      if (isPeriod) {
        bg = AppColors.primary;
        textColor = Colors.white;
      } else if (isOvulation) {
        bg = const Color(0xFFFECB17);
        textColor = const Color(0xFF745B00);
      } else if (isFertile) {
        bg = const Color(0xFFE1BEE7);
        textColor = const Color(0xFF4A148C);
      }

      if (isToday && !isPeriod) {
        border = Border.all(color: AppColors.primary, width: 2);
      }

      dayWidgets.add(
        InkWell(
          onTap: () => AppState.instance.togglePeriodDay(date),
          borderRadius: BorderRadius.circular(19),
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: border,
            ),
            child: Text(
              toBanglaDigits(d),
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 13,
                fontWeight: (isPeriod || isOvulation || isToday)
                    ? FontWeight.w800
                    : FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 6,
      crossAxisSpacing: 4,
      children: dayWidgets,
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Noto Sans Bengali',
            fontSize: 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getMonthNameBangla(int month) {
    const months = [
      '',
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];
    return months[month];
  }
}

class _WeekDayHeader extends StatelessWidget {
  final String label;
  const _WeekDayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Noto Sans Bengali',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.outline,
      ),
    );
  }
}
