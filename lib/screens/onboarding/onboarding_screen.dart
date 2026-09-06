import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'title': 'মা হওয়ার যাত্রায় MomBee আপনার পাশে',
      'subtitle':
          'গর্ভধারণের প্রস্তুতি থেকে শিশুর যত্ন—প্রতিদিনের দরকারি তথ্য, টিপস ও ট্র্যাকার এক জায়গায়।',
      'features': [
        {
          'icon': Icons.calendar_month_rounded,
          'iconBg': AppColors.primaryContainer,
          'iconColor': AppColors.onPrimaryContainer,
          'title': 'কাস্টমাইজড ট্র্যাকার',
          'desc': 'আপনার গর্ভাবস্থার সপ্তাহ অনুযায়ী প্রতিদিনের আপডেট',
        },
        {
          'icon': Icons.local_library_rounded,
          'iconBg': AppColors.secondaryContainer,
          'iconColor': AppColors.onSecondaryContainer,
          'title': 'বিশেষজ্ঞ পরামর্শ',
          'desc': 'ডাক্তার অনুমোদিত নির্ভরযোগ্য স্বাস্থ্য তথ্য',
        },
      ],
    },
    {
      'title': 'সঠিক সময়ে সঠিক পুষ্টি ও স্বাস্থ্য পরীক্ষা',
      'subtitle':
          'প্রতিটি ট্রাইমেস্টারের প্রয়োজনীয় খাবার তালিকা, ভিটামিন ও আল্ট্রাসনোগ্রাম রিমাইন্ডার।',
      'features': [
        {
          'icon': Icons.restaurant_rounded,
          'iconBg': AppColors.secondaryContainer,
          'iconColor': AppColors.onSecondaryContainer,
          'title': 'ব্যক্তিগত পুষ্টি চার্ট',
          'desc': 'মা ও শিশুর প্রয়োজনীয় ক্যালসিয়াম, আয়রন ও ফলিক এসিডের গাইডলাইন',
        },
        {
          'icon': Icons.notifications_active_rounded,
          'iconBg': AppColors.primaryContainer,
          'iconColor': AppColors.onPrimaryContainer,
          'title': 'জরুরি নোটিফিকেশন',
          'desc': 'ডাক্তারের ভিজিট ও টিকা মিস না করার স্মার্ট অ্যালার্ট',
        },
      ],
    },
    {
      'title': 'শিশুর বিকাশ ও মাইলফলক ট্র্যাকিং',
      'subtitle':
          'সন্তানের প্রথম হাসি, ওজন বৃদ্ধি এবং টিকাদানের সময়সূচি ট্র্যাক করুন সহজে।',
      'features': [
        {
          'icon': Icons.child_care_rounded,
          'iconBg': AppColors.primaryContainer,
          'iconColor': AppColors.onPrimaryContainer,
          'title': 'বেবি গ্রোথ চার্ট',
          'desc': 'বিশ্ব স্বাস্থ্য সংস্থার মান অনুযায়ী শিশুর বৃদ্ধি পর্যবেক্ষণ',
        },
        {
          'icon': Icons.vaccines_rounded,
          'iconBg': AppColors.secondaryContainer,
          'iconColor': AppColors.onSecondaryContainer,
          'title': 'টিকাদান সূচি (EPI)',
          'desc': 'সকল বাধ্যতামূলক ও প্রস্তাবিত টিকার ডিজিটাল ট্র্যাকার',
        },
      ],
    },
  ];

  void _onNext() {
    if (_currentPage < _onboardingPages.length - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      Navigator.of(context).pushReplacementNamed('/journey-selection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageData = _onboardingPages[_currentPage];
    final features = pageData['features'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top Brand Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 32,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Top Illustration with Glowing rings
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer pulsing aura
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: 0.08),
                              ),
                            ),
                            // Inner circle
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: 0.15),
                              ),
                            ),
                            // Center Icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.surfaceContainerLowest,
                              ),
                              child: const Icon(
                                Icons.pregnant_woman_rounded,
                                size: 48,
                                color: AppColors.primary,
                              ),
                            ),
                            // Floating Heart Badge
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.favorite_rounded,
                                  size: 16,
                                  color: AppColors.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Text Headers
                      Text(
                        pageData['title'] as String,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        pageData['subtitle'] as String,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Feature Cards
                      ...features.map((feature) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              boxShadow: AppShadows.subtleCard,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: feature['iconBg'] as Color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    feature['icon'] as IconData,
                                    color: feature['iconColor'] as Color,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feature['title'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: AppColors.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        feature['desc'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const Spacer(),

                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_onboardingPages.length, (index) {
                          final isSelected = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: isSelected ? 24.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceDim,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 4,
                            shadowColor: AppColors.primary.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage == _onboardingPages.length - 1
                                    ? 'শুরু করি'
                                    : 'পরবর্তী',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
