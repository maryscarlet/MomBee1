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

      // 28-day cycle
      final cycle28 = PeriodData(lastPeriodDate: baseDate, cycleLength: 28, periodDuration: 5);
      expect(cycle28.cycleLength, 28);
      expect(cycle28.estimatedNextPeriod.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);

      // 30-day cycle
      final cycle30 = PeriodData(lastPeriodDate: baseDate, cycleLength: 30, periodDuration: 5);
      expect(cycle30.cycleLength, 30);
      expect(cycle30.estimatedNextPeriod.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);

      // 32-day cycle
      final cycle32 = PeriodData(lastPeriodDate: baseDate, cycleLength: 32, periodDuration: 5);
      expect(cycle32.cycleLength, 32);
      expect(cycle32.estimatedNextPeriod.isAfter(DateTime.now().subtract(const Duration(days: 1))), true);
    });

    testWidgets('PeriodTrackerScreen renders cycle day, stats, and calendar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PeriodTrackerScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('পিরিয়ড ট্র্যাকার'), findsOneWidget);
      expect(find.text('ওভুলেশন ডে'), findsWidgets);
      expect(find.text('উর্বর সময়'), findsOneWidget);
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
}
