import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mombee_app/main.dart';
import 'package:mombee_app/state/app_state.dart';
import 'package:mombee_app/models/journey_type.dart';
import 'package:mombee_app/models/pregnancy_data.dart';
import 'package:mombee_app/models/period_data.dart';
import 'package:mombee_app/data/pregnancy_weeks_data.dart';
import 'package:mombee_app/data/baby_stages_data.dart';
import 'package:mombee_app/models/baby_data.dart';
import 'package:mombee_app/models/article.dart';
import 'package:mombee_app/screens/splash/splash_screen.dart';
import 'package:mombee_app/screens/onboarding/onboarding_screen.dart';
import 'package:mombee_app/screens/journey/journey_selection_screen.dart';
import 'package:mombee_app/screens/main_navigation_shell.dart';
import 'package:mombee_app/screens/pregnancy/pregnancy_week_guide_screen.dart';
import 'package:mombee_app/screens/tracker/period_tracker_screen.dart';
import 'package:mombee_app/screens/tracker/pregnancy_tracker_screen.dart';
import 'package:mombee_app/screens/tracker/baby_development_screen.dart';
import 'package:mombee_app/screens/tracker/appointments_screen.dart';
import 'package:mombee_app/screens/tracker/vaccination_screen.dart';
import 'package:mombee_app/screens/tracker/tracker_hub_screen.dart';
import 'package:mombee_app/screens/profile/profile_screen.dart';
import 'package:mombee_app/models/video.dart';
import 'package:mombee_app/screens/video/video_library_screen.dart';
import 'package:mombee_app/screens/learn/learn_hub_screen.dart';
import 'package:mombee_app/screens/onboarding/user_name_setup_screen.dart';
import 'package:mombee_app/models/fetal_stage_visual_data.dart';
import 'package:mombee_app/widgets/fetal_development_visual.dart';
import 'package:mombee_app/screens/home/home_pregnant_screen.dart';
import 'package:mombee_app/data/vaccines_data.dart';
import 'package:mombee_app/services/local_storage_service.dart';
import 'package:mombee_app/services/app_localization.dart';
import 'package:mombee_app/theme/app_theme.dart';
import 'package:mombee_app/widgets/water_tracker_modal.dart';
import 'package:mombee_app/widgets/daily_message_card.dart';
import 'package:mombee_app/models/appointment.dart';
import 'package:mombee_app/models/vaccine_item.dart';
import 'package:mombee_app/services/daily_message_service.dart';
import 'package:mombee_app/services/notification_service.dart';
import 'package:mombee_app/models/notification_item.dart';
import 'package:mombee_app/screens/notifications/notification_center_screen.dart';
import 'package:mombee_app/widgets/notification_permission_dialog.dart';
import 'package:mombee_app/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppState.instance.initialize();
  });

  group('1. Smoke & Initial Navigation Flow', () {
    testWidgets('App starts on SplashScreen with official logo branding',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MomBeeApp());
      expect(find.byType(SplashScreen), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('PARENTING COMPANION'), findsOneWidget);
      expect(find.text('NURTURING WITH CARE'), findsOneWidget);
    });

    testWidgets('OnboardingScreen renders with Bangla heading and CTA button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: OnboardingScreen()),
      );

      expect(find.text('মা হওয়ার যাত্রায় MomBee আপনার পাশে'), findsOneWidget);
      expect(find.text('কাস্টমাইজড ট্র্যাকার'), findsOneWidget);
      expect(find.text('বিশেষজ্ঞ পরামর্শ'), findsOneWidget);
      expect(find.text('পরবর্তী'), findsOneWidget);
    });

    testWidgets('JourneySelectionScreen renders 4 distinct options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: JourneySelectionScreen()),
      );

      expect(find.text('আপনি এখন কোন পর্যায়ে আছেন?'), findsOneWidget);
      expect(find.text('গর্ভধারণের পরিকল্পনা করছি'), findsOneWidget);
      expect(find.text('আমি গর্ভবতী'), findsOneWidget);
      expect(find.text('আমার শিশু আছে'), findsOneWidget);
      expect(find.text('শুধু তথ্য জানতে চাই'), findsOneWidget);
    });
  });

  group('2. Four Journeys Independence & State Separation', () {
    testWidgets('TEST 1 (Planning): Dedicated Pre-Pregnancy dashboard without Week 24',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.planning);

      await tester.pumpWidget(
        const MaterialApp(home: MainNavigationShell()),
      );
      await tester.pumpAndSettle();

      expect(find.text('গর্ভধারণের প্রস্তুতি'), findsWidgets);
      expect(find.text('আজকের প্রস্তুতি ও উর্বর সময়'), findsOneWidget);
      expect(find.text('মায়ের প্রস্তুতি'), findsOneWidget);
      expect(find.text('বাবার ভূমিকা ও প্রস্তুতি'), findsOneWidget);
      expect(find.textContaining('২৪ সপ্তাহে'), findsNothing);
      expect(find.textContaining('২৪তম সপ্তাহ সম্পর্কে জানুন'), findsNothing);
    });

    testWidgets('TEST 2 (Pregnant): Dynamic Week 8 when LMP set, NO hardcoded week 24',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.pregnant);
      await AppState.instance.resetPregnancySetup();

      await tester.pumpWidget(
        const MaterialApp(home: MainNavigationShell()),
      );
      await tester.pumpAndSettle();

      // Unset setup banner
      expect(find.text('আপনার Pregnancy Journey সেটআপ করুন'), findsOneWidget);
      expect(find.textContaining('২৪ সপ্তাহে'), findsNothing);

      // Set LMP for Week 8 (~52 days ago)
      final lmp8Weeks = DateTime.now().subtract(const Duration(days: 52));
      await AppState.instance.updatePregnancyWithLMP(lmp8Weeks);
      await tester.pumpAndSettle();

      expect(AppState.instance.currentPregnancyWeek, 8);
      expect(AppState.instance.currentTrimester, 1);
      expect(find.text('১ম ট্রাইমেস্টার'), findsWidgets);
      expect(find.text('৮তম সপ্তাহ সম্পর্কে জানুন'), findsOneWidget);
      expect(find.text('৮তম সপ্তাহের বিশেষ টিপস'), findsOneWidget);
      expect(find.textContaining('২৪ সপ্তাহে'), findsNothing);
    });

    testWidgets('TEST 3 (Baby): Baby dashboard with dynamic calculated age',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.baby);
      await AppState.instance.resetBabySetup();

      await tester.pumpWidget(
        const MaterialApp(home: MainNavigationShell()),
      );
      await tester.pumpAndSettle();

      expect(find.text('আপনার শিশুর প্রোফাইল সেটআপ করুন'), findsOneWidget);
      expect(find.textContaining('২৪ সপ্তাহে'), findsNothing);

      // Setup baby "আরিয়ান", 4 months 12 days ago (134 days)
      final birthDate = DateTime.now().subtract(const Duration(days: 134));
      await AppState.instance.updateBabyData(
        name: 'আরিয়ান',
        birthDate: birthDate,
      );
      await tester.pumpAndSettle();

      expect(find.text('আরিয়ান'), findsOneWidget);
      expect(find.textContaining('৪ মাস'), findsWidgets);
      expect(find.text('খাওয়ানোর নিয়ম'), findsOneWidget);
      expect(find.text('ঘুমের নিয়ম'), findsOneWidget);
      expect(find.text('প্রধান মাইলফলক'), findsOneWidget);
      expect(find.textContaining('২৪ সপ্তাহে'), findsNothing);
    });

    testWidgets('TEST 4 (General): General knowledge hub without pregnancy tracking',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.general);

      await tester.pumpWidget(
        const MaterialApp(home: MainNavigationShell()),
      );
      await tester.pumpAndSettle();

      expect(find.text('তথ্য ও শিক্ষা ভাণ্ডার'), findsOneWidget);
      expect(find.text('প্রতিদিনের প্রয়োজনীয় স্বাস্থ্য তথ্য'), findsOneWidget);
      expect(find.text('বিষয়ভিত্তিক জ্ঞান'), findsOneWidget);
      expect(find.text('জনপ্রিয় আর্টিকেল'), findsOneWidget);
      expect(find.textContaining('২৪ সপ্তাহে'), findsNothing);
    });
  });

  group('3. Pregnancy System & 40 Weeks Audit', () {
    test('Verify all 40 weeks dataset integrity', () {
      expect(allPregnancyWeeks.length, 40);
      for (int i = 1; i <= 40; i++) {
        final week = allPregnancyWeeks.firstWhere((w) => w.weekNumber == i);
        expect(week.weekNumber, i);
        expect(week.babySizeComparison.isNotEmpty, true);
        expect(week.babyLength.isNotEmpty, true);
        expect(week.babyWeight.isNotEmpty, true);
        expect(week.babyDevelopment.isNotEmpty, true);
        expect(week.motherChanges.isNotEmpty, true);
        expect(week.nutrition.isNotEmpty, true);
        expect(week.healthAndCare.isNotEmpty, true);
        expect(week.weeklyTodos.isNotEmpty, true);
        expect(week.warningSigns.isNotEmpty, true);
      }
    });

    testWidgets('Test sampling of weeks (Week 1, 8, 12, 20, 24, 28, 35, 40)',
        (WidgetTester tester) async {
      final sampleWeeks = [1, 8, 12, 20, 24, 28, 35, 40];
      for (final weekNum in sampleWeeks) {
        await tester.pumpWidget(
          MaterialApp(
            home: PregnancyWeekGuideScreen(
              key: ValueKey('sample_w_$weekNum'),
              initialWeek: weekNum,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('${toBanglaDigits(weekNum)}তম সপ্তাহ'), findsWidgets);
      }
    });

    test('Dynamic gestational week calculation and edge case handling', () {
      final now = DateTime.now();

      // Week 1 (0-6 days)
      final lmpW1 = PregnancyData(lmpDate: now.subtract(const Duration(days: 3)), isSetup: true);
      expect(lmpW1.calculateCurrentWeek(), 1);
      expect(lmpW1.calculateTrimester(), 1);

      // Week 12 (~80 days)
      final lmpW12 = PregnancyData(lmpDate: now.subtract(const Duration(days: 80)), isSetup: true);
      expect(lmpW12.calculateCurrentWeek(), 12);
      expect(lmpW12.calculateTrimester(), 1);

      // Week 24 (~164 days)
      final lmpW24 = PregnancyData(lmpDate: now.subtract(const Duration(days: 164)), isSetup: true);
      expect(lmpW24.calculateCurrentWeek(), 24);
      expect(lmpW24.calculateTrimester(), 2);

      // Week 35 (~240 days)
      final lmpW35 = PregnancyData(lmpDate: now.subtract(const Duration(days: 240)), isSetup: true);
      expect(lmpW35.calculateCurrentWeek(), 35);
      expect(lmpW35.calculateTrimester(), 3);

      // Week 40 boundary (275 days)
      final lmpW40 = PregnancyData(lmpDate: now.subtract(const Duration(days: 275)), isSetup: true);
      expect(lmpW40.calculateCurrentWeek(), 40);
      expect(lmpW40.calculateTrimester(), 3);

      // Clamping: Beyond 40 weeks (300 days)
      final lmpOver40 = PregnancyData(lmpDate: now.subtract(const Duration(days: 300)), isSetup: true);
      expect(lmpOver40.calculateCurrentWeek(), 40);

      // Invalid future date (negative difference)
      final lmpFuture = PregnancyData(lmpDate: now.add(const Duration(days: 10)), isSetup: true);
      expect(lmpFuture.calculateCurrentWeek(), 1);
    });
  });

  group('4. Period Tracker Cycle Calculations (28, 30, 32 days)', () {
    test('Period Tracker with 28, 30, 32-day cycle calculations', () {
      final baseDate = DateTime(2026, 8, 1);

      // 28-day cycle: LMP 2026-08-01 -> Next period = 2026-08-01 + 28 days = 2026-08-29
      final cycle28 = PeriodData(lastPeriodDate: baseDate, cycleLength: 28, periodDuration: 5);
      expect(cycle28.cycleLength, 28);
      expect(cycle28.estimatedNextPeriod, DateTime(2026, 8, 29));
      expect(cycle28.upcomingNextPeriod.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);

      // 30-day cycle: LMP 2026-08-01 -> Next period = 2026-08-01 + 30 days = 2026-08-31
      final cycle30 = PeriodData(lastPeriodDate: baseDate, cycleLength: 30, periodDuration: 5);
      expect(cycle30.cycleLength, 30);
      expect(cycle30.estimatedNextPeriod, DateTime(2026, 8, 31));
      expect(cycle30.upcomingNextPeriod.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);

      // 32-day cycle: LMP 2026-08-01 -> Next period = 2026-08-01 + 32 days = 2026-09-02
      final cycle32 = PeriodData(lastPeriodDate: baseDate, cycleLength: 32, periodDuration: 5);
      expect(cycle32.cycleLength, 32);
      expect(cycle32.estimatedNextPeriod, DateTime(2026, 9, 2));
      expect(cycle32.upcomingNextPeriod.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);
    });

    testWidgets('PeriodTrackerScreen renders cycle day, stats, and calendar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PeriodTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('পিরিয়ড ট্র্যাকার'), findsOneWidget);
      expect(find.text('ওভুলেশন ডে'), findsWidgets);
      expect(find.text('উর্বর সময় (আনুমানিক)'), findsOneWidget);
      expect(find.text('স্থায়িত্ব'), findsOneWidget);
    });
  });

  group('5. Baby Journey & Age Calculations', () {
    test('Baby age string calculations in Bangla across different age brackets', () {
      final now = DateTime.now();

      // Newborn (0 days)
      final baby0 = BabyData(name: 'বেবি', birthDate: now, isSetup: true);
      expect(baby0.ageStringBangla, '০ দিন');

      // 15 days
      final baby15 = BabyData(name: 'বেবি', birthDate: now.subtract(const Duration(days: 15)), isSetup: true);
      expect(baby15.ageStringBangla, '১৫ দিন');

      // 4 months 12 days (~134 days)
      final baby4m = BabyData(name: 'আরিয়ান', birthDate: now.subtract(const Duration(days: 134)), isSetup: true);
      expect(baby4m.ageStringBangla.contains('৪ মাস'), true);

      // 1 year 2 months (~425 days)
      final baby1y = BabyData(name: 'তন্ময়', birthDate: now.subtract(const Duration(days: 425)), isSetup: true);
      expect(baby1y.ageStringBangla.contains('১ বছর'), true);
    });

    test('Baby Stages 6-stage continuum integrity', () {
      expect(allBabyStages.length, 6);
      expect(allBabyStages[0].id, 'newborn');
      expect(allBabyStages[1].id, '1_3_months');
      expect(allBabyStages[2].id, '4_6_months');
      expect(allBabyStages[3].id, '7_9_months');
      expect(allBabyStages[4].id, '10_12_months');
      expect(allBabyStages[5].id, '1_2_years');
    });

    testWidgets('BabyDevelopmentScreen allows browsing all 6 stages',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BabyDevelopmentScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('শিশুর বিকাশ গাইড'), findsOneWidget);
      expect(find.text('শারীরিক বৃদ্ধি ও ওজন'), findsOneWidget);
      expect(find.text('মানসিক ও দৃষ্টি বিকাশ'), findsOneWidget);
      expect(find.text('০–১ মাস'), findsOneWidget);
      expect(find.text('১–৩ মাস'), findsOneWidget);
      expect(find.text('৪–৬ মাস'), findsOneWidget);

      // Select another stage chip
      await tester.tap(find.text('১–৩ মাস'));
      await tester.pumpAndSettle();
      expect(find.text('১–৩ মাস'), findsWidgets);
    });
  });

  group('6. Local Persistence & CRUD Functional Verification', () {
    test('LocalStorageService save & retrieve roundtrip', () async {
      // Journey persistence
      await LocalStorageService.saveJourneyType(JourneyType.planning);
      expect(await LocalStorageService.getJourneyType(), JourneyType.planning);

      // Baby data persistence
      final testBaby = BabyData(
        name: 'সায়ান',
        birthDate: DateTime(2025, 10, 1),
        gender: 'boy',
        isSetup: true,
      );
      await LocalStorageService.saveBabyData(testBaby);
      final retrievedBaby = await LocalStorageService.getBabyData();
      expect(retrievedBaby?.name, 'সায়ান');
      expect(retrievedBaby?.isSetup, true);

      // Water count persistence
      await LocalStorageService.saveWaterGlasses(7);
      expect(await LocalStorageService.getWaterGlasses(), 7);
    });

    testWidgets('VaccinationScreen renders and lists vaccines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: VaccinationScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('টিকা ট্র্যাকার ও শিডিউল'), findsOneWidget);
      expect(find.text('সব টিকা'), findsOneWidget);
      expect(find.text('মায়ের টিকা'), findsOneWidget);
      expect(find.text('শিশুর ইপিআই'), findsOneWidget);
    });

    testWidgets('AppointmentsScreen renders and lists appointments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: AppointmentsScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('ডাক্তারের অ্যাপয়েন্টমেন্ট'), findsOneWidget);
      expect(find.text('নতুন যোগ করুন'), findsOneWidget);
    });

    testWidgets('TrackerHubScreen renders all tracker tiles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TrackerHubScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('ট্র্যাকার হাব'), findsOneWidget);
      expect(find.text('পিরিয়ড ট্র্যাকার'), findsOneWidget);
    });

    testWidgets('ProfileScreen renders with settings and dynamic stats',
        (WidgetTester tester) async {
      await AppState.instance.setUserName('সাদিয়া রহমান');
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('প্রোফাইল'), findsOneWidget);
      expect(find.text('সাদিয়া রহমান'), findsOneWidget);
      expect(find.text('আমার কার্যক্রম'), findsOneWidget);
      expect(find.text('সেটিংস'), findsOneWidget);
      expect(find.text('অ্যাপের তথ্য রিসেট করুন'), findsOneWidget);
    });
  });

  // =========================================================================
  // 7. CONTEXT-AWARE ARTICLES & DOCTOR CREDENTIALS AUDIT
  // =========================================================================
  group('7. Context-Aware Articles & Verified Doctor Credentials Audit', () {
    test('Dynamic week-by-week article switching across pregnancy weeks', () {
      // Week 7 (Weeks 5-8 bracket: Morning sickness, Fetal cardiac scan)
      final week7Articles = getArticlesForPregnancyWeek(7);
      expect(week7Articles.isNotEmpty, isTrue);
      expect(week7Articles.first.title.contains('৫ম থেকে ৮ম সপ্তাহ'), isTrue);
      expect(week7Articles.first.author, 'ডা. নাজনীন সুলতানা');
      expect(week7Articles.first.hospital.contains('মিটফোর্ড'), isTrue);

      // Week 10 (Weeks 9-12 bracket: NT Scan, organogenesis)
      final week10Articles = getArticlesForPregnancyWeek(10);
      expect(week10Articles.isNotEmpty, isTrue);
      expect(week10Articles.first.title.contains('৯ম থেকে ১২শ সপ্তাহ'), isTrue);
      expect(week10Articles.first.author, 'ডা. তানিয়া রহমান');
      expect(week10Articles.first.hospital.contains('BSMMU'), isTrue);

      // Week 15 (Weeks 13-16 bracket: 2nd Trimester energy, iron/calcium)
      final week15Articles = getArticlesForPregnancyWeek(15);
      expect(week15Articles.isNotEmpty, isTrue);
      expect(week15Articles.first.title.contains('১৩শ থেকে ১৬শ সপ্তাহ'), isTrue);
      expect(week15Articles.first.author, 'ডা. আয়েশা সিদ্দিকা');

      // Week 24 (Weeks 21-24 bracket: OGTT Gestational Diabetes screening)
      final week24Articles = getArticlesForPregnancyWeek(24);
      expect(week24Articles.isNotEmpty, isTrue);
      expect(week24Articles.first.title.contains('২১শ থেকে ২৪শ সপ্তাহ'), isTrue);
      expect(week24Articles.first.hospital.contains('বারডেম'), isTrue);

      // Week 35 (Weeks 34-36 bracket: Hospital bag preparation)
      final week35Articles = getArticlesForPregnancyWeek(35);
      expect(week35Articles.isNotEmpty, isTrue);
      expect(week35Articles.first.title.contains('৩৪শ থেকে ৩৬শ সপ্তাহ'), isTrue);

      // Week 39 (Weeks 37-40 bracket: Labor signs, warning indicators)
      final week39Articles = getArticlesForPregnancyWeek(39);
      expect(week39Articles.isNotEmpty, isTrue);
      expect(week39Articles.first.title.contains('৩৭শ থেকে ৪০শ সপ্তাহ'), isTrue);
    });

    test('All articles have authentic Bangladeshi doctor qualifications and hospitals', () {
      for (final article in allMomBeeArticles) {
        expect(article.author.isNotEmpty, isTrue);
        expect(article.doctorDegree.isNotEmpty, isTrue);
        expect(article.hospital.isNotEmpty, isTrue);
        expect(article.reviewedBy.isNotEmpty, isTrue);
        expect(article.paragraphs.length, greaterThanOrEqualTo(3));
      }
    });

    test('Baby stage article switching dynamically returns stage-specific articles', () {
      final newbornArticles = getArticlesForJourney(JourneyType.baby, babyStageId: 'newborn');
      expect(newbornArticles.isNotEmpty, isTrue);
      expect(newbornArticles.first.babyStageId, 'newborn');
      expect(newbornArticles.first.author, 'ডা. মারুফ হাসান');

      final stage1_3Articles = getArticlesForJourney(JourneyType.baby, babyStageId: '1_3_months');
      expect(stage1_3Articles.isNotEmpty, isTrue);
      expect(stage1_3Articles.first.babyStageId, '1_3_months');

      final stage4_6Articles = getArticlesForJourney(JourneyType.baby, babyStageId: '4_6_months');
      expect(stage4_6Articles.isNotEmpty, isTrue);
      expect(stage4_6Articles.first.babyStageId, '4_6_months');
    });
  });

  // =========================================================================
  // 8. LANGUAGE SWITCHING & PROFILE CUSTOMIZATION AUDIT
  // =========================================================================
  group('8. Language Switching & Profile Customization Audit', () {
    test('Language switching to English updates isEnglish, navigation strings, and digits', () async {
      await AppState.instance.setLanguage('English');
      expect(AppState.instance.language, 'English');
      expect(AppState.instance.isEnglish, isTrue);
      expect(AppLocalization.isEnglish, isTrue);
      expect(AppLocalization.navHome, 'Home');
      expect(AppLocalization.navTracker, 'Tracker');
      expect(AppLocalization.navLearn, 'Learn');
      expect(AppLocalization.navProfile, 'Profile');
      expect(toBanglaDigits(24), '24');
      expect(toBanglaDigits(168), '168');
      expect(JourneyType.pregnant.titleEnglish, 'I am Pregnant');

      // Switch back to Bangla
      await AppState.instance.setLanguage('বাংলা');
      expect(AppState.instance.language, 'বাংলা');
      expect(AppState.instance.isEnglish, isFalse);
      expect(AppLocalization.isEnglish, isFalse);
      expect(AppLocalization.navHome, 'হোম');
      expect(toBanglaDigits(24), '২৪');
    });

    test('Profile updates (name, age, avatar) persist and reflect in AppState and LocalStorage', () async {
      await AppState.instance.updateProfile(
        name: 'তানিয়া সুলতানা',
        age: 29,
        avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300',
      );

      expect(AppState.instance.userName, 'তানিয়া সুলতানা');
      expect(AppState.instance.userAge, 29);
      expect(AppState.instance.userAvatarUrl, 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300');

      // Verify persistence in LocalStorageService
      final savedName = await LocalStorageService.getUserName();
      final savedAge = await LocalStorageService.getUserAge();
      final savedAvatar = await LocalStorageService.getUserAvatarUrl();

      expect(savedName, 'তানিয়া সুলতানা');
      expect(savedAge, 29);
      expect(savedAvatar, 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=300');
    });
  });

  // =========================================================================
  // 9. PERIOD TRACKER COMPREHENSIVE CALCULATION & EDGE CASE AUDIT
  // =========================================================================
  group('9. Period Tracker Comprehensive Calculation & Edge Case Audit', () {
    test('Standard calculations across cycle lengths 21, 24, 28, 30, 32, and 35 days', () {
      final baseDate = DateTime(2026, 6, 1);

      // Cycle 21 days
      final c21 = PeriodData(lastPeriodDate: baseDate, cycleLength: 21, periodDuration: 4);
      expect(c21.cycleLength, 21);
      expect(c21.estimatedNextPeriod, DateTime(2026, 6, 22)); // LMP + 21
      expect(c21.estimatedOvulationDate, DateTime(2026, 6, 8)); // Next - 14
      expect(c21.ovulationCycleDay, 8); // (21 - 14) + 1
      expect(c21.fertileWindowStart, DateTime(2026, 6, 3)); // Ovulation - 5
      expect(c21.fertileWindowEnd, DateTime(2026, 6, 9)); // Ovulation + 1
      expect(c21.isOvulationDay(DateTime(2026, 6, 8)), isTrue);
      expect(c21.isFertileDay(DateTime(2026, 6, 3)), isTrue);
      expect(c21.isFertileDay(DateTime(2026, 6, 9)), isTrue);
      expect(c21.isPeriodDay(DateTime(2026, 6, 1)), isTrue);
      expect(c21.isPeriodDay(DateTime(2026, 6, 4)), isTrue);
      expect(c21.isPeriodDay(DateTime(2026, 6, 5)), isFalse);

      // Cycle 24 days
      final c24 = PeriodData(lastPeriodDate: baseDate, cycleLength: 24, periodDuration: 5);
      expect(c24.cycleLength, 24);
      expect(c24.estimatedNextPeriod, DateTime(2026, 6, 25)); // LMP + 24
      expect(c24.estimatedOvulationDate, DateTime(2026, 6, 11)); // Next - 14
      expect(c24.ovulationCycleDay, 11);
      expect(c24.fertileWindowStart, DateTime(2026, 6, 6));
      expect(c24.fertileWindowEnd, DateTime(2026, 6, 12));
      expect(c24.isOvulationDay(DateTime(2026, 6, 11)), isTrue);
      expect(c24.isFertileDay(DateTime(2026, 6, 6)), isTrue);
      expect(c24.isFertileDay(DateTime(2026, 6, 12)), isTrue);

      // Cycle 28 days
      final c28 = PeriodData(lastPeriodDate: baseDate, cycleLength: 28, periodDuration: 5);
      expect(c28.cycleLength, 28);
      expect(c28.estimatedNextPeriod, DateTime(2026, 6, 29)); // LMP + 28
      expect(c28.estimatedOvulationDate, DateTime(2026, 6, 15)); // Next - 14
      expect(c28.ovulationCycleDay, 15);
      expect(c28.fertileWindowStart, DateTime(2026, 6, 10));
      expect(c28.fertileWindowEnd, DateTime(2026, 6, 16));
      expect(c28.isOvulationDay(DateTime(2026, 6, 15)), isTrue);
      expect(c28.isFertileDay(DateTime(2026, 6, 10)), isTrue);
      expect(c28.isFertileDay(DateTime(2026, 6, 16)), isTrue);

      // Cycle 30 days
      final c30 = PeriodData(lastPeriodDate: baseDate, cycleLength: 30, periodDuration: 5);
      expect(c30.cycleLength, 30);
      expect(c30.estimatedNextPeriod, DateTime(2026, 7, 1)); // LMP + 30
      expect(c30.estimatedOvulationDate, DateTime(2026, 6, 17)); // Next - 14
      expect(c30.ovulationCycleDay, 17);
      expect(c30.fertileWindowStart, DateTime(2026, 6, 12));
      expect(c30.fertileWindowEnd, DateTime(2026, 6, 18));
      expect(c30.isOvulationDay(DateTime(2026, 6, 17)), isTrue);
      expect(c30.isFertileDay(DateTime(2026, 6, 12)), isTrue);
      expect(c30.isFertileDay(DateTime(2026, 6, 18)), isTrue);

      // Cycle 32 days
      final c32 = PeriodData(lastPeriodDate: baseDate, cycleLength: 32, periodDuration: 5);
      expect(c32.cycleLength, 32);
      expect(c32.estimatedNextPeriod, DateTime(2026, 7, 3)); // LMP + 32
      expect(c32.estimatedOvulationDate, DateTime(2026, 6, 19)); // Next - 14
      expect(c32.ovulationCycleDay, 19);
      expect(c32.fertileWindowStart, DateTime(2026, 6, 14));
      expect(c32.fertileWindowEnd, DateTime(2026, 6, 20));
      expect(c32.isOvulationDay(DateTime(2026, 6, 19)), isTrue);
      expect(c32.isFertileDay(DateTime(2026, 6, 14)), isTrue);
      expect(c32.isFertileDay(DateTime(2026, 6, 20)), isTrue);

      // Cycle 35 days
      final c35 = PeriodData(lastPeriodDate: baseDate, cycleLength: 35, periodDuration: 6);
      expect(c35.cycleLength, 35);
      expect(c35.estimatedNextPeriod, DateTime(2026, 7, 6)); // LMP + 35
      expect(c35.estimatedOvulationDate, DateTime(2026, 6, 22)); // Next - 14
      expect(c35.ovulationCycleDay, 22);
      expect(c35.fertileWindowStart, DateTime(2026, 6, 17));
      expect(c35.fertileWindowEnd, DateTime(2026, 6, 23));
      expect(c35.isOvulationDay(DateTime(2026, 6, 22)), isTrue);
      expect(c35.isFertileDay(DateTime(2026, 6, 17)), isTrue);
      expect(c35.isFertileDay(DateTime(2026, 6, 23)), isTrue);
    });

    test('Period duration handling (3 to 10 days boundaries)', () {
      final baseDate = DateTime(2026, 5, 10);

      // 3 days duration
      final d3 = PeriodData(lastPeriodDate: baseDate, cycleLength: 28, periodDuration: 3);
      expect(d3.isPeriodDay(DateTime(2026, 5, 10)), isTrue); // Day 1
      expect(d3.isPeriodDay(DateTime(2026, 5, 12)), isTrue); // Day 3
      expect(d3.isPeriodDay(DateTime(2026, 5, 13)), isFalse); // Day 4

      // 7 days duration
      final d7 = PeriodData(lastPeriodDate: baseDate, cycleLength: 28, periodDuration: 7);
      expect(d7.isPeriodDay(DateTime(2026, 5, 10)), isTrue);
      expect(d7.isPeriodDay(DateTime(2026, 5, 16)), isTrue); // Day 7
      expect(d7.isPeriodDay(DateTime(2026, 5, 17)), isFalse); // Day 8

      // 10 days duration
      final d10 = PeriodData(lastPeriodDate: baseDate, cycleLength: 28, periodDuration: 10);
      expect(d10.isPeriodDay(DateTime(2026, 5, 10)), isTrue);
      expect(d10.isPeriodDay(DateTime(2026, 5, 19)), isTrue); // Day 10
      expect(d10.isPeriodDay(DateTime(2026, 5, 20)), isFalse); // Day 11
    });

    test('Reactive state updates when cycle length or LMP date changes', () async {
      // Initialize with 28-day cycle, LMP 2026-04-01
      await AppState.instance.updatePeriodDetails(
        lastPeriodDate: DateTime(2026, 4, 1),
        cycleLength: 28,
        periodDuration: 5,
      );

      var p = AppState.instance.periodData;
      expect(p.cycleLength, 28);
      expect(p.estimatedNextPeriod, DateTime(2026, 4, 29));
      expect(p.estimatedOvulationDate, DateTime(2026, 4, 15));

      // User modifies cycle length to 32 days
      await AppState.instance.updatePeriodDetails(
        cycleLength: 32,
      );
      p = AppState.instance.periodData;
      expect(p.cycleLength, 32);
      expect(p.estimatedNextPeriod, DateTime(2026, 5, 3)); // Apr 1 + 32 = May 3
      expect(p.estimatedOvulationDate, DateTime(2026, 4, 19)); // May 3 - 14 = Apr 19

      // User modifies LMP date to 2026-04-10
      await AppState.instance.updatePeriodDetails(
        lastPeriodDate: DateTime(2026, 4, 10),
      );
      p = AppState.instance.periodData;
      expect(p.lastPeriodDate, DateTime(2026, 4, 10));
      expect(p.estimatedNextPeriod, DateTime(2026, 5, 12)); // Apr 10 + 32 = May 12
      expect(p.estimatedOvulationDate, DateTime(2026, 4, 28)); // May 12 - 14 = Apr 28
    });

    test('Edge case: Leap year 2024 (29 days in February)', () {
      final leapLmp = DateTime(2024, 2, 10);
      final leapCycle = PeriodData(lastPeriodDate: leapLmp, cycleLength: 28, periodDuration: 5);

      // In 2024 leap year: Feb 10 + 28 days = March 9, 2024 (Feb has 29 days: 19 days in Feb + 9 in Mar)
      expect(leapCycle.estimatedNextPeriod, DateTime(2024, 3, 9));
      // Ovulation: March 9 - 14 days = Feb 24, 2024
      expect(leapCycle.estimatedOvulationDate, DateTime(2024, 2, 24));
      expect(leapCycle.isOvulationDay(DateTime(2024, 2, 24)), isTrue);
      expect(leapCycle.isFertileDay(DateTime(2024, 2, 19)), isTrue); // Feb 24 - 5
      expect(leapCycle.isFertileDay(DateTime(2024, 2, 25)), isTrue); // Feb 24 + 1
    });

    test('Edge case: Non-leap year 2025 (28 days in February)', () {
      final nonLeapLmp = DateTime(2025, 2, 10);
      final nonLeapCycle = PeriodData(lastPeriodDate: nonLeapLmp, cycleLength: 28, periodDuration: 5);

      // In 2025 non-leap year: Feb 10 + 28 days = March 10, 2025 (Feb has 28 days: 18 days in Feb + 10 in Mar)
      expect(nonLeapCycle.estimatedNextPeriod, DateTime(2025, 3, 10));
      // Ovulation: March 10 - 14 days = Feb 24, 2025
      expect(nonLeapCycle.estimatedOvulationDate, DateTime(2025, 2, 24));
      expect(nonLeapCycle.isOvulationDay(DateTime(2025, 2, 24)), isTrue);
    });

    test('Edge case: Year boundary transition (December 2025 into January 2026)', () {
      final yearEndLmp = DateTime(2025, 12, 20);
      final yearEndCycle = PeriodData(lastPeriodDate: yearEndLmp, cycleLength: 28, periodDuration: 5);

      // Dec 20 + 28 days = Jan 17, 2026 (Dec has 31 days: 11 days in Dec + 17 in Jan)
      expect(yearEndCycle.estimatedNextPeriod, DateTime(2026, 1, 17));
      // Ovulation: Jan 17 - 14 days = Jan 3, 2026
      expect(yearEndCycle.estimatedOvulationDate, DateTime(2026, 1, 3));
      // Fertile window: Jan 3 - 5 days = Dec 29, 2025 through Jan 4, 2026
      expect(yearEndCycle.fertileWindowStart, DateTime(2025, 12, 29));
      expect(yearEndCycle.fertileWindowEnd, DateTime(2026, 1, 4));

      expect(yearEndCycle.isOvulationDay(DateTime(2026, 1, 3)), isTrue);
      expect(yearEndCycle.isFertileDay(DateTime(2025, 12, 29)), isTrue);
      expect(yearEndCycle.isFertileDay(DateTime(2026, 1, 4)), isTrue);
      expect(yearEndCycle.isPeriodDay(DateTime(2025, 12, 20)), isTrue);
      expect(yearEndCycle.isPeriodDay(DateTime(2026, 1, 17)), isTrue); // Next cycle period day 1
    });

    test('Calendar multi-cycle recurrence for past and future month navigation', () {
      final lmp = DateTime(2026, 6, 1);
      final p = PeriodData(lastPeriodDate: lmp, cycleLength: 28, periodDuration: 5);

      // Cycle 1: 2026-06-01 to 2026-06-28
      expect(p.isPeriodDay(DateTime(2026, 6, 1)), isTrue);
      expect(p.isOvulationDay(DateTime(2026, 6, 15)), isTrue);

      // Cycle 2 (future month navigation): 2026-06-29 to 2026-07-26
      expect(p.isPeriodDay(DateTime(2026, 6, 29)), isTrue);
      expect(p.isOvulationDay(DateTime(2026, 7, 13)), isTrue);

      // Cycle 0 (past month navigation): 2026-05-04 to 2026-05-31
      expect(p.isPeriodDay(DateTime(2026, 5, 4)), isTrue);
      expect(p.isOvulationDay(DateTime(2026, 5, 18)), isTrue);
    });
  });

  // =========================================================================
  // 10. MOMBEE YOUTUBE VIDEO LIBRARY & URL CONNECTION AUDIT
  // =========================================================================
  group('10. MomBee YouTube Video Library & URL Connection Audit', () {
    test('All 24 authentic MomBee videos have valid YouTube URLs and non-empty titles', () {
      expect(mombeeVideos.length, 24);

      for (final video in mombeeVideos) {
        expect(video.title.isNotEmpty, isTrue);
        expect(video.category.isNotEmpty, isTrue);
        expect(video.youtubeUrl.startsWith('https://youtu.be/'), isTrue);
        expect(video.videoId.length, 11); // Standard 11-character YouTube ID
        expect(video.thumbnailUrl, contains(video.videoId));

        // URL parsing validation
        final parsedUri = Uri.tryParse(video.youtubeUrl);
        expect(parsedUri, isNotNull);
        expect(parsedUri!.scheme, 'https');
        expect(parsedUri.host, 'youtu.be');
      }
    });

    test('Specific YouTube links mapping verification', () {
      expect(mombeeVideos[0].youtubeUrl, 'https://youtu.be/YC9tQ0RJhP0');
      expect(mombeeVideos[1].youtubeUrl, 'https://youtu.be/Lgyzo0t6KVk');
      expect(mombeeVideos[2].youtubeUrl, 'https://youtu.be/TMzWkui9KTU');
      expect(mombeeVideos[3].youtubeUrl, 'https://youtu.be/cVjAW7XZc5E');
      expect(mombeeVideos[4].youtubeUrl, 'https://youtu.be/bvIFvTUzkHQ');
      expect(mombeeVideos[5].youtubeUrl, 'https://youtu.be/qFAiEyQD-Ik');
      expect(mombeeVideos[6].youtubeUrl, 'https://youtu.be/mHMQCswVe9g');
      expect(mombeeVideos[7].youtubeUrl, 'https://youtu.be/5FLx_YaKy5I');
      expect(mombeeVideos[8].youtubeUrl, 'https://youtu.be/JUi26C-uEvI');
      expect(mombeeVideos[9].youtubeUrl, 'https://youtu.be/1y_WNUV_2lI');
      expect(mombeeVideos[10].youtubeUrl, 'https://youtu.be/nHjoAQOI_to');
      expect(mombeeVideos[11].youtubeUrl, 'https://youtu.be/MyUN8Ah2OaQ');
      expect(mombeeVideos[12].youtubeUrl, 'https://youtu.be/rW4jsUFL7U8');
      expect(mombeeVideos[13].youtubeUrl, 'https://youtu.be/3Y6Xi_Cs3zk');
      expect(mombeeVideos[14].youtubeUrl, 'https://youtu.be/wu7Gg4IYj4E');
      expect(mombeeVideos[15].youtubeUrl, 'https://youtu.be/dB7Z2RPJNnM');
      expect(mombeeVideos[16].youtubeUrl, 'https://youtu.be/_rD0smbi2dQ');
      expect(mombeeVideos[17].youtubeUrl, 'https://youtu.be/dB7Z2RPJNnM');
      expect(mombeeVideos[18].youtubeUrl, 'https://youtu.be/fle9PzounNQ');
      expect(mombeeVideos[19].youtubeUrl, 'https://youtu.be/e1Ze3_rTkZI');
      expect(mombeeVideos[20].youtubeUrl, 'https://youtu.be/bgHRde-PXTM');
      expect(mombeeVideos[21].youtubeUrl, 'https://youtu.be/DXfU4DEVkBA');
      expect(mombeeVideos[22].youtubeUrl, 'https://youtu.be/QBxy5Pd2ImA');
      expect(mombeeVideos[23].youtubeUrl, 'https://youtu.be/XHavriIZM-E');
    });

    testWidgets('VideoLibraryScreen renders and displays category chips',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VideoLibraryScreen())),
      );
      await tester.pumpAndSettle();

      // Verify category chips exist
      expect(find.text('সব'), findsOneWidget);
      expect(find.text('গর্ভাবস্থা'), findsOneWidget);
      expect(find.text('প্যারেন্টিং'), findsOneWidget);
      expect(find.text('শিশুর যত্ন'), findsOneWidget);
      expect(find.text('পুষ্টি ও খাবার'), findsOneWidget);

      // Verify featured video title renders (both in featured card and in feed)
      expect(find.text(mombeeVideos[0].title), findsWidgets);

      // Tap 'প্যারেন্টিং' filter
      await tester.tap(find.text('প্যারেন্টিং'));
      await tester.pumpAndSettle();

      // Should show parenting videos
      expect(find.text(mombeeVideos[1].title), findsWidgets);
    });

    test('Verify all 24 YouTube URLs have valid syntax and valid YouTube video ID patterns', () {
      final youtubeIdPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');
      for (final video in mombeeVideos) {
        final uri = Uri.parse(video.youtubeUrl);
        expect(uri.scheme, 'https');
        expect(uri.host, 'youtu.be');
        expect(video.videoId, matches(youtubeIdPattern));
        expect(video.thumbnailUrl, 'https://img.youtube.com/vi/${video.videoId}/hqdefault.jpg');
      }
    });
  });

  group('7. Real Device Testing Issues: Period Tracker State Sync & Android Responsiveness/SafeArea', () {
    test('Period Tracker data updates and recalculates accurately', () async {
      final baseDate = DateTime(2026, 9, 1);
      final initialData = PeriodData(
        lastPeriodDate: baseDate,
        cycleLength: 28,
        periodDuration: 5,
        loggedPeriodDays: List.generate(5, (i) => baseDate.add(Duration(days: i))),
      );

      // Verify initial next period, ovulation, and fertile window
      expect(initialData.estimatedNextPeriod, DateTime(2026, 9, 29));
      expect(initialData.ovulationCycleDay, 15); // 28 - 14 + 1
      expect(initialData.fertileStartCycleDay, 10);
      expect(initialData.fertileEndCycleDay, 16);

      // Now update cycleLength to 32
      await AppState.instance.updatePeriodDetails(
        lastPeriodDate: baseDate,
        cycleLength: 32,
        periodDuration: 5,
      );

      final updatedState = AppState.instance.periodData;
      expect(updatedState.cycleLength, 32);
      expect(updatedState.estimatedNextPeriod, DateTime(2026, 10, 3));
      expect(updatedState.ovulationCycleDay, 19); // 32 - 14 + 1
      expect(updatedState.fertileStartCycleDay, 14);
      expect(updatedState.fertileEndCycleDay, 20);

      // Now update periodDuration to 3
      await AppState.instance.updatePeriodDetails(
        periodDuration: 3,
      );

      final durationUpdatedState = AppState.instance.periodData;
      expect(durationUpdatedState.periodDuration, 3);
      expect(durationUpdatedState.loggedPeriodDays.length, 3);
      expect(durationUpdatedState.isPeriodDay(DateTime(2026, 9, 1)), isTrue);
      expect(durationUpdatedState.isPeriodDay(DateTime(2026, 9, 2)), isTrue);
      expect(durationUpdatedState.isPeriodDay(DateTime(2026, 9, 3)), isTrue);
      expect(durationUpdatedState.isPeriodDay(DateTime(2026, 9, 4)), isFalse);
      expect(durationUpdatedState.isPeriodDay(DateTime(2026, 9, 5)), isFalse);

      // Now update LMP to a new date
      final newLmp = DateTime(2026, 9, 10);
      await AppState.instance.updatePeriodDetails(
        lastPeriodDate: newLmp,
      );

      final lmpUpdated = AppState.instance.periodData;
      expect(lmpUpdated.normalizedLmp, DateTime(2026, 9, 10));
      expect(lmpUpdated.loggedPeriodDays.first, DateTime(2026, 9, 10));
      expect(lmpUpdated.loggedPeriodDays.length, 3);
      expect(lmpUpdated.isPeriodDay(DateTime(2026, 9, 1)), isFalse);
      expect(lmpUpdated.isPeriodDay(DateTime(2026, 9, 10)), isTrue);
    });

    testWidgets('Google Pixel 6a form factor: LearnHub and VideoLibrary have AppBar with status bar clearance',
        (WidgetTester tester) async {
      // Simulate Google Pixel 6a: 1080x2340 physical, 2.625 dpr -> 411.4 x 891.4dp
      // 126 physical px top padding / 2.625 = 48.0dp status bar
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 2.625;
      tester.view.padding = const FakeViewPadding(top: 126, bottom: 63);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.view.resetPadding();
      });

      // 1. LearnHubScreen renders Scaffold and AppBar with status bar clearance
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LearnHubScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final learnAppBar = find.byType(AppBar);
      expect(learnAppBar, findsOneWidget);
      expect(find.text('জ্ঞান ভাণ্ডার'), findsOneWidget);

      final titleTop = tester.getTopLeft(find.text('জ্ঞান ভাণ্ডার')).dy;
      expect(titleTop, greaterThanOrEqualTo(48.0));

      // 2. VideoLibraryScreen renders Scaffold and AppBar with status bar clearance
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const VideoLibraryScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final videoAppBar = find.byType(AppBar);
      expect(videoAppBar, findsOneWidget);
      expect(find.text('ভিডিও লাইব্রেরি'), findsOneWidget);

      final videoTitleTop = tester.getTopLeft(find.text('ভিডিও লাইব্রেরি')).dy;
      expect(videoTitleTop, greaterThanOrEqualTo(48.0));
    });

    testWidgets('PeriodTrackerScreen hero banner has direct edit chip and opens modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PeriodTrackerScreen()),
      );
      await tester.pumpAndSettle();

      // Find the hero banner edit chip
      expect(find.text('এডিট'), findsOneWidget);

      // Tap edit button to open edit modal
      await tester.tap(find.text('এডিট'));
      await tester.pumpAndSettle();

      // Modal is visible
      expect(find.text('মাসিক চক্রের তথ্য পরিবর্তন করুন'), findsOneWidget);
      expect(find.text('সংরক্ষণ করুন'), findsOneWidget);
    });

    testWidgets('Period tracker modal does not overflow on small height / keyboard constraint',
        (WidgetTester tester) async {
      // Set constrained height e.g. 400dp
      tester.view.physicalSize = const Size(1080, 1000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(home: PeriodTrackerScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      // Verify modal content rendered without throwing RenderFlex overflow
      expect(find.text('মাসিক চক্রের তথ্য পরিবর্তন করুন'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Stat cards do not overflow on narrow 320dp screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 1136); // 320 x 568dp
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      FlutterErrorDetails? caughtDetails;
      final oldHandler = FlutterError.onError;
      FlutterError.onError = (details) {
        caughtDetails = details;
      };

      await tester.pumpWidget(
        const MaterialApp(home: PeriodTrackerScreen()),
      );
      await tester.pumpAndSettle();
      FlutterError.onError = oldHandler;

      expect(caughtDetails, isNull);
      expect(find.byType(FittedBox), findsWidgets);
    });
  });

  // =========================================================================
  // 11. FIRST-TIME USER NAME SETUP & CLEAN INSTALL STATE AUDIT
  // =========================================================================
  group('11. First-Time User Name Setup & Clean Install State Audit', () {
    testWidgets('UserNameSetupScreen renders with Bangla prompt, hint, and button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const UserNameSetupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('স্বাগতম! আপনাকে কী নামে ডাকবো?'), findsOneWidget);
      expect(find.text('আপনার নাম লিখুন (যেমন: সাদিয়া)'), findsOneWidget);
      expect(find.text('এগিয়ে যান'), findsOneWidget);
      expect(
          find.textContaining('আপনার তথ্য সম্পূর্ণ আপনার ডিভাইসে সংরক্ষিত থাকবে'),
          findsOneWidget);
    });

    testWidgets('UserNameSetupScreen validates empty input and shows error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const UserNameSetupScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap submit button without typing any name
      await tester.tap(find.text('এগিয়ে যান'));
      await tester.pumpAndSettle();

      expect(find.text('অনুগ্রহ করে আপনার নাম লিখুন'), findsOneWidget);
    });

    testWidgets(
        'UserNameSetupScreen submits valid name, updates AppState, and navigates',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          initialRoute: '/user-setup',
          routes: {
            '/user-setup': (_) => const UserNameSetupScreen(),
            '/onboarding': (_) =>
                const Scaffold(body: Text('অনবোর্ডিং স্ক্রিন')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Enter valid user name
      await tester.enterText(find.byType(TextField), 'ফারহানা শারমিন');
      await tester.pumpAndSettle();

      await tester.tap(find.text('এগিয়ে যান'));
      await tester.pumpAndSettle();

      expect(AppState.instance.userName, 'ফারহানা শারমিন');
      expect(find.text('অনবোর্ডিং স্ক্রিন'), findsOneWidget);
    });

    test('Clean fresh-install state defaults are truly empty without mock data',
        () async {
      await AppState.instance.resetAllUserData();

      expect(AppState.instance.userName, isEmpty);
      expect(AppState.instance.hasCompletedInitialSetup, isFalse);
      expect(AppState.instance.waterGlasses, 0);
      expect(AppState.instance.appointments, isEmpty);
      expect(AppState.instance.periodData.isSetup, isFalse);
      expect(AppState.instance.babyData.isSetup, isFalse);

      // Verify all default vaccines start unchecked
      for (final v in defaultVaccinesList) {
        expect(v.isCompleted, isFalse,
            reason: 'Vaccine ${v.id} should be uncompleted by default');
      }
    });

    testWidgets('ProfileScreen shows fallback text when user name is not set',
        (WidgetTester tester) async {
      await AppState.instance.resetAllUserData();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('মমবি সদস্য'), findsOneWidget);
      expect(find.text('সাদিয়া রহমান'), findsNothing);
    });
  });

  // =========================================================================
  // 12. PROFILE RESET APP DATA DIALOG & FLOW AUDIT
  // =========================================================================
  group('12. Profile Reset App Data Dialog & Flow Audit', () {
    testWidgets(
        'Reset App Data dialog renders and cancels safely without wiping data',
        (WidgetTester tester) async {
      await AppState.instance.setUserName('সুমাইয়া');
      expect(AppState.instance.userName, 'সুমাইয়া');

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll until reset button is visible and tap
      await tester.scrollUntilVisible(
        find.text('অ্যাপের তথ্য রিসেট করুন'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('অ্যাপের তথ্য রিসেট করুন'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('অ্যাপের তথ্য রিসেট করবেন?'), findsOneWidget);
      expect(find.textContaining('আপনার নাম, বয়স, নির্ধারিত পর্যায়'),
          findsOneWidget);

      // Cancel dialog
      await tester.tap(find.text('বাতিল'));
      await tester.pumpAndSettle();

      // Verify dialog dismissed and name still preserved
      expect(find.text('অ্যাপের তথ্য রিসেট করবেন?'), findsNothing);
      expect(AppState.instance.userName, 'সুমাইয়া');
    });

    testWidgets(
        'Confirming Reset App Data clears state and navigates to /user-setup',
        (WidgetTester tester) async {
      await AppState.instance.setUserName('সুমাইয়া');
      await AppState.instance.completeInitialSetup();
      expect(AppState.instance.userName, 'সুমাইয়া');
      expect(AppState.instance.hasCompletedInitialSetup, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          routes: {
            '/user-setup': (_) =>
                const Scaffold(body: Text('ইউজার সেটআপ স্ক্রিন')),
          },
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll until reset button is visible and tap
      await tester.scrollUntilVisible(
        find.text('অ্যাপের তথ্য রিসেট করুন'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('অ্যাপের তথ্য রিসেট করুন'));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('তথ্য রিসেট করুন'));
      await tester.pumpAndSettle();

      // Verify state was wiped and redirected
      expect(AppState.instance.userName, isEmpty);
      expect(AppState.instance.hasCompletedInitialSetup, isFalse);
      expect(find.text('ইউজার সেটআপ স্ক্রিন'), findsOneWidget);
    });
  });

  // =========================================================================
  // 13. MULTI-DEVICE RESPONSIVE UI AUDIT (320dp to 480dp)
  // =========================================================================
  group('13. Multi-Device Responsive UI Audit', () {
    const testDevices = <String, Size>{
      'iPhone SE / Small Screen (320 x 568)': Size(320, 568),
      'Standard Phone (360 x 640)': Size(360, 640),
      'Google Pixel 6a (411.4 x 891.4)': Size(411.4, 891.4),
      'Modern Tall Device (412 x 915)': Size(412, 915),
      'Large Device (480 x 1066)': Size(480, 1066),
    };

    for (final entry in testDevices.entries) {
      testWidgets('UserNameSetupScreen responsive rendering on ${entry.key}',
          (WidgetTester tester) async {
        tester.view.physicalSize =
            Size(entry.value.width * 2, entry.value.height * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        FlutterErrorDetails? error;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => error = details;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const UserNameSetupScreen(),
          ),
        );
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        expect(error, isNull, reason: 'Layout overflowed on ${entry.key}');
        expect(find.text('স্বাগতম! আপনাকে কী নামে ডাকবো?'), findsOneWidget);
        expect(find.text('এগিয়ে যান'), findsOneWidget);
      });

      testWidgets('ProfileScreen responsive rendering on ${entry.key}',
          (WidgetTester tester) async {
        tester.view.physicalSize =
            Size(entry.value.width * 2, entry.value.height * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        FlutterErrorDetails? error;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => error = details;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ProfileScreen(),
          ),
        );
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        expect(error, isNull,
            reason: 'ProfileScreen layout overflowed on ${entry.key}');
        expect(find.text('অ্যাপের তথ্য রিসেট করুন'), findsOneWidget);
      });
    }
  });

  group('14. Dynamic Baby Development Visuals & Single Source of Truth Audit', () {
    test('All 40 weeks map deterministically to 10 developmental stages', () {
      for (int week = 1; week <= 40; week++) {
        final stage = FetalStageVisualData.forWeek(week);
        expect(stage.stageNumber, inInclusiveRange(1, 10));
        expect(week, greaterThanOrEqualTo(stage.weekStart));
        expect(week, lessThanOrEqualTo(stage.weekEnd));
        expect(stage.stageTitleBangla.isNotEmpty, isTrue);
        expect(stage.descriptionBangla.isNotEmpty, isTrue);
        expect(stage.milestonesBangla.isNotEmpty, isTrue);
      }

      // Explicit Milestone Weeks Verification
      // Week 8 -> Stage 2
      final stageW8 = FetalStageVisualData.forWeek(8);
      expect(stageW8.stageNumber, 2);
      expect(stageW8.stageTitleBangla, 'প্রাথমিক অঙ্গ গঠন ও হৃদস্পন্দন');
      expect(stageW8.stageBadgeBangla, 'ক্ষুদ্র ভ্রূণ পর্যায়');

      // Week 12 -> Stage 3
      final stageW12 = FetalStageVisualData.forWeek(12);
      expect(stageW12.stageNumber, 3);
      expect(stageW12.stageTitleBangla, 'ফিটাস পর্যায় ও মুখের স্পষ্ট রূপরেখা');
      expect(stageW12.stageBadgeBangla, '১ম ট্রাইমেস্টার সমাপনী');

      // Week 22 -> Stage 6
      final stageW22 = FetalStageVisualData.forWeek(22);
      expect(stageW22.stageNumber, 6);
      expect(stageW22.stageTitleBangla, 'ভায়াবিলিটি মাইলফলক ও ইন্দ্রিয় সক্রিয়তা');
      expect(stageW22.stageBadgeBangla, 'জীবনীশক্তি সঞ্চার');

      // Week 30 -> Stage 8
      final stageW30 = FetalStageVisualData.forWeek(30);
      expect(stageW30.stageNumber, 8);
      expect(stageW30.stageTitleBangla, 'দ্রুত বৃদ্ধি ও ত্বকের চর্বি সঞ্চয়');
      expect(stageW30.stageBadgeBangla, 'শারীরিক পরিপক্বতা');

      // Week 36 -> Stage 9
      final stageW36 = FetalStageVisualData.forWeek(36);
      expect(stageW36.stageNumber, 9);
      expect(stageW36.stageTitleBangla, 'প্রসবকালীন অবস্থান ও ফুসফুসের পূর্ণতা');
      expect(stageW36.stageBadgeBangla, 'প্রসব প্রস্তুতি পর্ব');

      // Week 40 -> Stage 10
      final stageW40 = FetalStageVisualData.forWeek(40);
      expect(stageW40.stageNumber, 10);
      expect(stageW40.stageTitleBangla, 'পূর্ণ মেয়াদী সুস্থ শিশু (প্রস্তুত)');
      expect(stageW40.stageBadgeBangla, 'পূর্ণ মেয়াদী (Full Term)');
    });

    testWidgets('FetalDevelopmentVisual renders stage details, fruit size, and medical disclaimer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: FetalDevelopmentVisual(weekNumber: 22),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Stage 6 header and title
      expect(find.textContaining('স্টেজ ৬'), findsOneWidget);
      expect(find.text('জীবনীশক্তি সঞ্চার'), findsOneWidget);
      expect(find.text('ভায়াবিলিটি মাইলফলক ও ইন্দ্রিয় সক্রিয়তা'), findsOneWidget);

      // Verify Baby Size Comparison
      expect(find.textContaining('পেঁপে'), findsOneWidget);

      // Verify Milestones
      expect(find.textContaining('ফুসফুসে অ্যালভিওলাই'), findsOneWidget);

      // Verify Medical Safety Disclaimer
      expect(
        find.text(
            'চিত্রটি আনুমানিক ভ্রূণের বৃদ্ধির চিত্ররূপ এবং এটি সরাসরি আল্ট্রাসনোগ্রাফি বা নির্ভুল ডায়াগনস্টিক স্ক্যান নয়।'),
        findsOneWidget,
      );
    });

    testWidgets('Single Source of Truth: LMP synchronization across Home, Tracker, and Profile',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.pregnant);

      // Set LMP = 21 weeks and 3 days ago (150 days) -> exactly Week 22, Day 4
      final lmpDate = DateTime.now().subtract(const Duration(days: 150));
      await AppState.instance.updatePregnancyWithLMP(lmpDate);

      expect(AppState.instance.currentPregnancyWeek, 22);
      expect(AppState.instance.currentFetalStage.stageNumber, 6);

      // 1. Home Screen check
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: HomePregnantScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((w) =>
              w is RichText && w.text.toPlainText().contains('২২ সপ্তাহে')),
          findsOneWidget);
      expect(find.text('২২তম সপ্তাহ সম্পর্কে জানুন'), findsOneWidget);
      expect(find.text('ভায়াবিলিটি মাইলফলক ও ইন্দ্রিয় সক্রিয়তা'), findsOneWidget);

      // 2. Pregnancy Tracker Screen check
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const PregnancyTrackerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((w) =>
              w is RichText && w.text.toPlainText().contains('২২ সপ্তাহ')),
          findsOneWidget);
      expect(find.text('২২তম সপ্তাহের পূর্ণ গাইড দেখুন'), findsOneWidget);
      expect(find.text('ভায়াবিলিটি মাইলফলক ও ইন্দ্রিয় সক্রিয়তা'), findsOneWidget);

      // 3. Profile Screen check
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('২২'), findsWidgets);
    });

    testWidgets('Reactive UI updates when LMP changes without restart',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.pregnant);

      // Set Week 8 initially (52 days ago)
      final lmp8Weeks = DateTime.now().subtract(const Duration(days: 52));
      await AppState.instance.updatePregnancyWithLMP(lmp8Weeks);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: HomePregnantScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((w) =>
              w is RichText && w.text.toPlainText().contains('৮ সপ্তাহে')),
          findsOneWidget);
      expect(find.text('৮তম সপ্তাহ সম্পর্কে জানুন'), findsOneWidget);
      expect(find.text('প্রাথমিক অঙ্গ গঠন ও হৃদস্পন্দন'), findsOneWidget);

      // Dynamically update LMP to Week 36 (248 days ago)
      final lmp36Weeks = DateTime.now().subtract(const Duration(days: 248));
      await AppState.instance.updatePregnancyWithLMP(lmp36Weeks);
      await tester.pumpAndSettle();

      // Verify immediate reactive update to Week 36
      expect(
          find.byWidgetPredicate((w) =>
              w is RichText && w.text.toPlainText().contains('৩৬ সপ্তাহে')),
          findsOneWidget);
      expect(find.text('৩৬তম সপ্তাহ সম্পর্কে জানুন'), findsOneWidget);
      expect(find.text('প্রসবকালীন অবস্থান ও ফুসফুসের পূর্ণতা'), findsOneWidget);
      expect(find.text('৮তম সপ্তাহ সম্পর্কে জানুন'), findsNothing);
    });

    // Multi-Device Responsive Layout Tests for FetalDevelopmentVisual
    final testDevices = <String, Size>{
      'iPhone SE / Small Screen (320 x 568)': const Size(320, 568),
      'Standard Phone (360 x 640)': const Size(360, 640),
      'Google Pixel 6a (411.4 x 891.4)': const Size(411.4, 891.4),
      'Modern Tall Device (412 x 915)': const Size(412, 915),
      'Large Device (480 x 1066)': const Size(480, 1066),
    };

    for (final entry in testDevices.entries) {
      testWidgets('FetalDevelopmentVisual responsive rendering on ${entry.key}',
          (WidgetTester tester) async {
        tester.view.physicalSize =
            Size(entry.value.width * 2, entry.value.height * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        FlutterErrorDetails? error;
        final oldHandler = FlutterError.onError;
        FlutterError.onError = (details) => error = details;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: FetalDevelopmentVisual(weekNumber: 22),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        FlutterError.onError = oldHandler;

        expect(error, isNull,
            reason: 'FetalDevelopmentVisual layout overflowed on ${entry.key}');
        expect(find.text('ভায়াবিলিটি মাইলফলক ও ইন্দ্রিয় সক্রিয়তা'), findsOneWidget);
      });
    }

    // =========================================================================
    // 12. MEDICALLY ACCURATE ANATOMICAL FETAL VISUALS & OPEN-LICENSE CREDITS AUDIT
    // =========================================================================
    test('All 10 stages have valid asset paths and proper developmental boundaries', () {
      for (int stage = 1; stage <= 10; stage++) {
        final stageData = FetalStageVisualData.allStages.firstWhere((s) => s.stageNumber == stage);
        expect(stageData.defaultAssetPath, 'assets/images/fetal/stage_$stage.png');
        expect(stageData.milestonesBangla.isNotEmpty, isTrue);
        expect(stageData.descriptionBangla.isNotEmpty, isTrue);
      }
    });

    test('Late pregnancy stages (Weeks 33-40) map to cephalic presentation and full-term maturity', () {
      // Week 35 -> Stage 9 (Cephalic Positioning & Lung Maturity)
      final week35Stage = FetalStageVisualData.forWeek(35);
      expect(week35Stage.stageNumber, 9);
      expect(week35Stage.stageTitleEnglish, 'Cephalic Positioning & Lung Maturity');

      // Week 40 -> Stage 10 (Full Term Baby - Ready for Birth)
      final week40Stage = FetalStageVisualData.forWeek(40);
      expect(week40Stage.stageNumber, 10);
      expect(week40Stage.stageTitleEnglish, 'Full Term Baby - Ready for Birth');
    });

    testWidgets('Profile screen displays Medical Illustration Credits & Licensing dialog',
        (WidgetTester tester) async {
      await AppState.instance.setLanguage('বাংলা');
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to settings section
      final creditsItem = find.text('মেডিকেল ইলাস্ট্রেশন ও লাইসেন্স');
      expect(creditsItem, findsOneWidget);

      await tester.ensureVisible(creditsItem);
      await tester.tap(creditsItem);
      await tester.pumpAndSettle();

      // Verify dialog content contains CC attributions
      expect(find.text('Blausen Medical Communications'), findsOneWidget);
      expect(find.text('OpenStax Anatomy & Physiology 2e'), findsOneWidget);
      expect(find.textContaining('CC BY 3.0'), findsOneWidget);
      expect(find.textContaining('CC BY 4.0'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('ঠিক আছে'));
      await tester.pumpAndSettle();
      expect(find.text('Blausen Medical Communications'), findsNothing);
    });
  });

  group('15. Text-First Baby Development Card Verification (No Avatars / Silhouettes)', () {
    testWidgets('Baby Development Card displays text-first information without avatars',
        (WidgetTester tester) async {
      await AppState.instance.setLanguage('বাংলা');
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: FetalDevelopmentVisual(weekNumber: 22),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Fruit / Object comparison
      expect(find.textContaining('পেঁপে'), findsOneWidget);
      expect(find.text('শিশুর আকারের তুলনা'), findsOneWidget);

      // Verify approximate length and weight with "আনুমানিক"
      expect(find.text('দৈর্ঘ্য (আনুমানিক)'), findsOneWidget);
      expect(find.text('ওজন (আনুমানিক)'), findsOneWidget);
      expect(find.textContaining('২৭.৮ সেমি'), findsOneWidget);
      expect(find.textContaining('৪৩০ গ্রাম'), findsOneWidget);

      // Verify developmental milestones
      expect(find.text('এই সপ্তাহের প্রধান বিকাশ'), findsOneWidget);
      expect(find.text('এই ধাপে শিশুর সক্ষমতা ও পরিবর্তন'), findsOneWidget);

      // Verify Medical safety disclaimer
      expect(
        find.textContaining('চিত্রটি আনুমানিক ভ্রূণের বৃদ্ধির চিত্ররূপ'),
        findsOneWidget,
      );
    });
  });

  group('16. Verified Daily Care Message & Authentic MomBee Advice Audit', () {
    testWidgets('DailyMessageCard displays verified MomBee care guidance without doctor quotes',
        (WidgetTester tester) async {
      await AppState.instance.setLanguage('বাংলা');
      await AppState.instance.setJourney(JourneyType.pregnant);

      final message = DailyMessageService.getDailyMessageForCurrentProfile();

      expect(message.title.isNotEmpty, isTrue);
      expect(message.message.isNotEmpty, isTrue);
      expect(message.careTip.isNotEmpty, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: DailyMessageCard(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(message.title), findsOneWidget);
      expect(find.textContaining('আজকের বার্তা'), findsOneWidget);
    });

    test('DailyMessageService returns context-aware tips across journeys', () async {
      await AppState.instance.setJourney(JourneyType.pregnant);
      final pregMsg = DailyMessageService.getDailyMessageForCurrentProfile();
      expect(pregMsg.title.isNotEmpty, isTrue);
      expect(pregMsg.message.isNotEmpty, isTrue);

      await AppState.instance.setJourney(JourneyType.baby);
      final babyMsg = DailyMessageService.getDailyMessageForCurrentProfile();
      expect(babyMsg.title.isNotEmpty, isTrue);
      expect(babyMsg.message.isNotEmpty, isTrue);

      await AppState.instance.setJourney(JourneyType.planning);
      final planMsg = DailyMessageService.getDailyMessageForCurrentProfile();
      expect(planMsg.title.isNotEmpty, isTrue);
      expect(planMsg.message.isNotEmpty, isTrue);
    });
  });

  group('17. Animated Water Tracker, Metaphor Disclaimer & Date Rollover Audit', () {
    testWidgets('WaterTrackerModal displays dual mL/L readout, metaphor disclaimer, and controls',
        (WidgetTester tester) async {
      await AppState.instance.setLanguage('বাংলা');
      await AppState.instance.resetTodayWater();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: WaterTrackerModal()),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('পানি পানের ট্র্যাকার'), findsOneWidget);
      expect(find.text('প্রতীকী চিত্র: জলযোজন ট্র্যাকিংয়ের শৈল্পিক রূপক'), findsOneWidget);
      expect(find.textContaining('মি.লি.'), findsOneWidget);
      expect(find.textContaining('লিটার'), findsWidgets);

      final addBtn = find.textContaining('+১ গ্লাস');
      expect(addBtn, findsOneWidget);
      await tester.ensureVisible(addBtn);
      await tester.tap(addBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(AppState.instance.waterGlasses, 1);
      expect(AppState.instance.totalWaterMl, 250);
      expect(find.textContaining('১ / ১০ গ্লাস'), findsOneWidget);

      final undoBtn = find.textContaining('-১ গ্লাস');
      expect(undoBtn, findsOneWidget);
      await tester.ensureVisible(undoBtn);
      await tester.tap(undoBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(AppState.instance.waterGlasses, 0);
      expect(AppState.instance.totalWaterMl, 0);

      for (int i = 0; i < 10; i++) {
        await tester.ensureVisible(addBtn);
        await tester.tap(addBtn);
        await tester.pump();
      }
      await tester.pump(const Duration(milliseconds: 100));

      expect(AppState.instance.waterGlasses, 10);
      expect(AppState.instance.totalWaterMl, 2500);
      expect(AppState.instance.isWaterTargetReached, isTrue);
      expect(find.textContaining('অভিনন্দন'), findsOneWidget);

      final resetBtn = find.text('আজকের রিসেট');
      await tester.ensureVisible(resetBtn);
      await tester.tap(resetBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('আজকের হিসাব রিসেট করবেন?'), findsOneWidget);
      await tester.tap(find.text('হ্যাঁ, রিসেট করুন'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(AppState.instance.waterGlasses, 0);
      expect(AppState.instance.totalWaterMl, 0);
    });

    test('LocalStorageService rolls over water intake on new calendar date', () async {
      SharedPreferences.setMockInitialValues({});
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayKey =
          '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mombee_water_date', yesterdayKey);
      await prefs.setInt('mombee_water_glasses', 8);

      final todayCount = await LocalStorageService.getWaterGlasses();
      expect(todayCount, 0);

      await LocalStorageService.saveWaterGlasses(5);
      final todaySavedCount = await LocalStorageService.getWaterGlasses();
      expect(todaySavedCount, 5);
    });
  });

  group('18. Personalized Local Notification Preferences Audit', () {
    testWidgets('Profile screen allows toggling local notification categories',
        (WidgetTester tester) async {
      await AppState.instance.setLanguage('বাংলা');
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final notifPrefItem = find.text(AppLocalization.notifications);
      expect(notifPrefItem, findsOneWidget);

      await tester.ensureVisible(notifPrefItem);
      await tester.tap(notifPrefItem);
      await tester.pumpAndSettle();

      expect(find.text('নোটিফিকেশন ও রিমাইন্ডার সেটিংস'), findsOneWidget);
      expect(find.text('সকল নোটিফিকেশন চালু রাখুন'), findsOneWidget);
      expect(find.text('পানি পানের তাগিদ'), findsOneWidget);
      expect(find.text('দৈনিক যত্ন বার্তা'), findsOneWidget);
      expect(find.text('ডাক্তারের অ্যাপয়েন্টমেন্ট'), findsOneWidget);
      expect(find.text('টিকা ও ইমিউনাইজেশন'), findsOneWidget);

      final waterSwitch = find.byType(Switch).at(1);
      await tester.tap(waterSwitch);
      await tester.pumpAndSettle();
      expect(AppState.instance.notifWater, isFalse);

      await tester.ensureVisible(find.text('সম্পন্ন'));
      await tester.tap(find.text('সম্পন্ন'));
      await tester.pumpAndSettle();
    });
  });

  group('19. Multi-Device Responsive UI Audit for Enhanced Components (320dp to 480dp)', () {
    final componentTestDevices = <String, Size>{
      'iPhone SE / Small Screen (320 x 568)': const Size(320, 568),
      'Standard Phone (360 x 640)': const Size(360, 640),
      'Google Pixel 6a (411.4 x 891.4)': const Size(411.4, 891.4),
      'Modern Tall Device (412 x 915)': const Size(412, 915),
      'Large Device (480 x 1066)': const Size(480, 1066),
    };

    for (final entry in componentTestDevices.entries) {
      testWidgets('WaterTrackerModal responsive rendering on ${entry.key}',
          (WidgetTester tester) async {
        tester.view.physicalSize =
            Size(entry.value.width * 2, entry.value.height * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: WaterTrackerModal()),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.text('পানি পানের ট্র্যাকার'), findsOneWidget);
      });

      testWidgets('DailyMessageCard responsive rendering on ${entry.key}',
          (WidgetTester tester) async {
        tester.view.physicalSize =
            Size(entry.value.width * 2, entry.value.height * 2);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: DailyMessageCard(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.textContaining('আজকের বার্তা'), findsOneWidget);
      });
    }
  });

  group('20. Pregnancy Week + Day Counter, Real-time Sync & Notification Audit Tests', () {
    test('Pregnancy week + day calculation and Bangla formatting for various dates', () {
      final now = DateTime.now();

      // 157 days ago -> 22 completed weeks, 3 additional days
      final p157 = PregnancyData(
        isSetup: true,
        lmpDate: now.subtract(const Duration(days: 157)),
      );
      expect(p157.calculateTotalDays(now), 157);
      expect(p157.calculateCompletedWeeks(now), 22);
      expect(p157.calculateAdditionalDays(now), 3);
      expect(p157.getProgressAgeText(now), '২২ সপ্তাহ ৩ দিন চলছে');
      expect(p157.getTotalDaysText(now), 'মোট ১৫৭ দিন');

      // 154 days ago -> 22 completed weeks, 0 additional days
      final p154 = PregnancyData(
        isSetup: true,
        lmpDate: now.subtract(const Duration(days: 154)),
      );
      expect(p154.calculateTotalDays(now), 154);
      expect(p154.calculateCompletedWeeks(now), 22);
      expect(p154.calculateAdditionalDays(now), 0);
      expect(p154.getProgressAgeText(now), '২২ সপ্তাহ ০ দিন চলছে');
      expect(p154.getTotalDaysText(now), 'মোট ১৫৪ দিন');

      // 215 days ago -> 30 completed weeks, 5 additional days
      final p215 = PregnancyData(
        isSetup: true,
        lmpDate: now.subtract(const Duration(days: 215)),
      );
      expect(p215.calculateTotalDays(now), 215);
      expect(p215.calculateCompletedWeeks(now), 30);
      expect(p215.calculateAdditionalDays(now), 5);
      expect(p215.getProgressAgeText(now), '৩০ সপ্তাহ ৫ দিন চলছে');
      expect(p215.getTotalDaysText(now), 'মোট ২১৫ দিন');
    });

    test('Calendar date advancement updates pregnancy day count automatically', () {
      final baseDate = DateTime(2026, 1, 1);
      final p = PregnancyData(
        isSetup: true,
        lmpDate: baseDate.subtract(const Duration(days: 157)),
      );

      // On day 157
      expect(p.getProgressAgeText(baseDate), '২২ সপ্তাহ ৩ দিন চলছে');
      expect(p.getTotalDaysText(baseDate), 'মোট ১৫৭ দিন');

      // Advancing calendar by 1 day -> day 158 (22w 4d)
      final tomorrow = baseDate.add(const Duration(days: 1));
      expect(p.calculateTotalDays(tomorrow), 158);
      expect(p.getProgressAgeText(tomorrow), '২২ সপ্তাহ ৪ দিন চলছে');
      expect(p.getTotalDaysText(tomorrow), 'মোট ১৫৮ দিন');

      // Advancing calendar by 4 days -> day 161 (23w 0d)
      final fourDaysLater = baseDate.add(const Duration(days: 4));
      expect(p.calculateTotalDays(fourDaysLater), 161);
      expect(p.calculateCompletedWeeks(fourDaysLater), 23);
      expect(p.calculateAdditionalDays(fourDaysLater), 0);
      expect(p.getProgressAgeText(fourDaysLater), '২৩ সপ্তাহ ০ দিন চলছে');
      expect(p.getTotalDaysText(fourDaysLater), 'মোট ১৬১ দিন');
    });

    testWidgets('Home and Tracker screens display week+day and total days badges',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await AppState.instance.setJourney(JourneyType.pregnant);
      final lmp = DateTime.now().subtract(const Duration(days: 157));
      await AppState.instance.updatePregnancyWithLMP(lmp);

      // 1. Home screen test
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: HomePregnantScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('২২ সপ্তাহ ৩ দিন চলছে'), findsOneWidget);
      expect(find.text('মোট ১৫৭ দিন'), findsOneWidget);

      // 2. Tracker screen test
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const PregnancyTrackerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('২২ সপ্তাহ ৩ দিন চলছে'), findsOneWidget);
      expect(find.text('মোট ১৫৭ দিন'), findsOneWidget);
      // Bento card for elapsed days
      await tester.scrollUntilVisible(find.text('১৫৭ দিন'), 300);
      expect(find.text('১৫৭ দিন'), findsOneWidget);
    });

    testWidgets('Real-time LMP modification synchronizes badges across UI without restart',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.pregnant);
      final lmpInitial = DateTime.now().subtract(const Duration(days: 157));
      await AppState.instance.updatePregnancyWithLMP(lmpInitial);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: HomePregnantScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('২২ সপ্তাহ ৩ দিন চলছে'), findsOneWidget);
      expect(find.text('মোট ১৫৭ দিন'), findsOneWidget);

      // Change LMP to 215 days ago (30w 5d)
      final lmpUpdated = DateTime.now().subtract(const Duration(days: 215));
      await AppState.instance.updatePregnancyWithLMP(lmpUpdated);
      await tester.pumpAndSettle();

      // UI updates reactively without restart
      expect(find.text('৩০ সপ্তাহ ৫ দিন চলছে'), findsOneWidget);
      expect(find.text('মোট ২১৫ দিন'), findsOneWidget);
    });

    testWidgets('Unconfigured pregnancy state displays setup prompt without fake values',
        (WidgetTester tester) async {
      await AppState.instance.setJourney(JourneyType.pregnant);
      // Reset pregnancy setup to false
      await AppState.instance.resetAllUserData();
      await AppState.instance.setJourney(JourneyType.pregnant);

      expect(AppState.instance.isPregnancySetup, isFalse);

      // Home Screen: shows setup banner, no counter badge
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: HomePregnantScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('সেটআপ শুরু করুন'), findsWidgets);
      expect(find.text('২২ সপ্তাহ ৩ দিন চলছে'), findsNothing);
      expect(find.text('মোট ১৫৭ দিন'), findsNothing);

      // Tracker Screen: shows setup card, no hero calculation badges
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const PregnancyTrackerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('গর্ভধারণের তথ্য সেটআপ করুন'), findsOneWidget);
      expect(find.text('২২ সপ্তাহ ৩ দিন চলছে'), findsNothing);
      expect(find.text('মোট ১৫৭ দিন'), findsNothing);
    });

    test('Notification preferences and settings persistence across toggles', () async {
      // Master toggle off
      await AppState.instance.setNotificationsEnabled(false);
      expect(AppState.instance.notificationsEnabled, isFalse);

      // Master toggle on
      await AppState.instance.setNotificationsEnabled(true);
      expect(AppState.instance.notificationsEnabled, isTrue);

      // Category toggles
      await AppState.instance.setNotifWater(false);
      expect(AppState.instance.notifWater, isFalse);
      await AppState.instance.setNotifWater(true);
      expect(AppState.instance.notifWater, isTrue);

      await AppState.instance.setNotifDailyCare(false);
      expect(AppState.instance.notifDailyCare, isFalse);
      await AppState.instance.setNotifDailyCare(true);
      expect(AppState.instance.notifDailyCare, isTrue);

      await AppState.instance.setNotifVaccines(false);
      expect(AppState.instance.notifVaccines, isFalse);
      await AppState.instance.setNotifVaccines(true);
      expect(AppState.instance.notifVaccines, isTrue);

      await AppState.instance.setNotifAppointments(false);
      expect(AppState.instance.notifAppointments, isFalse);
      await AppState.instance.setNotifAppointments(true);
      expect(AppState.instance.notifAppointments, isTrue);
    });

    test('Notification service scheduling and cancellation methods execute safely', () async {
      final notifService = NotificationService.instance;
      await notifService.initialize();

      // Test scheduling routines
      await notifService.scheduleDailyCareReminder();
      await notifService.scheduleWaterReminders();
      await notifService.cancelWaterReminders();

      // Test appointment reminder scheduling and cancellation
      final futureDate = DateTime.now().add(const Duration(days: 3));
      final testApp = Appointment(
        id: 'test_app_1',
        doctorName: 'ডাঃ আয়েশা',
        location: 'ঢাকা মেডিকেল কলেজ হাসপাতাল',
        dateTime: futureDate,
      );
      await notifService.scheduleAppointmentReminder(testApp);
      await notifService.cancelAppointmentReminder('test_app_1');

      // Test vaccine reminder scheduling and cancellation
      final testVac = VaccineItem(
        id: 'test_vac_1',
        name: 'টিটি (TT) ১ম ডোজ',
        targetAudience: 'গর্ভকালীন',
        schedule: 'গর্ভাবস্থার ২০ সপ্তাহ',
        description: 'টিটেনাস প্রতিরোধে সহায়ক',
      );
      await notifService.scheduleVaccineReminder(testVac);
      await notifService.cancelVaccineReminder('test_vac_1');

      // Test cancel all
      await notifService.cancelAll();

      expect(notifService, isNotNull);
    });
  });

  group('21. Production Local Notification Flow & Hierarchy Refinements Audit', () {
    test('NotificationLogItem model serializes and deserializes correctly', () {
      final now = DateTime(2026, 9, 29, 10, 30);
      final item = NotificationLogItem(
        id: 'test_item_1',
        title: 'টেস্ট নোটিফিকেশন',
        body: 'এটি একটি টেস্ট বার্তা।',
        category: NotificationCategory.water,
        timestamp: now,
        isRead: false,
      );

      final json = item.toJson();
      expect(json['id'], 'test_item_1');
      expect(json['title'], 'টেস্ট নোটিফিকেশন');
      expect(json['category'], 'water');
      expect(json['isRead'], isFalse);

      final restored = NotificationLogItem.fromJson(json);
      expect(restored.id, item.id);
      expect(restored.title, item.title);
      expect(restored.body, item.body);
      expect(restored.category, item.category);
      expect(restored.timestamp, item.timestamp);
      expect(restored.isRead, isFalse);

      final updated = restored.copyWith(isRead: true);
      expect(updated.isRead, isTrue);
      expect(updated.id, restored.id);
    });

    test(
        'LocalStorageService persists water intervals, custom times, and permission prompt state',
        () async {
      await LocalStorageService.saveWaterReminderInterval(2);
      expect(await LocalStorageService.getWaterReminderInterval(), 2);

      await LocalStorageService.saveWaterReminderStartHour(9);
      expect(await LocalStorageService.getWaterReminderStartHour(), 9);

      await LocalStorageService.saveWaterReminderEndHour(21);
      expect(await LocalStorageService.getWaterReminderEndHour(), 21);

      await LocalStorageService.saveDailyCareTime(8, 45);
      expect(await LocalStorageService.getDailyCareHour(), 8);
      expect(await LocalStorageService.getDailyCareMinute(), 45);

      await LocalStorageService.saveNotificationPermissionPrompted(true);
      expect(
          await LocalStorageService.hasPromptedNotificationPermission(), isTrue);

      final testLogs = [
        NotificationLogItem(
          id: 'log_1',
          title: 'পানি পান',
          body: 'পানি পান করুন',
          category: NotificationCategory.water,
          timestamp: DateTime.now(),
        ),
      ];
      await LocalStorageService.saveNotificationHistory(testLogs);
      final savedLogs = await LocalStorageService.getNotificationHistory();
      expect(savedLogs.length, 1);
      expect(savedLogs.first.id, 'log_1');
    });

    test(
        'NotificationService calculates configurable hourly water reminder slots',
        () {
      final notifService = NotificationService.instance;

      // Default: interval 1h from 10 to 20 -> 11 slots
      final hours1 = notifService.getWaterReminderHours(
          interval: 1, startHour: 10, endHour: 20);
      expect(hours1, [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
      expect(hours1.length, 11);

      // Interval 2h from 10 to 20 -> 6 slots
      final hours2 = notifService.getWaterReminderHours(
          interval: 2, startHour: 10, endHour: 20);
      expect(hours2, [10, 12, 14, 16, 18, 20]);
      expect(hours2.length, 6);

      // Interval 3h from 10 to 20 -> 4 slots
      final hours3 = notifService.getWaterReminderHours(
          interval: 3, startHour: 10, endHour: 20);
      expect(hours3, [10, 13, 16, 19]);
      expect(hours3.length, 4);
    });

    test(
        'AppState water logging triggers auto-suppression when target is reached',
        () async {
      await AppState.instance
          .setWaterConfig(glassSizeMl: 250, dailyTargetMl: 1000);
      await AppState.instance.resetTodayWater();
      expect(AppState.instance.isWaterTargetReached, isFalse);

      await AppState.instance.addWaterGlass();
      await AppState.instance.addWaterGlass();
      await AppState.instance.addWaterGlass();
      expect(AppState.instance.waterGlasses, 3);
      expect(AppState.instance.isWaterTargetReached, isFalse);

      // 4th glass reaches target
      await AppState.instance.addWaterGlass();
      expect(AppState.instance.waterGlasses, 4);
      expect(AppState.instance.isWaterTargetReached, isTrue);

      // Removing a glass re-enables reminders
      await AppState.instance.removeWaterGlass();
      expect(AppState.instance.waterGlasses, 3);
      expect(AppState.instance.isWaterTargetReached, isFalse);
    });

    test(
        'Notification history management: add, unread count, and mark as read',
        () async {
      final notifService = NotificationService.instance;
      await notifService.clearHistory();
      expect(notifService.unreadCount, 0);

      final item1 = NotificationLogItem(
        id: 'hist_1',
        title: 'পানি পানের তাগিদ',
        body: 'শরীর সুস্থ রাখুন',
        category: NotificationCategory.water,
        timestamp: DateTime.now(),
        isRead: false,
      );
      final item2 = NotificationLogItem(
        id: 'hist_2',
        title: 'দৈনিক যত্ন',
        body: 'পুষ্টিকর খাদ্য গ্রহণ করুন',
        category: NotificationCategory.dailyCare,
        timestamp: DateTime.now(),
        isRead: false,
      );

      await notifService.addHistoryItem(item1);
      await notifService.addHistoryItem(item2);
      expect(notifService.history.length, 2);
      expect(notifService.unreadCount, 2);

      await notifService.markAsRead('hist_1');
      expect(notifService.unreadCount, 1);

      await notifService.markAllAsRead();
      expect(notifService.unreadCount, 0);
    });

    testWidgets(
        'NotificationPermissionDialog renders with Bengali rationale and buttons',
        (WidgetTester tester) async {
      await LocalStorageService.saveNotificationPermissionPrompted(false);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: NotificationPermissionDialog()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('নোটিফিকেশন রিমাইন্ডার চালু করুন'), findsOneWidget);
      expect(find.textContaining('সঠিক সময়ে পানি পানের তাগিদ'), findsOneWidget);
      expect(find.text('অনুমতি দিন'), findsOneWidget);
      expect(find.text('পরে করব'), findsOneWidget);

      await tester.tap(find.text('অনুমতি দিন'));
      await tester.pumpAndSettle();
      expect(
          await LocalStorageService.hasPromptedNotificationPermission(), isTrue);
    });

    testWidgets(
        'NotificationCenterScreen renders filter chips, notification cards, and mark all read',
        (WidgetTester tester) async {
      final notifService = NotificationService.instance;
      await notifService.clearHistory();
      await notifService.addHistoryItem(
        NotificationLogItem(
          id: 'nc_test_water',
          title: 'পানি পান করুন',
          body: 'এক গ্লাস পানি পান করার সময় হয়েছে।',
          category: NotificationCategory.water,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );
      await notifService.addHistoryItem(
        NotificationLogItem(
          id: 'nc_test_care',
          title: 'দৈনিক যত্ন বার্তা',
          body: 'আজকের সুস্থতা নির্দেশিকা পড়ুন।',
          category: NotificationCategory.dailyCare,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: NotificationCenterScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('নোটিফিকেশন সেন্টার'), findsOneWidget);
      expect(find.text('সবগুলো'), findsOneWidget);
      expect(find.text('দৈনিক যত্ন'), findsOneWidget);
      expect(find.text('পানি পান'), findsOneWidget);
      expect(find.text('পানি পান করুন'), findsOneWidget);
      expect(find.text('দৈনিক যত্ন বার্তা'), findsOneWidget);
      expect(find.text('সব পঠিত'), findsOneWidget);

      // Tap 'সব পঠিত'
      await tester.tap(find.text('সব পঠিত'));
      await tester.pumpAndSettle();
      expect(AppState.instance.unreadNotificationCount, 0);

      // Tap filter chip 'পানি পান'
      await tester.tap(find.text('পানি পান'));
      await tester.pumpAndSettle();
      expect(find.text('পানি পান করুন'), findsOneWidget);
      expect(find.text('দৈনিক যত্ন বার্তা'), findsNothing);
    });

    testWidgets(
        'HomeScreen bell icon shows unread count badge and opens NotificationCenterScreen',
        (WidgetTester tester) async {
      await LocalStorageService.saveNotificationPermissionPrompted(true);
      final notifService = NotificationService.instance;
      await notifService.clearHistory();
      await notifService.addHistoryItem(
        NotificationLogItem(
          id: 'badge_test',
          title: 'নতুন নোটিফিকেশন',
          body: 'পরীক্ষামূলক বার্তা',
          category: NotificationCategory.general,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify unread badge shows '1'
      expect(find.text('1'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

      // Tap bell icon
      await tester.tap(find.byIcon(Icons.notifications_none_rounded));
      await tester.pumpAndSettle();

      // Verify NotificationCenterScreen opened
      expect(find.text('নোটিফিকেশন সেন্টার'), findsOneWidget);
    });

    testWidgets(
        'HomePregnantScreen layout displays refined hierarchy without overflow',
        (WidgetTester tester) async {
      await AppState.instance.setUserName('মারিয়া');
      final lmp = DateTime.now().subtract(const Duration(days: 157));
      await AppState.instance.updatePregnancyWithLMP(lmp);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: HomePregnantScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Greeting
      expect(find.textContaining('সুপ্রভাত, মারিয়া'), findsOneWidget);
      // 2. Pregnancy week and total days counters
      expect(
          find.text(AppState.instance.pregnancyProgressAgeText), findsOneWidget);
      expect(
          find.text(AppState.instance.pregnancyTotalDaysText), findsOneWidget);
      // 3. DailyMessageCard
      expect(find.byType(DailyMessageCard), findsOneWidget);
      // 4. Quick trackers grid
      expect(find.text('পিরিয়ড\nট্র্যাকার'), findsOneWidget);
      expect(find.text('প্রেগন্যান্সি\nট্র্যাকার'), findsOneWidget);
    });
  });
}

