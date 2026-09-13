import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journey_type.dart';
import '../models/pregnancy_data.dart';
import '../models/baby_data.dart';
import '../models/period_data.dart';
import '../models/appointment.dart';
import '../models/vaccine_item.dart';
import '../data/vaccines_data.dart';

class LocalStorageService {
  static const String _kJourneyTypeKey = 'mombee_selected_journey';
  static const String _kPregnancyKey = 'mombee_pregnancy_data';
  static const String _kBabyKey = 'mombee_baby_data';
  static const String _kPeriodKey = 'mombee_period_data';
  static const String _kWaterGlassesKey = 'mombee_water_glasses';
  static const String _kWaterDateKey = 'mombee_water_date';
  static const String _kAppointmentsKey = 'mombee_appointments_list';
  static const String _kVaccinesKey = 'mombee_vaccines_list';
  static const String _kLanguageKey = 'mombee_app_language';
  static const String _kDailyMessageDismissedDateKey =
      'mombee_daily_msg_dismissed_date';
  static const String _kUserNameKey = 'mombee_user_name';
  static const String _kUserAgeKey = 'mombee_user_age';
  static const String _kUserAvatarUrlKey = 'mombee_user_avatar_url';
  static const String _kInitialSetupCompleteKey =
      'mombee_initial_setup_complete';

  // ---------------- INITIAL SETUP STATUS ----------------
  static Future<void> saveInitialSetupComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kInitialSetupCompleteKey, complete);
  }

  static Future<bool> isInitialSetupComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kInitialSetupCompleteKey) ?? false;
  }

  // ---------------- JOURNEY TYPE ----------------
  static Future<void> saveJourneyType(JourneyType journey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kJourneyTypeKey, journey.id);
  }

  static Future<JourneyType?> getJourneyType() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_kJourneyTypeKey);
    if (id == null) return null;
    return JourneyTypeExtension.fromString(id);
  }

  // ---------------- PREGNANCY DATA ----------------
  static Future<void> savePregnancyData(PregnancyData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_kPregnancyKey, jsonString);
  }

  static Future<PregnancyData?> getPregnancyData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kPregnancyKey);
    if (jsonString == null) return null;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return PregnancyData.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // ---------------- BABY DATA ----------------
  static Future<void> saveBabyData(BabyData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_kBabyKey, jsonString);
  }

  static Future<BabyData?> getBabyData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kBabyKey);
    if (jsonString == null) return null;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return BabyData.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // ---------------- PERIOD DATA ----------------
  static Future<void> savePeriodData(PeriodData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_kPeriodKey, jsonString);
  }

  static Future<PeriodData> getPeriodData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final jsonString = prefs.getString(_kPeriodKey);
    if (jsonString == null) {
      return PeriodData(
        lastPeriodDate: DateTime.now(),
        cycleLength: 28,
        periodDuration: 5,
        loggedPeriodDays: const [],
        isSetup: false,
      );
    }
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return PeriodData.fromJson(map);
    } catch (_) {
      return PeriodData(
        lastPeriodDate: DateTime.now(),
        isSetup: false,
      );
    }
  }

  // ---------------- WATER TRACKER ----------------
  static Future<void> saveWaterGlasses(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    await prefs.setInt(_kWaterGlassesKey, count);
    await prefs.setString(_kWaterDateKey, today);
  }

  static Future<int> getWaterGlasses() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    final savedDate = prefs.getString(_kWaterDateKey);
    if (savedDate == today) {
      return prefs.getInt(_kWaterGlassesKey) ?? 0;
    } else {
      await prefs.setString(_kWaterDateKey, today);
      await prefs.setInt(_kWaterGlassesKey, 0);
      return 0;
    }
  }

  // ---------------- APPOINTMENTS ----------------
  static Future<void> saveAppointments(List<Appointment> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((a) => a.toJson()).toList();
    await prefs.setString(_kAppointmentsKey, jsonEncode(jsonList));
  }

  static Future<List<Appointment>> getAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kAppointmentsKey);
    if (jsonString == null) {
      return [];
    }
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------- VACCINATIONS ----------------
  static Future<void> saveVaccines(List<VaccineItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((v) => v.toJson()).toList();
    await prefs.setString(_kVaccinesKey, jsonEncode(jsonList));
  }

  static Future<List<VaccineItem>> getVaccines() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kVaccinesKey);
    if (jsonString == null) {
      return defaultVaccinesList;
    }
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => VaccineItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return defaultVaccinesList;
    }
  }

  // ---------------- APP LANGUAGE ----------------
  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, lang);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kLanguageKey) ?? 'বাংলা';
  }

  // ---------------- DAILY MESSAGE DISMISSAL ----------------
  static Future<void> saveDailyMessageDismissedDate(String dateStr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDailyMessageDismissedDateKey, dateStr);
  }

  static Future<String?> getDailyMessageDismissedDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kDailyMessageDismissedDateKey);
  }

  // ---------------- USER PROFILE ----------------
  static Future<void> saveUserProfile({
    required String name,
    required int age,
    required String avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserNameKey, name);
    await prefs.setInt(_kUserAgeKey, age);
    await prefs.setString(_kUserAvatarUrlKey, avatarUrl);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserNameKey);
  }

  static Future<int?> getUserAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kUserAgeKey);
  }

  static Future<String?> getUserAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserAvatarUrlKey);
  }

  // ---------------- RESET ALL USER DATA ----------------
  static Future<void> resetAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kJourneyTypeKey);
    await prefs.remove(_kPregnancyKey);
    await prefs.remove(_kBabyKey);
    await prefs.remove(_kPeriodKey);
    await prefs.remove(_kWaterGlassesKey);
    await prefs.remove(_kWaterDateKey);
    await prefs.remove(_kAppointmentsKey);
    await prefs.remove(_kVaccinesKey);
    await prefs.remove(_kDailyMessageDismissedDateKey);
    await prefs.remove(_kUserNameKey);
    await prefs.remove(_kUserAgeKey);
    await prefs.remove(_kUserAvatarUrlKey);
    await prefs.remove(_kInitialSetupCompleteKey);
  }
}
