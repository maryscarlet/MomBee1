import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/article.dart';
import '../../../models/journey_type.dart';
import '../../../models/pregnancy_data.dart';
import '../../../state/app_state.dart';
import '../../../widgets/daily_message_card.dart';
import '../../../widgets/article_widgets.dart';
import '../../tracker/period_tracker_screen.dart';
import '../../tracker/appointments_screen.dart';

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
              // Greeting Section
              Row(
                children: [
                  Text(
                    AppState.instance.userName.isNotEmpty
                        ? 'সুপ্রভাত, ${AppState.instance.userName}'
                        : 'সুপ্রভাত',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(width: 6),
                  const Text('🌱', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'একটি সুস্থ সন্তানের জন্য সঠিক প্রস্তুতি নিন',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),

              // Dynamic Daily Message
              const DailyMessageCard(),

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
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'বর্তমান সাইকেল দিন ${toBanglaDigits(periodData.currentCycleDay)} • পরবর্তী ওভুলেশন: ${toBanglaDigits(periodData.estimatedOvulationDate.day)}/${toBanglaDigits(periodData.estimatedOvulationDate.month)}',
                      style: const TextStyle(
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PeriodTrackerScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_month_rounded, size: 18),
                        label: const Text(
                          'Cycle & Ovulation ট্র্যাকার খুলুন',
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. PRE-CONCEPTION 4 QUICK ACTION CHIPS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(
                    icon: Icons.calendar_today_rounded,
                    label: 'ওভুলেশন\nট্র্যাকার',
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
                    icon: Icons.medication_rounded,
                    label: 'ফলিক\nএসিড',
                    color: const Color(0xFF0288D1),
                    onTap: () => onNavigateTab?.call(2), // Learn Hub
                  ),
                  _buildQuickAction(
                    icon: Icons.restaurant_rounded,
                    label: 'পুষ্টিকর\nডায়েট',
                    color: const Color(0xFF2E7D32),
                    onTap: () => onNavigateTab?.call(2),
                  ),
                  _buildQuickAction(
                    icon: Icons.event_available_rounded,
                    label: 'ডাক্তারের\nপরামর্শ',
                    color: const Color(0xFF745B00),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppointmentsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 3. ESSENTIAL PREPARATION GUIDELINES
              const Text(
                'গর্ভধারণের প্রস্তুতি চেকলিস্ট',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              _buildGuidelineCard(
                icon: Icons.woman_rounded,
                iconColor: AppColors.primary,
                title: 'মায়ের প্রস্তুতি',
                description:
                    'গর্ভধারণের অন্তত ৩ মাস আগে থেকে প্রতিদিন ৪০০ মাইক্রোগ্রাম ফলিক এসিড শুরু করুন। রুবেলা ও হেপাটাইটিস-বি এর অ্যান্টিবডি টেস্ট করান।',
              ),
              const SizedBox(height: 10),

              _buildGuidelineCard(
                icon: Icons.man_rounded,
                iconColor: const Color(0xFF0288D1),
                title: 'বাবার ভূমিকা ও প্রস্তুতি',
                description:
                    'সুস্থ শুক্রাণু তৈরিতে ধূমপান, অ্যালকোহল ও অতিরিক্ত ক্যাফেইন বর্জন করুন। জিংক ও অ্যান্টিঅক্সিডেন্ট সমৃদ্ধ খাবার গ্রহণ করুন।',
              ),
              const SizedBox(height: 10),

              _buildGuidelineCard(
                icon: Icons.self_improvement_rounded,
                iconColor: const Color(0xFF7B1FA2),
                title: 'মানসিক প্রশান্তি ও জীবনযাপন',
                description:
                    'মানসিক চাপ কমান। প্রতিদিন অন্তত ৩০ মিনিট হাঁটাহাঁটি করুন এবং ওজন নিয়ন্ত্রণে রাখার চেষ্টা করুন।',
              ),
              const SizedBox(height: 28),

              // 4. TODAY'S TIP ("আজকের MomBee")
              const Text(
                'আজকের MomBee প্রস্তুতি টিপস',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
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
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_rounded,
                        color: Color(0xFF745B00), size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ওভুলেশন উইন্ডো চিহ্নিত করুন',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF745B00),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'মাসিক চক্রের মধ্যবর্তী উর্বর দিনগুলোতে (Fertile Window) সহবাস গর্ভধারণের সম্ভাবনা বহুগুণ বাড়িয়ে দেয়।',
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
                ),
              ),
              const SizedBox(height: 28),

              // 5. PRE-CONCEPTION ARTICLES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'প্রস্তুতির জন্য বিশেষ আর্টিকেল',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateTab?.call(2),
                    child: const Text(
                      'সব দেখুন',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ...getArticlesForJourney(JourneyType.planning).take(2).map(
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

  Widget _buildGuidelineCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.subtleCard,
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
