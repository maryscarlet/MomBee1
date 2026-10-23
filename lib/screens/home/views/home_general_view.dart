import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/daily_message_card.dart';
import '../widgets/home_greeting_header.dart';
import '../../tracker/period_tracker_screen.dart';
import '../../tracker/pregnancy_tracker_screen.dart';
import '../../tracker/baby_development_screen.dart';
import '../../tracker/vaccination_screen.dart';

class HomeGeneralView extends StatelessWidget {
  final Function(int)? onNavigateTab;
  const HomeGeneralView({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Time-based dynamic greeting & Bangla date
          const HomeGreetingHeader(emoji: '✨'),

          // 2. ONE COMPACT JOURNEY PROGRESS CARD (General Summary)
          Container(
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
              boxShadow: AppShadows.naturalBloom,
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            padding: const EdgeInsets.all(18.0),
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const Text(
                        'সাধারণ স্বাস্থ্য ও যত্ন',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'সুস্থ মা, সুন্দর ভবিষ্যৎ',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'নারী ও শিশুর স্বাস্থ্য, পুষ্টি, প্রজনন সুস্থতা ও প্যারেন্টিং গাইডলাইনে মমবি রয়েছে আপনার সাথে।',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 12.5,
                    color: AppColors.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. ONE CONCISE DEVELOPMENTAL / HEALTH INFORMATION SECTION
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
                    color: const Color(0xFF0288D1).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFF0288D1),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'দৈনিক স্বাস্থ্য শিক্ষা ও পুষ্টি',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'প্রতিদিনের সঠিক হাইড্রেশন এবং সময়মতো টিকার শিডিউল বজায় রাখা অত্যন্ত গুরুত্বপূর্ণ।',
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
                  onPressed: () => onNavigateTab?.call(2), // Learn tab
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
                        'আর্টিকেল',
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
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.subtleCard,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
