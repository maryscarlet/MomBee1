import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/journey_type.dart';
import '../../models/pregnancy_data.dart';
import '../../state/app_state.dart';
import '../../services/app_localization.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showChangeJourneyDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
            Text(
              AppLocalization.changeJourney,
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            ...JourneyType.values.map((journey) {
              final isCurrent = AppState.instance.selectedJourney == journey;
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                tileColor: isCurrent
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : null,
                leading: Icon(
                  journey == JourneyType.planning
                      ? Icons.favorite_rounded
                      : journey == JourneyType.pregnant
                          ? Icons.pregnant_woman_rounded
                          : journey == JourneyType.baby
                              ? Icons.child_care_rounded
                              : Icons.menu_book_rounded,
                  color: isCurrent ? AppColors.primary : AppColors.outline,
                ),
                title: Text(
                  AppState.instance.isEnglish
                      ? journey.titleEnglish
                      : journey.titleBangla,
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
                trailing: isCurrent
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary)
                    : null,
                onTap: () async {
                  await AppState.instance.setJourney(journey);
                  if (context.mounted) Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    ),
  ),
);
  }

  void _showEditProfileModal() {
    final currentName = AppState.instance.userName;
    final currentAge = AppState.instance.userAge;
    final currentAvatar = AppState.instance.userAvatarUrl;

    final nameController = TextEditingController(text: currentName);
    int selectedAge = currentAge;
    String selectedAvatar = currentAvatar;

    final avatarOptions = [
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=300&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&auto=format&fit=crop&q=80',
    ];

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
                Text(
                  AppLocalization.editProfile,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Avatar Selection Header & Grid
                Text(
                  AppLocalization.selectAvatar,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 68,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: avatarOptions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, idx) {
                      final url = avatarOptions[idx];
                      final isSelected = selectedAvatar == url;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() => selectedAvatar = url);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.25),
                                      blurRadius: 8,
                                    )
                                  ]
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person,
                                  color: AppColors.primary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),

                // Name Input
                Text(
                  AppLocalization.nameLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLocalization.isEnglish
                        ? 'Enter your name'
                        : 'আপনার নাম লিখুন',
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: const BorderSide(color: AppColors.borderCard),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),

                // Age Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalization.ageLabel}: ${toBanglaDigits(selectedAge)} ${AppLocalization.yearsLabel}',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: selectedAge.toDouble(),
                  min: 16,
                  max: 55,
                  divisions: 39,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setModalState(() => selectedAge = val.round());
                  },
                ),
                const SizedBox(height: 16),

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
                      final newName = nameController.text.trim();
                      await AppState.instance.updateProfile(
                        name: newName.isNotEmpty ? newName : currentName,
                        age: selectedAge,
                        avatarUrl: selectedAvatar,
                      );
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalization.profileUpdated,
                              style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali'),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    child: Text(
                      AppLocalization.saveChanges,
                      style: const TextStyle(
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

  void _showLanguageDialog() {
    final currentLang = AppState.instance.language;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.selectLanguage,
            style: const TextStyle(
                fontFamily: 'Noto Sans Bengali', fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('বাংলা (Bangla)',
                  style: TextStyle(fontFamily: 'Noto Sans Bengali')),
              trailing: currentLang == 'বাংলা'
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary)
                  : null,
              onTap: () {
                AppState.instance.setLanguage('বাংলা');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English',
                  style: TextStyle(fontFamily: 'Noto Sans Bengali')),
              trailing: currentLang == 'English'
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary)
                  : null,
              onTap: () {
                AppState.instance.setLanguage('English');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalization.logoutConfirmTitle,
            style: const TextStyle(
                fontFamily: 'Noto Sans Bengali', fontWeight: FontWeight.w700)),
        content: Text(
          AppLocalization.logoutConfirmMessage,
          style: const TextStyle(fontFamily: 'Noto Sans Bengali'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalization.cancel,
                style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali', color: AppColors.outline)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/journey-selection',
                (route) => false,
              );
            },
            child: Text(AppLocalization.logout,
                style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showResetAppDataDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppState.instance.isEnglish
                    ? 'Reset All App Data?'
                    : 'অ্যাপের তথ্য রিসেট করবেন?',
                style: const TextStyle(
                  fontFamily: 'Noto Sans Bengali',
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppState.instance.isEnglish
                  ? 'Are you sure you want to reset all data?'
                  : 'আপনি কি নিশ্চিত যে আপনি আপনার সকল তথ্য রিসেট করতে চান?',
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.remove_circle_outline_rounded,
                          size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppState.instance.isEnglish
                              ? 'Your name, age, selected stage, pregnancy/baby data, period tracker logs, water intake, appointments, and marked vaccines will be completely deleted.'
                              : 'আপনার নাম, বয়স, নির্ধারিত পর্যায়, গর্ভাবস্থা/শিশুর তথ্য, পিরিয়ড লগ, পানির হিসাব, অ্যাপয়েন্টমেন্ট ও টিকার হিসাব সম্পূর্ণ মুছে ফেলা হবে।',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 12.5,
                            color: AppColors.error,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded,
                          size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppState.instance.isEnglish
                              ? 'Educational articles, videos, 40-week guide, and baby stages will remain fully accessible.'
                              : 'প্রয়োজনীয় আর্টিকেল, স্বাস্থ্য ভিডিও, ৪০ সপ্তাহের গাইড ও বেবি স্টেজ তথ্য অপরিবর্তিত থাকবে।',
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 12.5,
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppState.instance.isEnglish
                  ? 'After reset, you will be taken back to the first-time welcome screen.'
                  : 'রিসেট করার পর আপনাকে স্বাগতম ও নাম নির্ধারণের প্রথম স্ক্রিনে নিয়ে যাওয়া হবে।',
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppState.instance.isEnglish ? 'Cancel' : 'বাতিল',
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                color: AppColors.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AppState.instance.resetAllUserData();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/user-setup',
                  (route) => false,
                );
              }
            },
            child: Text(
              AppState.instance.isEnglish ? 'Reset Data' : 'তথ্য রিসেট করুন',
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditHealthInfoModal() {
    final journey = AppState.instance.selectedJourney;

    if (journey == JourneyType.pregnant) {
      final existingLmp = AppState.instance.pregnancyData.lmpDate;
      DateTime selectedDate = existingLmp ??
          DateTime.now().subtract(const Duration(days: 168));

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
          builder: (context, setModalState) {
            final diffDays = DateTime.now().difference(selectedDate).inDays;
            final calcWeek = diffDays >= 0
                ? ((diffDays / 7).floor() + 1).clamp(1, 40)
                : 1;
            final calcEdd = selectedDate.add(const Duration(days: 280));

            return Container(
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
                    'গর্ভাবস্থার তথ্য পরিবর্তন করুন',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'আপনার শেষ মাসিকের ১ম দিন (LMP) নির্বাচন করুন যাতে আমরা সঠিক গর্ভকালীন সপ্তাহ গণনা করতে পারি।',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 280)),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded,
                              color: AppColors.primary, size: 22),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'শেষ মাসিকের ১ম দিন (LMP)',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 11,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${toBanglaDigits(selectedDate.day)}/${toBanglaDigits(selectedDate.month)}/${toBanglaDigits(selectedDate.year)}',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
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
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6D6),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                          color:
                              const Color(0xFFFECB17).withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insights_rounded,
                            color: Color(0xFF745B00), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'হিসাব অনুযায়ী: ${toBanglaDigits(calcWeek)}তম সপ্তাহ চলছে • সম্ভাব্য প্রসব: ${toBanglaDigits(calcEdd.day)}/${toBanglaDigits(calcEdd.month)}/${toBanglaDigits(calcEdd.year)}',
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF584400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        await AppState.instance
                            .updatePregnancyWithLMP(selectedDate);
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'প্রেগন্যান্সি তথ্য সফলভাবে আপডেট হয়েছে!',
                                style: TextStyle(
                                    fontFamily: 'Noto Sans Bengali'),
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'তথ্য আপডেট করুন',
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
          },
        ),
      );
    } else if (journey == JourneyType.baby) {
      final baby = AppState.instance.babyData;
      final nameCtrl = TextEditingController(text: baby.name);
      DateTime birthDate = baby.birthDate;

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
                  'শিশুর তথ্য পরিবর্তন করুন',
                  style: TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'শিশুর নাম',
                    labelStyle:
                        const TextStyle(fontFamily: 'Noto Sans Bengali'),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: birthDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 730)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setModalState(() => birthDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cake_rounded,
                            color: AppColors.secondary, size: 22),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'জন্মতারিখ',
                              style: TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${toBanglaDigits(birthDate.day)}/${toBanglaDigits(birthDate.month)}/${toBanglaDigits(birthDate.year)}',
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'পরিবর্তন',
                          style: TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 12,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    onPressed: () async {
                      await AppState.instance.updateBabyData(
                        name: nameCtrl.text.trim().isEmpty
                            ? 'সোনামণি'
                            : nameCtrl.text.trim(),
                        birthDate: birthDate,
                      );
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'শিশুর তথ্য সফলভাবে আপডেট হয়েছে!',
                              style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali'),
                            ),
                            backgroundColor: AppColors.secondary,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'তথ্য সংরক্ষণ করুন',
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
    } else {
      _showInfoDialog(
        'স্বাস্থ্য তথ্য',
        'আপনার বর্তমান যাত্রা অনুযায়ী প্রয়োজনীয় তথ্য সংশ্লিষ্ট ট্র্যাকার স্ক্রিন থেকে আপডেট করা যাবে।',
      );
    }
  }

  void _showAboutMomBeeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 180,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => const Text(
                  'MomBee',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'MomBee সম্পর্কে',
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'MomBee - মা ও শিশুর সার্বিক বিকাশ ও যত্নে আপনার নির্ভরযোগ্য ডিজিটাল সঙ্গী।\n\nসংস্করণ: ১.০.৪\nডেভেলপড ফর বাংলাদেশ।',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 13,
                height: 1.5,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে',
                style: TextStyle(
                    fontFamily: 'Noto Sans Bengali', color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: const TextStyle(
                fontFamily: 'Noto Sans Bengali', fontWeight: FontWeight.w700)),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Noto Sans Bengali', height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppState.instance.isEnglish ? 'OK' : 'ঠিক আছে',
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                color: AppColors.primary,
              ),
            ),
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
        final journey = AppState.instance.selectedJourney;
        final currentWeek = AppState.instance.currentPregnancyWeek;
        final isPregnancySetup = AppState.instance.isPregnancySetup;
        final periodData = AppState.instance.periodData;
        final babyData = AppState.instance.babyData;
        final completedVaccines =
            AppState.instance.vaccines.where((v) => v.isCompleted).length;
        final currentLang = AppState.instance.language;

        // Dynamic Stat 1 calculation
        String stat1Value = '';
        String stat1Label = '';
        if (journey == JourneyType.planning) {
          stat1Value = '${toBanglaDigits(periodData.currentCycleDay)} ${AppLocalization.day}';
          stat1Label = AppLocalization.currentCycleDay;
        } else if (journey == JourneyType.pregnant) {
          stat1Value = isPregnancySetup
              ? '${toBanglaDigits(currentWeek)} ${AppLocalization.week}'
              : AppLocalization.setupNow;
          stat1Label = isPregnancySetup
              ? AppLocalization.weekOfPregnancy
              : AppLocalization.week;
        } else if (journey == JourneyType.baby) {
          stat1Value = babyData.isSetup
              ? babyData.ageString
              : AppLocalization.setupNow;
          stat1Label = babyData.name.isNotEmpty
              ? '${babyData.name} - ${AppLocalization.babyAgeLabel}'
              : AppLocalization.babyAgeLabel;
        } else {
          stat1Value = '৩০০+';
          stat1Label = AppLocalization.articlesAndGuides;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceContainerLowest,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              AppLocalization.profileTitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.08),
                            ),
                          ),
                          Container(
                            width: 92,
                            height: 92,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surfaceContainerLowest,
                                width: 4,
                              ),
                              boxShadow: AppShadows.naturalBloom,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(46),
                              child: Image.network(
                                AppState.instance.userAvatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person_rounded,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _showEditProfileModal,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.edit_rounded,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppState.instance.userName.isNotEmpty
                            ? AppState.instance.userName
                            : (AppState.instance.isEnglish
                                ? 'MomBee Member'
                                : 'মমবি সদস্য'),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${AppLocalization.ageLabel}: ${toBanglaDigits(AppState.instance.userAge)} ${AppLocalization.yearsLabel}',
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          ActionChip(
                            avatar: Icon(
                              journey == JourneyType.planning
                                  ? Icons.favorite_rounded
                                  : journey == JourneyType.pregnant
                                      ? Icons.pregnant_woman_rounded
                                      : journey == JourneyType.baby
                                          ? Icons.child_care_rounded
                                          : Icons.menu_book_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              AppState.instance.isEnglish
                                  ? journey.titleEnglish
                                  : journey.titleBangla,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            side: BorderSide.none,
                            onPressed: _showChangeJourneyDialog,
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.edit_rounded,
                                size: 14, color: Color(0xFF745B00)),
                            label: Text(
                              AppLocalization.editProfile,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF745B00),
                              ),
                            ),
                            backgroundColor: const Color(0xFFFFF6D6),
                            side: BorderSide.none,
                            onPressed: _showEditProfileModal,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Dynamic Stats Bento Grid
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: AppShadows.subtleCard,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                journey == JourneyType.planning
                                    ? Icons.calendar_month_rounded
                                    : journey == JourneyType.pregnant
                                        ? Icons.pregnant_woman_rounded
                                        : journey == JourneyType.baby
                                            ? Icons.child_care_rounded
                                            : Icons.auto_stories_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              stat1Value,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              stat1Label,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              AppColors.secondaryFixed.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          boxShadow: AppShadows.subtleCard,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.secondary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.secondary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              toBanglaDigits(completedVaccines),
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalization.completedVaccinesLabel,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Activity Group
                _buildSettingsSection(
                  title: AppLocalization.myActivity,
                  items: [
                    _SettingsItem(
                      icon: Icons.sync_alt_rounded,
                      title: AppLocalization.changeJourney,
                      subtitle: AppState.instance.isEnglish
                          ? journey.titleEnglish
                          : journey.titleBangla,
                      subtitleColor: AppColors.primary,
                      onTap: _showChangeJourneyDialog,
                    ),
                    _SettingsItem(
                      icon: Icons.person_outline_rounded,
                      title: AppLocalization.editNameAndAge,
                      subtitle: AppState.instance.userName.isNotEmpty
                          ? '${AppState.instance.userName}, ${toBanglaDigits(AppState.instance.userAge)} ${AppLocalization.yearsLabel}'
                          : (AppState.instance.isEnglish
                              ? 'Set name & age'
                              : 'নাম ও বয়স যোগ করুন'),
                      subtitleColor: AppColors.primary,
                      onTap: _showEditProfileModal,
                    ),
                    _SettingsItem(
                      icon: Icons.edit_calendar_rounded,
                      title: AppLocalization.editHealthInfo,
                      subtitle: journey == JourneyType.pregnant
                          ? (AppState.instance.isEnglish
                              ? 'Change LMP & Estimated Due Date'
                              : 'LMP ও প্রসবের সম্ভাব্য তারিখ পরিবর্তন')
                          : journey == JourneyType.baby
                              ? (AppState.instance.isEnglish
                                  ? 'Update baby name & birth date'
                                  : 'শিশুর নাম ও জন্মতারিখ আপডেট')
                              : (AppState.instance.isEnglish
                                  ? 'Period cycle settings'
                                  : 'মাসিক চক্রের সেটিংস'),
                      subtitleColor: AppColors.primary,
                      onTap: _showEditHealthInfoModal,
                    ),
                    _SettingsItem(
                      icon: Icons.bookmark_border_rounded,
                      title: AppLocalization.savedContent,
                      onTap: () => _showInfoDialog(
                        AppLocalization.savedContent,
                        AppState.instance.isEnglish
                            ? 'You have 3 bookmarked articles and 2 saved videos.'
                            : 'আপনার ৩টি বুকমার্ক করা প্রবন্ধ ও ২টি সংরক্ষিত ভিডিও রয়েছে।',
                      ),
                    ),
                    _SettingsItem(
                      icon: Icons.event_available_rounded,
                      title: AppLocalization.appointments,
                      subtitle: AppState.instance.appointments.isNotEmpty
                          ? AppState.instance.appointments.first.doctorName
                          : (AppState.instance.isEnglish
                              ? 'No upcoming appointments'
                              : 'কোনো আসন্ন অ্যাপয়েন্টমেন্ট নেই'),
                      subtitleColor: AppColors.primary,
                      hasBadge: AppState.instance.appointments.isNotEmpty,
                      onTap: () => _showInfoDialog(
                        AppLocalization.appointments,
                        AppState.instance.appointments.isNotEmpty
                            ? '${AppState.instance.appointments.first.doctorName}\n${AppState.instance.appointments.first.location}'
                            : (AppState.instance.isEnglish
                                ? 'No new appointments scheduled.'
                                : 'কোনো নতুন অ্যাপয়েন্টমেন্ট নির্ধারিত নেই।'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Settings Group
                _buildSettingsSection(
                  title: AppLocalization.settings,
                  items: [
                    _SettingsItem(
                      icon: Icons.notifications_none_rounded,
                      title: AppLocalization.notifications,
                      trailingWidget: Switch.adaptive(
                        value: _notificationsEnabled,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _notificationsEnabled = val);
                        },
                      ),
                    ),
                    _SettingsItem(
                      icon: Icons.language_rounded,
                      title: AppLocalization.language,
                      subtitle: currentLang,
                      onTap: _showLanguageDialog,
                    ),
                    _SettingsItem(
                      icon: Icons.restart_alt_rounded,
                      title: AppState.instance.isEnglish
                          ? 'Reset App Data'
                          : 'অ্যাপের তথ্য রিসেট করুন',
                      subtitle: AppState.instance.isEnglish
                          ? 'Clear all personal data & restore setup'
                          : 'সকল তথ্য মুছে নতুন করে শুরু করুন',
                      subtitleColor: AppColors.error,
                      onTap: _showResetAppDataDialog,
                    ),
                    _SettingsItem(
                      icon: Icons.security_rounded,
                      title: AppLocalization.privacyPolicy,
                      onTap: () => _showInfoDialog(
                        AppLocalization.privacyPolicy,
                        AppState.instance.isEnglish
                            ? 'MomBee ensures highest privacy for your personal and health data. All information is stored locally on your device.'
                            : 'MomBee আপনার ব্যক্তিগত ও স্বাস্থ্যগত তথ্যের সর্বোচ্চ নিরাপত্তা প্রদান করে। আপনার তথ্য সম্পূর্ণ স্থানীয়ভাবে সংরক্ষিত।',
                      ),
                    ),
                    _SettingsItem(
                      icon: Icons.info_outline_rounded,
                      title: AppLocalization.aboutMomBee,
                      onTap: _showAboutMomBeeDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Logout CTA
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.errorContainer.withValues(alpha: 0.3),
                      foregroundColor: AppColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text(
                      'লগ আউট',
                      style: TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Version Footer
                Text(
                  AppState.instance.isEnglish
                      ? 'Version 1.0.4 (Build 24)'
                      : 'ভার্সন ১.০.৪ (বিল্ড ২৪)',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans Bengali',
                    fontSize: 12,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.subtleCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Noto Sans Bengali',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.primary,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item.icon,
                                  size: 20,
                                  color: AppColors.tertiary,
                                ),
                              ),
                              if (item.hasBadge)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 9,
                                    height: 9,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans Bengali',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                if (item.subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle!,
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans Bengali',
                                      fontSize: 12,
                                      color: item.subtitleColor ??
                                          AppColors.onSurfaceVariant,
                                      fontWeight: item.subtitleColor != null
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          item.trailingWidget ??
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.outline,
                                size: 20,
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    indent: 68,
                    endIndent: 16,
                    color: AppColors.surfaceContainer,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final bool hasBadge;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.hasBadge = false,
    this.trailingWidget,
    this.onTap,
  });
}
