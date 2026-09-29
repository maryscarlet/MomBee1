import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journey_type.dart';
import '../models/pregnancy_data.dart';
import '../models/baby_data.dart';
import '../models/period_data.dart';
import '../models/appointment.dart';
import '../models/vaccine_item.dart';
import '../models/notification_item.dart';
import '../data/vaccines_data.dart';

class LocalStorageService {
  static const String _kJourneyTypeKey = 'mombee_selected_journey';
  static const String _kPregnancyKey = 'mombee_pregnancy_data';
  static const String _kBabyKey = 'mombee_baby_data';
  static const String _kPeriodKey = 'mombee_period_data';
  static const String _kWaterGlassesKey = 'mombee_water_glasses';
  static const String _kWaterDateKey = 'mombee_water_date';
  static const String _kWaterGlassSizeKey = 'mombee_water_glass_size_ml';
  static const String _kWaterDailyTargetKey = 'mombee_water_daily_target_ml';
  static const String _kNotificationsEnabledKey = 'mombee_notifications_enabled';
  static const String _kNotifWaterKey = 'mombee_notif_water';
  static const String _kNotifDailyCareKey = 'mombee_notif_daily_care';
  static const String _kNotifAppointmentsKey = 'mombee_notif_appointments';
  static const String _kNotifVaccinesKey = 'mombee_notif_vaccines';
  static const String _kWaterReminderIntervalKey =
      'mombee_water_reminder_interval';
  static const String _kWaterReminderStartHourKey =
      'mombee_water_reminder_start_hour';
  static const String _kWaterReminderEndHourKey =
      'mombee_water_reminder_end_hour';
  static const String _kDailyCareHourKey = 'mombee_daily_care_hour';
  static const String _kDailyCareMinuteKey = 'mombee_daily_care_minute';
  static const String _kNotificationPermissionPromptedKey =
      'mombee_notif_perm_prompted';
  static const String _kNotificationHistoryKey = 'mombee_notif_history';
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

  static Future<void> saveWaterGlassSizeMl(int sizeMl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kWaterGlassSizeKey, sizeMl);
  }

  static Future<int> getWaterGlassSizeMl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kWaterGlassSizeKey) ?? 250;
  }

  static Future<void> saveWaterDailyTargetMl(int targetMl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kWaterDailyTargetKey, targetMl);
  }

  static Future<int> getWaterDailyTargetMl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kWaterDailyTargetKey) ?? 2500;
  }

  // ---------------- NOTIFICATION PREFERENCES ----------------
  static Future<void> saveNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificationsEnabledKey, enabled);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNotificationsEnabledKey) ?? true;
  }

  static Future<void> saveWaterNotifEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifWaterKey, enabled);
  }

  static Future<bool> getWaterNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNotifWaterKey) ?? true;
  }

  static Future<void> saveDailyCareNotifEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifDailyCareKey, enabled);
  }

  static Future<bool> getDailyCareNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNotifDailyCareKey) ?? true;
  }

  static Future<void> saveAppointmentsNotifEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifAppointmentsKey, enabled);
  }

  static Future<bool> getAppointmentsNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNotifAppointmentsKey) ?? true;
  }

  static Future<void> saveVaccinesNotifEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotifVaccinesKey, enabled);
  }

  static Future<bool> getVaccinesNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNotifVaccinesKey) ?? true;
  }

  // ---------------- WATER REMINDER SCHEDULE ----------------
  static Future<void> saveWaterReminderInterval(int hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kWaterReminderIntervalKey, hours);
  }

  static Future<int> getWaterReminderInterval() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kWaterReminderIntervalKey) ?? 1;
  }

  static Future<void> saveWaterReminderStartHour(int hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kWaterReminderStartHourKey, hour);
  }

  static Future<int> getWaterReminderStartHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kWaterReminderStartHourKey) ?? 10;
  }

  static Future<void> saveWaterReminderEndHour(int hour) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kWaterReminderEndHourKey, hour);
  }

  static Future<int> getWaterReminderEndHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kWaterReminderEndHourKey) ?? 20;
  }

  // ---------------- DAILY CARE TIME ----------------
  static Future<void> saveDailyCareTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kDailyCareHourKey, hour);
    await prefs.setInt(_kDailyCareMinuteKey, minute);
  }

  static Future<int> getDailyCareHour() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kDailyCareHourKey) ?? 9;
  }

  static Future<int> getDailyCareMinute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kDailyCareMinuteKey) ?? 0;
  }

  // ---------------- NOTIFICATION PERMISSION PROMPT ----------------
  static Future<void> saveNotificationPermissionPrompted(bool prompted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificationPermissionPromptedKey, prompted);
  }

  static Future<bool> hasPromptedNotificationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNotificationPermissionPromptedKey) ?? false;
  }

  // ---------------- NOTIFICATION HISTORY ----------------
  static Future<void> saveNotificationHistory(
      List<NotificationLogItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = list.length > 50 ? list.sublist(0, 50) : list;
    final jsonList = trimmed.map((item) => item.toJson()).toList();
    await prefs.setString(_kNotificationHistoryKey, jsonEncode(jsonList));
  }

  static Future<List<NotificationLogItem>> getNotificationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kNotificationHistoryKey);
    if (jsonString == null) {
      return [];
    }
    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) =>
              NotificationLogItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
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
    await prefs.remove(_kWaterGlassSizeKey);
    await prefs.remove(_kWaterDailyTargetKey);
    await prefs.remove(_kNotificationsEnabledKey);
    await prefs.remove(_kNotifWaterKey);
    await prefs.remove(_kNotifDailyCareKey);
    await prefs.remove(_kNotifAppointmentsKey);
    await prefs.remove(_kNotifVaccinesKey);
    await prefs.remove(_kWaterReminderIntervalKey);
    await prefs.remove(_kWaterReminderStartHourKey);
    await prefs.remove(_kWaterReminderEndHourKey);
    await prefs.remove(_kDailyCareHourKey);
    await prefs.remove(_kDailyCareMinuteKey);
    await prefs.remove(_kNotificationPermissionPromptedKey);
    await prefs.remove(_kNotificationHistoryKey);
    await prefs.remove(_kAppointmentsKey);
    await prefs.remove(_kVaccinesKey);
    await prefs.remove(_kDailyMessageDismissedDateKey);
    await prefs.remove(_kUserNameKey);
    await prefs.remove(_kUserAgeKey);
    await prefs.remove(_kUserAvatarUrlKey);
    await prefs.remove(_kInitialSetupCompleteKey);
  }
}
