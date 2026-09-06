import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/article.dart';
import '../../../models/journey_type.dart';
import '../../../models/pregnancy_data.dart';
import '../../../data/baby_stages_data.dart';
import '../../../state/app_state.dart';
import '../../../widgets/daily_message_card.dart';
import '../../../widgets/article_widgets.dart';
import '../../tracker/baby_development_screen.dart';
import '../../tracker/vaccination_screen.dart';
import '../../tracker/appointments_screen.dart';

class HomeBabyView extends StatelessWidget {
  final Function(int)? onNavigateTab;
  const HomeBabyView({super.key, this.onNavigateTab});

  void _showBabySetupDialog(BuildContext context) {
    final baby = AppState.instance.babyData;
    final nameCtrl = TextEditingController(text: baby.name);
    DateTime selectedBirthDate =
        baby.isSetup ? baby.birthDate : DateTime.now().subtract(const Duration(days: 132));
    String gender = baby.gender;

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
                'শিশুর প্রোফাইল সেটআপ করুন',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              // Baby Name
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'শিশুর নাম',
                  hintText: 'যেমন: আরিয়ান / আয়েশা',
                  labelStyle: const TextStyle(fontFamily: 'Noto Sans Bengali'),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Birth Date Picker
              const Text(
                'শিশুর জন্মতারিখ',
                style: TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedBirthDate,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 730)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setModalState(() => selectedBirthDate = picked);
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
                      const Icon(Icons.cake_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${toBanglaDigits(selectedBirthDate.day)}/${toBanglaDigits(selectedBirthDate.month)}/${toBanglaDigits(selectedBirthDate.year)}',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
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
              const SizedBox(height: 20),

              // Submit Button
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
                    final babyName = nameCtrl.text.trim().isNotEmpty
                        ? nameCtrl.text.trim()
                        : 'আমার সোনামণি';
                    await AppState.instance.updateBabyData(
                      name: babyName,
                      birthDate: selectedBirthDate,
                      gender: gender,
                    );
                    if (context.mounted) Navigator.pop(context);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final baby = AppState.instance.babyData;
        final isSetup = baby.isSetup;

        // Determine current baby development stage from age in months
        final months = baby.ageInMonths;
        int stageIndex = 0;
        if (months < 1) {
          stageIndex = 0;
        } else if (months <= 3) {
          stageIndex = 1;
        } else if (months <= 6) {
          stageIndex = 2;
        } else if (months <= 9) {
          stageIndex = 3;
        } else if (months <= 12) {
          stageIndex = 4;
        } else {
          stageIndex = 5;
        }
        final stage = allBabyStages[stageIndex];

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
                  const Text('👶', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'আপনার সোনামণির হাসিমুখেই প্রতিদিনের আনন্দ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),

              // Dynamic Daily Message
              const DailyMessageCard(),

              // 1. HERO BABY DASHBOARD CARD
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
                      const Icon(Icons.child_friendly_rounded,
                          size: 48, color: Color(0xFF745B00)),
                      const SizedBox(height: 10),
                      const Text(
                        'আপনার শিশুর প্রোফাইল সেটআপ করুন',
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
                        'শিশুর নাম ও জন্মতারিখ যোগ করে প্রতিদিনের পুষ্টি, ঘুম ও বিকাশ ট্র্যাকিং শুরু করুন।',
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _showBabySetupDialog(context),
                          child: const Text(
                            'শিশুর নাম ও জন্মতারিখ যোগ করুন',
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
                        AppColors.surfaceContainerLowest,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.naturalBloom,
                    border: Border.all(
                        color: const Color(0xFFFECB17).withValues(alpha: 0.5)),
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
                                      color: const Color(0xFFFECB17),
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.full),
                                    ),
                                    child: Text(
                                      stage.ageRange,
                                      style: const TextStyle(
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
                                    onTap: () => _showBabySetupDialog(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.full),
                                        border: Border.all(
                                            color: const Color(0xFFFECB17)),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.edit_rounded,
                                              size: 12,
                                              color: Color(0xFF584400)),
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
                              const SizedBox(height: 8),
                              Text(
                                baby.name.isNotEmpty ? baby.name : 'আমার শিশু',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'বয়স: ${baby.ageStringBangla}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _showBabySetupDialog(context),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.child_care_rounded,
                                color: Color(0xFF745B00),
                                size: 36,
                              ),
                            ),
                          ),
                        ],
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
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BabyDevelopmentScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_stories_rounded, size: 18),
                          label: Text(
                            '${stage.ageRange} এর বিকাশ গাইড দেখুন',
                            style: const TextStyle(
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

              // 2. QUICK ACTIONS FOR BABY CARE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(
                    icon: Icons.child_care_rounded,
                    label: 'শিশুর\nবিকাশ',
                    color: const Color(0xFF745B00),
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
                    label: 'টিকা\nইপিআই',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VaccinationScreen()),
                      );
                    },
                  ),
                  _buildQuickAction(
                    icon: Icons.restaurant_rounded,
                    label: 'খাবার ও\nপুষ্টি',
                    color: const Color(0xFF2E7D32),
                    onTap: () => onNavigateTab?.call(2),
                  ),
                  _buildQuickAction(
                    icon: Icons.local_hospital_rounded,
                    label: 'ডাক্তারের\nপরামর্শ',
                    color: const Color(0xFF0288D1),
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

              // 3. TODAY'S BABY CARE GUIDELINES
              Text(
                '${stage.ageRange} এর প্রধান যত্ন',
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              _buildGuidelineCard(
                icon: Icons.restaurant_rounded,
                iconColor: const Color(0xFFE65100),
                title: 'খাওয়ানোর নিয়ম',
                description: stage.feedingGuide,
              ),
              const SizedBox(height: 10),

              _buildGuidelineCard(
                icon: Icons.bedtime_rounded,
                iconColor: const Color(0xFF0288D1),
                title: 'ঘুমের নিয়ম',
                description: stage.sleepGuide,
              ),
              const SizedBox(height: 10),

              _buildGuidelineCard(
                icon: Icons.emoji_events_rounded,
                iconColor: const Color(0xFF745B00),
                title: 'প্রধান মাইলফলক',
                description: stage.milestones.join(' • '),
              ),
              const SizedBox(height: 28),

              // 4. TODAY'S SAFETY & MOTHER/FATHER TIPS
              const Text(
                'নিরাপত্তা ও পারিবারিক যত্ন',
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.security_rounded,
                        color: Color(0xFF745B00), size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ঘরের সুরক্ষা ও শিশুর যত্ন',
                            style: TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF745B00),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stage.careTips.first,
                            style: const TextStyle(
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

              // 5. BABY ARTICLES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'শিশুর যত্নের বিশেষ গাইড',
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

              ...getArticlesForJourney(JourneyType.baby,
                      babyStageId: stage.id)
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
