import 'dart:io';
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
import 'package:mombee_app/screens/tracker/baby_development_screen.dart';
import 'package:mombee_app/screens/tracker/appointments_screen.dart';
import 'package:mombee_app/screens/tracker/vaccination_screen.dart';
import 'package:mombee_app/screens/tracker/tracker_hub_screen.dart';
import 'package:mombee_app/screens/profile/profile_screen.dart';
import 'package:mombee_app/models/video.dart';
import 'package:mombee_app/screens/video/video_library_screen.dart';
import 'package:mombee_app/services/local_storage_service.dart';
import 'package:mombee_app/services/app_localization.dart';
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
      await tester.pumpWidget(
        const MaterialApp(home: ProfileScreen()),
      );
      await tester.pumpAndSettle();
      expect(find.text('প্রোফাইল'), findsOneWidget);
      expect(find.text('সাদিয়া রহমান'), findsOneWidget);
      expect(find.text('আমার কার্যক্রম'), findsOneWidget);
      expect(find.text('সেটিংস'), findsOneWidget);
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
}
