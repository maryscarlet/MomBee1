import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/appointment.dart';
import '../models/vaccine_item.dart';
import '../models/journey_type.dart';
import '../models/notification_item.dart';
import '../state/app_state.dart';
import 'local_storage_service.dart';

/// Comprehensive local notification service for MomBee.
/// Runs 100% locally on device without Firebase or external cloud services.
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  static const MethodChannel _settingsChannel =
      MethodChannel('com.example.mombee_app/settings');

  // Channel IDs
  static const String _kWaterChannelId = 'mombee_water_reminders';
  static const String _kWaterChannelName = 'পানি পানের রিমাইন্ডার';
  static const String _kWaterChannelDesc =
      'দৈনিক পর্যাপ্ত পানি পানের নিয়মিত তাগিদ';

  static const String _kDailyCareChannelId = 'mombee_daily_care';
  static const String _kDailyCareChannelName = 'দৈনিক যত্ন বার্তা';
  static const String _kDailyCareChannelDesc =
      'সকালের পুষ্টি ও স্বাস্থ্য পরামর্শ';

  static const String _kAppointmentsChannelId = 'mombee_appointments';
  static const String _kAppointmentsChannelName = 'ডাক্তারের অ্যাপয়েন্টমেন্ট';
  static const String _kAppointmentsChannelDesc =
      'আসন্ন চেকআপ ও ভিজিটের রিমাইন্ডার';

  static const String _kVaccinesChannelId = 'mombee_vaccines';
  static const String _kVaccinesChannelName = 'টিকা ও ইমিউনাইজেশন';
  static const String _kVaccinesChannelDesc =
      'মা ও শিশুর প্রয়োজনীয় টিকার সময়সূচি';

  // Dedicated Android monochrome notification small icon
  static const String _kNotificationIcon = '@drawable/ic_notification';
  static const String _kFallbackIcon = '@mipmap/ic_launcher';

  // In-app Notification History
  List<NotificationLogItem> _history = [];
  List<NotificationLogItem> get history => List.unmodifiable(_history);
  int get unreadCount => _history.where((i) => !i.isRead).length;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      try {
        const String currentTimeZone = 'Asia/Dhaka';
        tz.setLocalLocation(tz.getLocation(currentTimeZone));
      } catch (_) {
        tz.setLocalLocation(tz.local);
      }

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings(_kNotificationIcon);

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification tapped: ${details.payload}');
        },
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService initialize error: $e');
      // Fallback with mipmap icon if drawable is not yet compiled on host
      try {
        const fallbackSettings = InitializationSettings(
          android: AndroidInitializationSettings(_kFallbackIcon),
        );
        await _notificationsPlugin.initialize(settings: fallbackSettings);
        _isInitialized = true;
      } catch (_) {}
    }

    await loadHistory();
  }

  // ---------------- NOTIFICATION HISTORY MANAGEMENT ----------------
  Future<void> loadHistory() async {
    try {
      _history = await LocalStorageService.getNotificationHistory();
      if (_history.isEmpty) {
        _history = _getSeedHistory();
        await LocalStorageService.saveNotificationHistory(_history);
      }
    } catch (e) {
      debugPrint('Error loading notification history: $e');
    }
  }

  List<NotificationLogItem> _getSeedHistory() {
    final now = DateTime.now();
    return [
      NotificationLogItem(
        id: 'welcome_1',
        title: 'MomBee-তে স্বাগতম 🌸',
        body:
            'আপনার ও আপনার সোনামণির সার্বিক সুস্বাস্থ্য ও যত্নে মমবি সর্বদা পাশে আছে।',
        category: NotificationCategory.general,
        timestamp: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationLogItem(
        id: 'daily_care_seed',
        title: 'সুপ্রভাত! আজকের মমবি যত্ন বার্তা 🌸',
        body: 'সকালের পুষ্টিকর নাস্তা ও পর্যাপ্ত বিশ্রাম নিশ্চিত করুন।',
        category: NotificationCategory.dailyCare,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      NotificationLogItem(
        id: 'water_seed',
        title: 'এক গ্লাস পানি পান করুন 💧',
        body: 'সুস্থ শরীর ও শিশুর সুরক্ষায় শরীর হাইড্রেটেড রাখা অত্যন্ত জরুরি।',
        category: NotificationCategory.water,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: true,
      ),
    ];
  }

  Future<void> addHistoryItem(NotificationLogItem item) async {
    _history.removeWhere((i) => i.id == item.id);
    _history.insert(0, item);
    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }
    await LocalStorageService.saveNotificationHistory(_history);
    try {
      AppState.instance.refreshNotifications();
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    final index = _history.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _history[index] = _history[index].copyWith(isRead: true);
      await LocalStorageService.saveNotificationHistory(_history);
      try {
        AppState.instance.refreshNotifications();
      } catch (_) {}
    }
  }

  Future<void> markAllAsRead() async {
    _history = _history.map((item) => item.copyWith(isRead: true)).toList();
    await LocalStorageService.saveNotificationHistory(_history);
    try {
      AppState.instance.refreshNotifications();
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    _history = [];
    await LocalStorageService.saveNotificationHistory(_history);
    try {
      AppState.instance.refreshNotifications();
    } catch (_) {}
  }

  // ---------------- PERMISSION CHECKS & SETTINGS ----------------
  Future<bool> areNotificationsEnabled() async {
    if (kIsWeb) return false;
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        return await androidImplementation?.areNotificationsEnabled() ?? false;
      }
    } catch (_) {}
    return false;
  }

  Future<bool> requestPermissions() async {
    try {
      if (kIsWeb) return false;

      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted =
            await androidImplementation?.requestNotificationsPermission();
        return granted ?? false;
      } else if (Platform.isIOS) {
        final iosImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
    return false;
  }

  Future<void> openNotificationSettings() async {
    if (kIsWeb) return;
    try {
      await _settingsChannel.invokeMethod('openNotificationSettings');
    } catch (e) {
      debugPrint('Could not open notification settings: $e');
    }
  }

  // ---------------- WATER REMINDERS (Configurable Hourly Interval) ----------------
  List<int> getWaterReminderHours({
    int? interval,
    int? startHour,
    int? endHour,
  }) {
    final int step = interval ?? AppState.instance.waterReminderInterval;
    final int start = startHour ?? AppState.instance.waterReminderStartHour;
    final int end = endHour ?? AppState.instance.waterReminderEndHour;

    final List<int> hours = [];
    final validStep = step > 0 ? step : 1;
    for (int h = start; h <= end; h += validStep) {
      hours.add(h);
    }
    return hours;
  }

  Future<void> scheduleWaterReminders({
    bool suppressTodayRemaining = false,
  }) async {
    if (!_isInitialized || !AppState.instance.notificationsEnabled) return;
    if (!AppState.instance.notifWater) return;

    await cancelWaterReminders();

    final hours = getWaterReminderHours();
    final now = DateTime.now();

    for (int i = 0; i < hours.length; i++) {
      final hour = hours[i];
      final id = 1000 + i;

      try {
        tz.TZDateTime scheduledTime;
        if (suppressTodayRemaining && hour >= now.hour) {
          // If water target is already reached today, push reminder to start tomorrow
          final tz.TZDateTime nowTz = tz.TZDateTime.now(tz.local);
          final tomorrow = nowTz.add(const Duration(days: 1));
          scheduledTime = tz.TZDateTime(
            tz.local,
            tomorrow.year,
            tomorrow.month,
            tomorrow.day,
            hour,
            0,
          );
        } else {
          scheduledTime = _nextInstanceOfTime(hour, 0);
        }

        const androidDetails = AndroidNotificationDetails(
          _kWaterChannelId,
          _kWaterChannelName,
          channelDescription: _kWaterChannelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: _kNotificationIcon,
        );
        const iosDetails = DarwinNotificationDetails();
        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: 'এক গ্লাস পানি পান করুন 💧',
          body:
              'সুস্থ শরীর ও শিশুর সুরক্ষায় শরীর হাইড্রেটেড রাখা অত্যন্ত জরুরি।',
          scheduledDate: scheduledTime,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        debugPrint('Error scheduling water reminder at $hour: $e');
      }
    }
  }

  Future<void> onWaterTargetReached() async {
    // When target is reached, cancel remainder of today's reminders and resume tomorrow morning
    await scheduleWaterReminders(suppressTodayRemaining: true);
  }

  Future<void> cancelWaterReminders() async {
    if (!_isInitialized) return;
    for (int id = 1000; id <= 1030; id++) {
      try {
        await _notificationsPlugin.cancel(id: id);
      } catch (_) {}
    }
  }

  // ---------------- DAILY CARE REMINDER (Customizable Time) ----------------
  Future<void> scheduleDailyCareReminder() async {
    if (!_isInitialized || !AppState.instance.notificationsEnabled) return;
    if (!AppState.instance.notifDailyCare) return;

    await cancelDailyCareReminder();

    try {
      final hour = AppState.instance.dailyCareHour;
      final minute = AppState.instance.dailyCareMinute;
      final scheduledTime = _nextInstanceOfTime(hour, minute);

      const androidDetails = AndroidNotificationDetails(
        _kDailyCareChannelId,
        _kDailyCareChannelName,
        channelDescription: _kDailyCareChannelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: _kNotificationIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final journey = AppState.instance.selectedJourney;
      final body = journey == JourneyType.pregnant
          ? 'আজকের গর্ভকালীন পুষ্টি ও যত্নের নির্দেশনা প্রস্তুত আছে।'
          : journey == JourneyType.baby
              ? 'সোনামণির দৈনন্দিন বিকাশ ও যত্নের আজকের পরামর্শ দেখে নিন।'
              : 'আজকের সুস্থ মাতৃত্ব ও স্বাস্থ্য পরামর্শ দেখে নিন।';

      await _notificationsPlugin.zonedSchedule(
        id: 2001,
        title: 'সুপ্রভাত! আজকের মমবি যত্ন বার্তা 🌸',
        body: body,
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Error scheduling daily care reminder: $e');
    }
  }

  Future<void> cancelDailyCareReminder() async {
    if (!_isInitialized) return;
    try {
      await _notificationsPlugin.cancel(id: 2001);
    } catch (e) {
      debugPrint('Error canceling daily care reminder: $e');
    }
  }

  // ---------------- APPOINTMENT REMINDER (24 hours prior) ----------------
  int _appointmentIdToNotifId(String id) {
    return (id.hashCode.abs() % 100000) + 30000;
  }

  Future<void> scheduleAppointmentReminder(Appointment app) async {
    if (!_isInitialized || !AppState.instance.notificationsEnabled) return;
    if (!AppState.instance.notifAppointments) return;
    if (app.isCompleted) return;

    final notifId = _appointmentIdToNotifId(app.id);
    final reminderTime = app.dateTime.subtract(const Duration(hours: 24));
    if (reminderTime.isBefore(DateTime.now())) return;

    try {
      final scheduledTz = tz.TZDateTime.from(reminderTime, tz.local);

      const androidDetails = AndroidNotificationDetails(
        _kAppointmentsChannelId,
        _kAppointmentsChannelName,
        channelDescription: _kAppointmentsChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: notifId,
        title: 'আগামীকাল ডাক্তারের অ্যাপয়েন্টমেন্ট 🩺',
        body:
            '${app.doctorName}-এর সাথে অ্যাপয়েন্টমেন্ট। ফাইল ও রিপোর্ট সঙ্গে রাখুন।',
        scheduledDate: scheduledTz,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error scheduling appointment reminder: $e');
    }
  }

  Future<void> cancelAppointmentReminder(String appointmentId) async {
    if (!_isInitialized) return;
    try {
      final notifId = _appointmentIdToNotifId(appointmentId);
      await _notificationsPlugin.cancel(id: notifId);
    } catch (e) {
      debugPrint('Error canceling appointment reminder: $e');
    }
  }

  // ---------------- VACCINATION REMINDER (Due alert) ----------------
  int _vaccineIdToNotifId(String id) {
    return (id.hashCode.abs() % 100000) + 60000;
  }

  Future<void> scheduleVaccineReminder(VaccineItem vaccine) async {
    if (!_isInitialized || !AppState.instance.notificationsEnabled) return;
    if (!AppState.instance.notifVaccines) return;
    if (vaccine.isCompleted) return;

    final notifId = _vaccineIdToNotifId(vaccine.id);
    await cancelVaccineReminder(vaccine.id);

    try {
      final scheduledTime =
          tz.TZDateTime.now(tz.local).add(const Duration(days: 7));
      const androidDetails = AndroidNotificationDetails(
        _kVaccinesChannelId,
        _kVaccinesChannelName,
        channelDescription: _kVaccinesChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: notifId,
        title: 'টিকার রিমাইন্ডার: ${vaccine.name}',
        body: '${vaccine.description} সময়মতো সম্পন্ন করা নিশ্চিত করুন।',
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Error scheduling vaccine reminder: $e');
    }
  }

  Future<void> cancelVaccineReminder(String vaccineId) async {
    if (!_isInitialized) return;
    try {
      final notifId = _vaccineIdToNotifId(vaccineId);
      await _notificationsPlugin.cancel(id: notifId);
    } catch (e) {
      debugPrint('Error canceling vaccine reminder: $e');
    }
  }

  // ---------------- SYNC ALL REMINDERS ----------------
  Future<void> syncAllReminders() async {
    if (!_isInitialized) return;

    if (!AppState.instance.notificationsEnabled) {
      await cancelAll();
      return;
    }

    if (AppState.instance.notifWater) {
      await scheduleWaterReminders();
    } else {
      await cancelWaterReminders();
    }

    if (AppState.instance.notifDailyCare) {
      await scheduleDailyCareReminder();
    } else {
      await cancelDailyCareReminder();
    }

    for (final app in AppState.instance.appointments) {
      if (AppState.instance.notifAppointments && !app.isCompleted) {
        await scheduleAppointmentReminder(app);
      } else {
        await cancelAppointmentReminder(app.id);
      }
    }

    for (final v in AppState.instance.vaccines) {
      if (AppState.instance.notifVaccines && !v.isCompleted) {
        await scheduleVaccineReminder(v);
      } else {
        await cancelVaccineReminder(v.id);
      }
    }
  }

  Future<void> cancelAll() async {
    if (!_isInitialized) return;
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Error canceling all notifications: $e');
    }
  }

  /// Instant notification dispatch for testing or in-app triggers
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String category = NotificationCategory.general,
  }) async {
    if (!_isInitialized) return;
    try {
      const androidDetails = AndroidNotificationDetails(
        'mombee_general',
        'সাধারণ নোটিফিকেশন',
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      const details =
          NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
      );

      await addHistoryItem(NotificationLogItem(
        id: id.toString(),
        title: title,
        body: body,
        category: category,
        timestamp: DateTime.now(),
        isRead: false,
      ));
    } catch (e) {
      debugPrint('Error showing instant notification: $e');
    }
  }

  /// For testing and auditing scheduled notifications on supported platforms
  Future<List<PendingNotificationRequest>>
      getPendingNotificationRequests() async {
    if (!_isInitialized) return [];
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (_) {
      return [];
    }
  }

  FlutterLocalNotificationsPlugin get plugin => _notificationsPlugin;

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
