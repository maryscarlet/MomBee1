import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/article.dart';
import '../../../models/journey_type.dart';
import '../../../widgets/daily_message_card.dart';
import '../../../widgets/article_widgets.dart';
import '../../tracker/vaccination_screen.dart';
import '../../tracker/period_tracker_screen.dart';
import '../../tracker/baby_development_screen.dart';
import '../../pregnancy/pregnancy_week_guide_screen.dart';

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
              const Text('✨', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'অভিজ্ঞ ডাক্তারদের নির্ভরযোগ্য মাতৃত্ব ও প্যারেন্টিং তথ্যভাণ্ডার',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),

          // Dynamic Daily Message
          const DailyMessageCard(),

          // 1. HERO LEARNING EXPLORE CARD
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
            padding: const EdgeInsets.all(20.0),
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
                        'তথ্য ও শিক্ষা ভাণ্ডার',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'প্রতিদিনের প্রয়োজনীয় স্বাস্থ্য তথ্য',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'গর্ভাবস্থা, পুষ্টি, নবজাতকের যত্ন ও প্যারেন্টিং বিষয়ক ৩০০+ বিশেষজ্ঞ আর্টিকেল ও ভিডিও গাইড।',
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    onPressed: () => onNavigateTab?.call(2), // Learn tab
                    icon: const Icon(Icons.explore_rounded, size: 18),
                    label: const Text(
                      'সকল আর্টিকেল ও বিষয় অনুসন্ধান করুন',
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

          // 2. EXPLORE TOPICS GRID
          const Text(
            'বিষয়ভিত্তিক জ্ঞান',
            style: TextStyle(
              fontFamily: 'Noto Sans Bengali',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildTopicTile(
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFE91E63),
                  title: 'গর্ভধারণের প্রস্তুতি',
                  subtitle: 'ওভুলেশন ও পুষ্টি',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PeriodTrackerScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTopicTile(
                  icon: Icons.pregnant_woman_rounded,
                  color: AppColors.primary,
                  title: '১-৪০ সপ্তাহ গাইড',
                  subtitle: 'সাপ্তাহিক বিকাশ',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PregnancyWeekGuideScreen(initialWeek: 1)),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildTopicTile(
                  icon: Icons.child_care_rounded,
                  color: const Color(0xFF745B00),
                  title: 'শিশুর বিকাশ',
                  subtitle: 'মাইলফলক ও যত্ন',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const BabyDevelopmentScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTopicTile(
                  icon: Icons.vaccines_rounded,
                  color: const Color(0xFF0288D1),
                  title: 'টিকা ও প্রতিরোধ',
                  subtitle: 'ইপিআই শিডিউল',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VaccinationScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // 3. TODAY'S GENERAL HEALTH TIP
          const Text(
            'আজকের সচেতনতা টিপস',
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
                        'পর্যাপ্ত পানি ও সুষম খাদ্যাভ্যাস',
                        style: TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF745B00),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'মা ও শিশুর সুস্থতায় দৈনিক অন্তত ৮-১০ গ্লাস বিশুদ্ধ পানি পান করা এবং মৌসুমি তাজা ফলমূল গ্রহণ করা অত্যন্ত জরুরি।',
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

          // 4. POPULAR ARTICLES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'জনপ্রিয় আর্টিকেল',
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

          ...getArticlesForJourney(JourneyType.general).take(3).map(
                (art) => ArticleCard(
                  article: art,
                  onTap: () => showMomBeeArticleDetails(context, art),
                ),
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTopicTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderCard),
            boxShadow: AppShadows.subtleCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
