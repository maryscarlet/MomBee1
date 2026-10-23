import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/pregnancy_data.dart';
import '../../../data/baby_stages_data.dart';
import '../../../state/app_state.dart';
import '../../../widgets/daily_message_card.dart';
import '../widgets/home_greeting_header.dart';
import '../../tracker/period_tracker_screen.dart';
import '../../tracker/pregnancy_tracker_screen.dart';
import '../../tracker/baby_development_screen.dart';
import '../../tracker/vaccination_screen.dart';

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
              // 1 & 2. Dynamic time-based greeting & Bangla date
              const HomeGreetingHeader(emoji: '👶'),

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
                              const SizedBox(height: 4),
                              Text(
                                '${stage.ageRange} এর বিকাশের সুন্দর সময় পার করছে আপনার সোনামণি।',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
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
                    ],
                  ),
                ),

              // 3. ONE CONCISE DEVELOPMENTAL INFORMATION SECTION
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
                        Icons.child_friendly_rounded,
                        color: Color(0xFF745B00),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${stage.ageRange} বিকাশ ও যত্ন',
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            stage.careTips.first,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
                            builder: (context) => const BabyDevelopmentScreen(),
                          ),
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
                            'গাইড',
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
