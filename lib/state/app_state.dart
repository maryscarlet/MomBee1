import 'package:flutter/material.dart';
import '../models/journey_type.dart';
import '../models/pregnancy_data.dart';
import '../models/baby_data.dart';
import '../models/period_data.dart';
import '../models/appointment.dart';
import '../models/vaccine_item.dart';
import '../services/local_storage_service.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _hasCompletedInitialSetup = false;
  bool get hasCompletedInitialSetup => _hasCompletedInitialSetup;

  // ---------------- ACTIVE JOURNEY ----------------
  JourneyType _selectedJourney = JourneyType.pregnant;
  JourneyType get selectedJourney => _selectedJourney;

  // ---------------- PREGNANCY STATE ----------------
  PregnancyData _pregnancyData = const PregnancyData(isSetup: false);
  PregnancyData get pregnancyData => _pregnancyData;
  bool get isPregnancySetup => _pregnancyData.isSetup;
  int get currentPregnancyWeek => _pregnancyData.calculateCurrentWeek();
  int get currentPregnancyDay => _pregnancyData.calculateCurrentDay();
  int get currentTrimester => _pregnancyData.calculateTrimester();
  double get pregnancyProgress => _pregnancyData.calculateProgress();
  DateTime get estimatedDueDate => _pregnancyData.estimatedDueDate;
  int get remainingDays => _pregnancyData.calculateRemainingDays();

  // ---------------- BABY STATE ----------------
  BabyData _babyData = BabyData(
    birthDate: DateTime.now(),
    isSetup: false,
  );
  BabyData get babyData => _babyData;
  bool get isBabySetup => _babyData.isSetup;

  // ---------------- PERIOD STATE ----------------
  PeriodData _periodData = PeriodData(
    lastPeriodDate: DateTime.now(),
    cycleLength: 28,
    periodDuration: 5,
    isSetup: false,
  );
  PeriodData get periodData => _periodData;

  // ---------------- WATER STATE ----------------
  int _waterGlasses = 0;
  final int dailyWaterGoal = 10;
  int get waterGlasses => _waterGlasses;
  double get waterProgress => (_waterGlasses / dailyWaterGoal).clamp(0.0, 1.0);

  // ---------------- APPOINTMENTS ----------------
  List<Appointment> _appointments = [];
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  // ---------------- VACCINATIONS ----------------
  List<VaccineItem> _vaccines = [];
  List<VaccineItem> get vaccines => List.unmodifiable(_vaccines);

  // ---------------- LANGUAGE ----------------
  String _language = 'বাংলা';
  String get language => _language;
  bool get isEnglish => _language == 'English';

  // ---------------- USER PROFILE ----------------
  String _userName = '';
  int _userAge = 26;
  String _userAvatarUrl =
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80';

  String get userName => _userName;
  int get userAge => _userAge;
  String get userAvatarUrl => _userAvatarUrl;

  // ---------------- DAILY MESSAGE DISMISSAL ----------------
  String? _dailyMessageDismissedDate;
  bool get isDailyMessageDismissedToday {
    final today = DateTime.now().toIso8601String().split('T').first;
    return _dailyMessageDismissedDate == today;
  }

  // ---------------- INITIALIZATION ----------------
  Future<void> initialize() async {
    if (_isInitialized) return;

    final savedJourney = await LocalStorageService.getJourneyType();
    if (savedJourney != null) {
      _selectedJourney = savedJourney;
    }

    final savedPregnancy = await LocalStorageService.getPregnancyData();
    if (savedPregnancy != null) {
      _pregnancyData = savedPregnancy;
    }

    final savedBaby = await LocalStorageService.getBabyData();
    if (savedBaby != null) {
      _babyData = savedBaby;
    }

    _periodData = await LocalStorageService.getPeriodData();
    _waterGlasses = await LocalStorageService.getWaterGlasses();
    _appointments = await LocalStorageService.getAppointments();
    _vaccines = await LocalStorageService.getVaccines();
    _language = await LocalStorageService.getLanguage();
    _dailyMessageDismissedDate =
        await LocalStorageService.getDailyMessageDismissedDate();

    _hasCompletedInitialSetup =
        await LocalStorageService.isInitialSetupComplete();

    final savedName = await LocalStorageService.getUserName();
    if (savedName != null && savedName.isNotEmpty) {
      _userName = savedName;
    }

    final savedAge = await LocalStorageService.getUserAge();
    if (savedAge != null && savedAge > 0) {
      _userAge = savedAge;
    }

    final savedAvatar = await LocalStorageService.getUserAvatarUrl();
    if (savedAvatar != null && savedAvatar.isNotEmpty) {
      _userAvatarUrl = savedAvatar;
    }

    _isInitialized = true;
    notifyListeners();
  }

  // ---------------- DAILY MESSAGE ACTIONS ----------------
  Future<void> dismissDailyMessage() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    _dailyMessageDismissedDate = today;
    await LocalStorageService.saveDailyMessageDismissedDate(today);
    notifyListeners();
  }

  Future<void> resetDailyMessageDismissal() async {
    _dailyMessageDismissedDate = null;
    await LocalStorageService.saveDailyMessageDismissedDate('');
    notifyListeners();
  }

  // ---------------- JOURNEY ACTIONS ----------------
  Future<void> setJourney(JourneyType journey) async {
    _selectedJourney = journey;
    await LocalStorageService.saveJourneyType(journey);
    notifyListeners();
  }

  // ---------------- PREGNANCY ACTIONS ----------------
  Future<void> updatePregnancyWithLMP(DateTime lmp) async {
    _pregnancyData = PregnancyData(
      lmpDate: lmp,
      eddDate: lmp.add(const Duration(days: 280)),
      isSetup: true,
    );
    await LocalStorageService.savePregnancyData(_pregnancyData);
    notifyListeners();
  }

  Future<void> updatePregnancyWithEDD(DateTime edd) async {
    _pregnancyData = PregnancyData(
      lmpDate: edd.subtract(const Duration(days: 280)),
      eddDate: edd,
      isSetup: true,
    );
    await LocalStorageService.savePregnancyData(_pregnancyData);
    notifyListeners();
  }

  Future<void> resetPregnancySetup() async {
    _pregnancyData = const PregnancyData(isSetup: false);
    await LocalStorageService.savePregnancyData(_pregnancyData);
    notifyListeners();
  }

  // ---------------- BABY ACTIONS ----------------
  Future<void> updateBabyData({
    required String name,
    required DateTime birthDate,
    String gender = 'unspecified',
  }) async {
    _babyData = BabyData(
      name: name,
      birthDate: birthDate,
      gender: gender,
      isSetup: true,
    );
    await LocalStorageService.saveBabyData(_babyData);
    notifyListeners();
  }

  Future<void> resetBabySetup() async {
    _babyData = BabyData(
      birthDate: DateTime.now(),
      isSetup: false,
    );
    await LocalStorageService.saveBabyData(_babyData);
    notifyListeners();
  }

  // ---------------- PERIOD ACTIONS ----------------
  Future<void> updatePeriodDetails({
    DateTime? lastPeriodDate,
    int? cycleLength,
    int? periodDuration,
  }) async {
    final newLmp = lastPeriodDate != null
        ? DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day)
        : _periodData.normalizedLmp;
    final newCycleLength = cycleLength ?? _periodData.cycleLength;
    final newPeriodDuration = periodDuration ?? _periodData.periodDuration;

    // When LMP or duration is updated, synchronize baseline logged period days
    List<DateTime> updatedLoggedDays;
    if (lastPeriodDate != null || periodDuration != null) {
      updatedLoggedDays = List.generate(
        newPeriodDuration,
        (i) => DateTime(newLmp.year, newLmp.month, newLmp.day + i),
      );
    } else {
      updatedLoggedDays = _periodData.loggedPeriodDays;
    }

    _periodData = _periodData.copyWith(
      lastPeriodDate: newLmp,
      cycleLength: newCycleLength,
      periodDuration: newPeriodDuration,
      loggedPeriodDays: updatedLoggedDays,
      isSetup: true,
    );
    await LocalStorageService.savePeriodData(_periodData);
    notifyListeners();
  }

  Future<void> togglePeriodDay(DateTime date) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final list = List<DateTime>.from(_periodData.loggedPeriodDays);
    final existingIndex = list.indexWhere((d) =>
        d.year == cleanDate.year &&
        d.month == cleanDate.month &&
        d.day == cleanDate.day);

    if (existingIndex >= 0) {
      list.removeAt(existingIndex);
    } else {
      list.add(cleanDate);
    }

    _periodData = _periodData.copyWith(
      loggedPeriodDays: list,
      isSetup: true,
    );
    await LocalStorageService.savePeriodData(_periodData);
    notifyListeners();
  }

  // ---------------- WATER ACTIONS ----------------
  Future<void> addWaterGlass() async {
    if (_waterGlasses < 20) {
      _waterGlasses++;
      await LocalStorageService.saveWaterGlasses(_waterGlasses);
      notifyListeners();
    }
  }

  Future<void> removeWaterGlass() async {
    if (_waterGlasses > 0) {
      _waterGlasses--;
      await LocalStorageService.saveWaterGlasses(_waterGlasses);
      notifyListeners();
    }
  }

  // ---------------- APPOINTMENT ACTIONS ----------------
  Future<void> addAppointment(Appointment app) async {
    _appointments.add(app);
    await LocalStorageService.saveAppointments(_appointments);
    notifyListeners();
  }

  Future<void> editAppointment(Appointment updated) async {
    final index = _appointments.indexWhere((a) => a.id == updated.id);
    if (index >= 0) {
      _appointments[index] = updated;
      await LocalStorageService.saveAppointments(_appointments);
      notifyListeners();
    }
  }

  Future<void> deleteAppointment(String id) async {
    _appointments.removeWhere((a) => a.id == id);
    await LocalStorageService.saveAppointments(_appointments);
    notifyListeners();
  }

  // ---------------- VACCINE ACTIONS ----------------
  Future<void> toggleVaccineCompletion(String id) async {
    final index = _vaccines.indexWhere((v) => v.id == id);
    if (index >= 0) {
      final current = _vaccines[index];
      final updated = current.copyWith(
        isCompleted: !current.isCompleted,
        completedDate: !current.isCompleted ? DateTime.now() : null,
      );
      _vaccines[index] = updated;
      await LocalStorageService.saveVaccines(_vaccines);
      notifyListeners();
    }
  }

  // ---------------- USER PROFILE ACTIONS ----------------
  Future<void> setUserName(String name) async {
    _userName = name.trim();
    await LocalStorageService.saveUserName(_userName);
    notifyListeners();
  }

  Future<void> completeInitialSetup() async {
    _hasCompletedInitialSetup = true;
    await LocalStorageService.saveInitialSetupComplete(true);
    notifyListeners();
  }

  Future<void> resetAllUserData() async {
    await LocalStorageService.resetAllUserData();
    _userName = '';
    _userAge = 26;
    _userAvatarUrl =
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80';
    _hasCompletedInitialSetup = false;
    _selectedJourney = JourneyType.pregnant;
    _pregnancyData = const PregnancyData(isSetup: false);
    _babyData = BabyData(birthDate: DateTime.now(), isSetup: false);
    _periodData = PeriodData(
      lastPeriodDate: DateTime.now(),
      cycleLength: 28,
      periodDuration: 5,
      loggedPeriodDays: const [],
      isSetup: false,
    );
    _waterGlasses = 0;
    _appointments = [];
    _vaccines = await LocalStorageService.getVaccines();
    _dailyMessageDismissedDate = null;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required int age,
    String? avatarUrl,
  }) async {
    _userName = name;
    _userAge = age;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      _userAvatarUrl = avatarUrl;
    }
    await LocalStorageService.saveUserProfile(
      name: _userName,
      age: _userAge,
      avatarUrl: _userAvatarUrl,
    );
    notifyListeners();
  }

  // ---------------- LANGUAGE ACTIONS ----------------
  Future<void> setLanguage(String lang) async {
    _language = lang;
    await LocalStorageService.saveLanguage(lang);
    notifyListeners();
  }
}
