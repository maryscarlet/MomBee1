import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/pregnancy_data.dart';
import '../../../state/app_state.dart';
import '../../../services/bangla_date_helper.dart';
import '../../../widgets/daily_message_card.dart';
import '../widgets/home_greeting_header.dart';
import '../../tracker/period_tracker_screen.dart';
import '../../tracker/pregnancy_tracker_screen.dart';
import '../../tracker/baby_development_screen.dart';
import '../../tracker/vaccination_screen.dart';

class HomePlanningView extends StatelessWidget {
  final Function(int)? onNavigateTab;
  const HomePlanningView({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final periodData = AppState.instance.periodData;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1 & 2. Dynamic time-based greeting & Bangla date
              const HomeGreetingHeader(emoji: '🌱'),

              // 1. HERO PRE-PREGNANCY PREPARATION CARD
              if (!periodData.isSetup)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFECB17),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: const Text(
                              'গর্ভধারণের প্রস্তুতি',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF584400),
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'আজকের প্রস্তুতি ও উর্বর সময়',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'আপনার সর্বশেষ পিরিয়ডের শুরুর দিন ও গড় সাইকেল দৈর্ঘ্য দিয়ে ওভুলেশন ও গর্ভধারণের সেরা দিনগুলো জানুন।',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PeriodTrackerScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.calendar_month_rounded,
                              size: 18),
                          label: const Text(
                            'পিরিয়ড ও সাইকেল সেটআপ করুন',
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
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFF6D6),
                      AppColors.primary.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.naturalBloom,
                  border: Border.all(
                      color: const Color(0xFFFECB17).withValues(alpha: 0.4)),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFECB17),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.full),
                              ),
                              child: const Text(
                                'গর্ভধারণের প্রস্তুতি',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF584400),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PeriodTrackerScreen()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.full),
                                  border: Border.all(
                                      color: const Color(0xFFFECB17)),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit_calendar_rounded,
                                        size: 12, color: Color(0xFF584400)),
                                    SizedBox(width: 4),
                                    Text(
                                      'এডিট করুন',
                                      style: TextStyle(
                                        fontFamily: 'Noto Sans Bengali',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF584400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.primary,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'আজকের প্রস্তুতি ও উর্বর সময়',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'বর্তমান সাইকেল: ${toBanglaDigits(periodData.currentCycleDay)} তম দিন',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'পরবর্তী পিরিয়ড: ${toBanglaDigits(periodData.upcomingNextPeriod.day)}/${toBanglaDigits(periodData.upcomingNextPeriod.month)}/${toBanglaDigits(periodData.upcomingNextPeriod.year)}  •  সম্ভাব্য ওভুলেশন: ${toBanglaDigits(periodData.upcomingOvulationDate.day)}/${toBanglaDigits(periodData.upcomingOvulationDate.month)}',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 12.5,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'উর্বর সময়: ${toBanglaDigits(periodData.upcomingFertileWindowStart.day)} - ${toBanglaDigits(periodData.upcomingFertileWindowEnd.day)} ${BanglaDateHelper.bengaliMonths[periodData.upcomingFertileWindowEnd.month - 1]} (আনুমানিক হিসাব)',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 11.5,
                        color: AppColors.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. ONE CONCISE DEVELOPMENTAL / PREPARATION SECTION
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: AppShadows.subtleCard,
                  border: Border.all(color: AppColors.borderCard),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFECB17).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_rounded,
                        color: Color(0xFF745B00),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'গর্ভধারণের প্রস্তুতি পরামর্শ',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'প্রতিদিন ফলিক এসিড গ্রহণ ও সাইকেলের উর্বর দিনগুলোতে সক্রিয় থাকা গর্ভধারণের সম্ভাবনা বাড়ায়।',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 12,
                              height: 1.35,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PeriodTrackerScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.08),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ট্র্যাকার',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. DAILY MESSAGE SECTION (Card title: “আজকে আপনার জন্য বার্তা”)
              const DailyMessageCard(),
              const SizedBox(height: 16),

              // 5. COMPACT TRACKER SECTION (Quick Actions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(
                    icon: Icons.water_drop_rounded,
                    label: 'পিরিয়ড\nট্র্যাকার',
                    color: AppColors.primary,
                    isActive: true,
                    hasActiveDot: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PeriodTrackerScreen()),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.pregnant_woman_rounded,
                    label: 'প্রেগন্যান্সি\nট্র্যাকার',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PregnancyTrackerScreen()),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.child_care_rounded,
                    label: 'শিশুর\nবিকাশ',
                    color: AppColors.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BabyDevelopmentScreen()),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.vaccines_rounded,
                    label: 'টিকা ও\nইপিআই',
                    color: AppColors.tertiary,
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
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
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
                        ? color.withValues(alpha: 0.15)
                        : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: isActive
                        ? Border.all(color: color, width: 1.5)
                        : null,
                    boxShadow: AppShadows.subtleCard,
                  ),
                  child: Icon(icon, color: color, size: 26),
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
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                color: isActive ? color : AppColors.onSurface,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
