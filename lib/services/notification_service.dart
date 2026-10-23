import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/appointment.dart';
import '../models/journey_type.dart';
import '../models/vaccine_item.dart';
import '../models/notification_item.dart';
import '../state/app_state.dart';
import 'daily_message_service.dart';
import 'local_storage_service.dart';
import 'notification_navigation_handler.dart';

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

  static const String _kPeriodOvulationChannelId = 'mombee_period_ovulation';
  static const String _kPeriodOvulationChannelName = 'পিরিয়ড ও ওভুলেশন রিমাইন্ডার';
  static const String _kPeriodOvulationChannelDesc =
      'মাসিক চক্রের সম্ভাব্য শুরু ও উর্বর সময়ের পূর্বাভাস';

  // Dedicated Android monochrome notification small icon
  static const String _kNotificationIcon = 'ic_notification';
  static const String _kFallbackIcon = 'ic_launcher';

  // Authentic MomBee Maroon brand color (#91002B)
  static const Color _kBrandMaroonColor = Color(0xFF91002B);

  // Full-color MomBee logo resource for notification shade
  static const AndroidBitmap<Object> _kLargeIcon =
      DrawableResourceAndroidBitmap('ic_mombee_large');
  AndroidBitmap<Object> get largeIconBitmap => _kLargeIcon;

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
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('Notification tapped with payload: ${details.payload}');
          NotificationNavigationHandler.instance.handlePayload(details.payload);
        },
      );

      // Pre-create all Android notification channels with high importance
      await createNotificationChannels();

      // Check if app was cold launched by user tapping a notification
      try {
        final launchDetails =
            await _notificationsPlugin.getNotificationAppLaunchDetails();
        if (launchDetails?.didNotificationLaunchApp == true &&
            launchDetails?.notificationResponse?.payload != null) {
          final payload = launchDetails!.notificationResponse!.payload;
          debugPrint('App launched from notification payload: $payload');
          NotificationNavigationHandler.instance.setPendingPayload(payload);
        }
      } catch (e) {
        debugPrint('Error inspecting app launch details: $e');
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService initialize error: $e');
      // Fallback with mipmap icon if drawable is not yet compiled on host
      try {
        const fallbackSettings = InitializationSettings(
          android: AndroidInitializationSettings(_kFallbackIcon),
        );
        await _notificationsPlugin.initialize(
          settings: fallbackSettings,
          onDidReceiveNotificationResponse: (NotificationResponse details) {
            NotificationNavigationHandler.instance.handlePayload(details.payload);
          },
        );
        await createNotificationChannels();
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

  /// Explicitly registers all notification channels in Android's NotificationManager.
  /// Required for Android 8.0+ (Oreo through Android 15) to guarantee alerts appear.
  Future<void> createNotificationChannels() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return;

      const channels = [
        AndroidNotificationChannel(
          _kWaterChannelId,
          _kWaterChannelName,
          description: _kWaterChannelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
        AndroidNotificationChannel(
          _kDailyCareChannelId,
          _kDailyCareChannelName,
          description: _kDailyCareChannelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
        AndroidNotificationChannel(
          _kAppointmentsChannelId,
          _kAppointmentsChannelName,
          description: _kAppointmentsChannelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
        AndroidNotificationChannel(
          _kVaccinesChannelId,
          _kVaccinesChannelName,
          description: _kVaccinesChannelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
        AndroidNotificationChannel(
          _kPeriodOvulationChannelId,
          _kPeriodOvulationChannelName,
          description: _kPeriodOvulationChannelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
        AndroidNotificationChannel(
          'mombee_general',
          'সাধারণ নোটিফিকেশন',
          description: 'মমবি সাধারণ ও টেস্ট নোটিফিকেশন',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      ];

      for (final channel in channels) {
        await androidPlugin.createNotificationChannel(channel);
      }
    } catch (e) {
      debugPrint('Error creating Android notification channels: $e');
    }
  }

  /// Checks whether exact alarm scheduling is allowed by Android 12+ (API 31+).
  Future<bool> canScheduleExactAlarms() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      return await androidPlugin?.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Sends or schedules a test notification on the real device to verify delivery.
  Future<Map<String, dynamic>> sendTestNotification({
    int delaySeconds = 0,
    String targetType = 'test',
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final isPermitted = await areNotificationsEnabled();
    if (!isPermitted) {
      final granted = await requestPermissions();
      if (!granted) {
        return {
          'success': false,
          'message': 'সিস্টেম থেকে নোটিফিকেশন অনুমতি পাওয়া যায়নি। সেটিংস থেকে অনুমতি দিন।',
          'code': 'PERMISSION_DENIED',
        };
      }
    }

    await createNotificationChannels();

    try {
      final androidDetails = AndroidNotificationDetails(
        targetType == 'daily_care'
            ? _kDailyCareChannelId
            : targetType == 'appointment'
                ? _kAppointmentsChannelId
                : targetType == 'vaccine'
                    ? _kVaccinesChannelId
                    : (targetType == 'period' || targetType == 'ovulation')
                        ? _kPeriodOvulationChannelId
                        : _kWaterChannelId,
        targetType == 'daily_care'
            ? _kDailyCareChannelName
            : targetType == 'appointment'
                ? _kAppointmentsChannelName
                : targetType == 'vaccine'
                    ? _kVaccinesChannelName
                    : (targetType == 'period' || targetType == 'ovulation')
                        ? _kPeriodOvulationChannelName
                        : _kWaterChannelName,
        channelDescription: targetType == 'daily_care'
            ? _kDailyCareChannelDesc
            : targetType == 'appointment'
                ? _kAppointmentsChannelDesc
                : targetType == 'vaccine'
                    ? _kVaccinesChannelDesc
                    : (targetType == 'period' || targetType == 'ovulation')
                        ? _kPeriodOvulationChannelDesc
                        : _kWaterChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notifId = (DateTime.now().millisecondsSinceEpoch ~/ 1000) % 100000;
      
      String title = 'টেস্ট নোটিফিকেশন 🌸 (MomBee)';
      String body = 'অভিনন্দন! আপনার ফোনে মমবি নোটিফিকেশন সফলভাবে কাজ করছে। 💧';
      String category = NotificationCategory.general;

      switch (targetType) {
        case 'water':
          title = 'এক গ্লাস পানি পান করুন 💧 (MomBee)';
          body = 'সুস্থ শরীর ও শিশুর সুরক্ষায় শরীর হাইড্রেটেড রাখা অত্যন্ত জরুরি। ট্যাপ করে ট্র্যাকার খুলুন।';
          category = NotificationCategory.water;
          break;
        case 'daily_care':
          final dailyMsg = DailyMessageService.getDailyMessageForCurrentProfile();
          title = '🌸 ${dailyMsg.title}';
          body = dailyMsg.message;
          category = NotificationCategory.dailyCare;
          break;
        case 'period':
          title = 'আপনার পিরিয়ডের সম্ভাব্য সময় কাছাকাছি 🌸 (MomBee)';
          body = 'আপনার পূর্বের সাইকেল রেকর্ড অনুযায়ী পরবর্তী পিরিয়ড শুরুর সম্ভাব্য সময় ঘনিয়ে এসেছে। শারীরিক প্রস্তুতি ও যত্ন নিন। (এটি একটি আনুমানিক হিসাব)';
          category = NotificationCategory.general;
          break;
        case 'ovulation':
          title = 'আপনার সম্ভাব্য Ovulation সময় আসছে 🌸 (MomBee)';
          body = 'আপনার মাসিক চক্রের হিসাব অনুযায়ী উর্বর সময় (Fertile Window) ও সম্ভাব্য ওভুলেশন আসন্ন। সুস্থ থাকুন ও পুষ্টিকর খাবার গ্রহণ করুন। (এটি একটি আনুমানিক হিসাব)';
          category = NotificationCategory.general;
          break;
        case 'appointment':
          title = 'ডাক্তারের অ্যাপয়েন্টমেন্ট রিমাইন্ডার 🩺';
          body = 'আগামীকাল ডাক্তারের সাথে নির্ধারিত ভিজিট। ট্যাপ করে অ্যাপয়েন্টমেন্ট লিস্ট দেখুন।';
          category = NotificationCategory.appointment;
          break;
        case 'vaccine':
          title = 'টিকা ও ইমিউনাইজেশন রিমাইন্ডার 💉';
          body = 'মা ও শিশুর প্রয়োজনীয় টিকার সময়সূচি। ট্যাপ করে টিকার তালিকা দেখুন।';
          category = NotificationCategory.vaccine;
          break;
        default:
          title = 'টেস্ট নোটিফিকেশন 🌸 (MomBee)';
          body = 'ট্যাপ করে নোটিফিকেশন সেন্টারে যান এবং নেভিগেশন পরীক্ষা করুন। 💧';
          category = NotificationCategory.general;
          break;
      }

      final payload = jsonEncode({'type': targetType});

      if (delaySeconds <= 0) {
        await _notificationsPlugin.show(
          id: notifId,
          title: title,
          body: body,
          notificationDetails: notificationDetails,
          payload: payload,
        );
      } else {
        final canExact = await canScheduleExactAlarms();
        final scheduleMode = canExact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle;

        final scheduledTime =
            tz.TZDateTime.now(tz.local).add(Duration(seconds: delaySeconds));

        await _notificationsPlugin.zonedSchedule(
          id: notifId,
          title: title,
          body: body,
          scheduledDate: scheduledTime,
          notificationDetails: notificationDetails,
          androidScheduleMode: scheduleMode,
          payload: payload,
        );
      }

      await addHistoryItem(NotificationLogItem(
        id: notifId.toString(),
        title: title,
        body: body,
        category: category,
        timestamp: DateTime.now(),
        isRead: false,
        payload: payload,
      ));

      return {
        'success': true,
        'message': delaySeconds <= 0
            ? 'টেস্ট নোটিফিকেশন তাৎক্ষণিকভাবে পাঠানো হয়েছে।'
            : '$delaySeconds সেকেন্ড পর টেস্ট নোটিফিকেশন আসবে। নোটিফিকেশন বার চেক করুন।',
      };
    } catch (e) {
      debugPrint('Error sending test notification: $e');
      return {
        'success': false,
        'message': 'নোটিফিকেশন প্রেরণে ত্রুটি: $e',
        'error': e.toString(),
      };
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
    final canExact = await canScheduleExactAlarms();
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

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

        final androidDetails = AndroidNotificationDetails(
          _kWaterChannelId,
          _kWaterChannelName,
          channelDescription: _kWaterChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          icon: _kNotificationIcon,
          color: _kBrandMaroonColor,
          largeIcon: _kLargeIcon,
        );
        const iosDetails = DarwinNotificationDetails();
        final notificationDetails = NotificationDetails(
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
          androidScheduleMode: scheduleMode,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: jsonEncode({'type': 'water'}),
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
      final canExact = await canScheduleExactAlarms();
      final scheduleMode = canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      final msg = DailyMessageService.getDailyMessageForCurrentProfile();

      final bigTextStyleInformation = BigTextStyleInformation(
        msg.message,
        htmlFormatBigText: false,
        contentTitle: '🌸 ${msg.title}',
        htmlFormatContentTitle: false,
        summaryText: msg.category,
        htmlFormatSummaryText: false,
      );

      final androidDetails = AndroidNotificationDetails(
        _kDailyCareChannelId,
        _kDailyCareChannelName,
        channelDescription: _kDailyCareChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
        styleInformation: bigTextStyleInformation,
      );
      const iosDetails = DarwinNotificationDetails();
      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: 2001,
        title: '🌸 ${msg.title}',
        body: msg.message,
        scheduledDate: scheduledTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: scheduleMode,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: jsonEncode({'type': 'daily_care'}),
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

  // ---------------- PERIOD REMINDER (ID 2002) ----------------
  Future<void> schedulePeriodReminder() async {
    if (!_isInitialized || !AppState.instance.notificationsEnabled) return;
    if (!AppState.instance.notifPeriod) return;

    // Suppress if user is pregnant or cycle data is not configured
    if (AppState.instance.selectedJourney == JourneyType.pregnant ||
        !AppState.instance.periodData.isSetup) {
      await cancelPeriodReminder();
      return;
    }

    await cancelPeriodReminder();

    try {
      final hour = AppState.instance.periodReminderHour;
      final minute = AppState.instance.periodReminderMinute;
      final target = AppState.instance.periodData.upcomingNextPeriod;

      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        target.year,
        target.month,
        target.day,
        hour,
        minute,
      );

      final nowTz = tz.TZDateTime.now(tz.local);
      if (scheduledDate.isBefore(nowTz)) {
        scheduledDate = scheduledDate.add(
          Duration(days: AppState.instance.periodData.cycleLength),
        );
      }

      final canExact = await canScheduleExactAlarms();
      final scheduleMode = canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      const title = 'আপনার পিরিয়ডের সম্ভাব্য সময় কাছাকাছি';
      const body =
          'আপনার পূর্বের সাইকেল রেকর্ড অনুযায়ী পরবর্তী পিরিয়ড শুরুর সম্ভাব্য সময় ঘনিয়ে এসেছে। শারীরিক প্রস্তুতি ও যত্ন নিন। (এটি একটি আনুমানিক হিসাব)';

      const bigTextStyleInformation = BigTextStyleInformation(
        body,
        htmlFormatBigText: false,
        contentTitle: title,
        htmlFormatContentTitle: false,
        summaryText: 'পিরিয়ড রিমাইন্ডার',
        htmlFormatSummaryText: false,
      );

      final androidDetails = AndroidNotificationDetails(
        _kPeriodOvulationChannelId,
        _kPeriodOvulationChannelName,
        channelDescription: _kPeriodOvulationChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
        styleInformation: bigTextStyleInformation,
      );
      const iosDetails = DarwinNotificationDetails();
      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: 2002,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: scheduleMode,
        payload: jsonEncode({'type': 'period'}),
      );
    } catch (e) {
      debugPrint('Error scheduling period reminder: $e');
    }
  }

  Future<void> cancelPeriodReminder() async {
    if (!_isInitialized) return;
    try {
      await _notificationsPlugin.cancel(id: 2002);
    } catch (e) {
      debugPrint('Error canceling period reminder: $e');
    }
  }

  // ---------------- OVULATION REMINDER (ID 2003) ----------------
  Future<void> scheduleOvulationReminder() async {
    if (!_isInitialized || !AppState.instance.notificationsEnabled) return;
    if (!AppState.instance.notifOvulation) return;

    // Suppress if user is pregnant or cycle data is not configured
    if (AppState.instance.selectedJourney == JourneyType.pregnant ||
        !AppState.instance.periodData.isSetup) {
      await cancelOvulationReminder();
      return;
    }

    await cancelOvulationReminder();

    try {
      final hour = AppState.instance.ovulationReminderHour;
      final minute = AppState.instance.ovulationReminderMinute;
      final fertileStart =
          AppState.instance.periodData.upcomingFertileWindowStart;
      final ovDate = AppState.instance.periodData.upcomingOvulationDate;
      final nowTz = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        fertileStart.year,
        fertileStart.month,
        fertileStart.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(nowTz)) {
        scheduledDate = tz.TZDateTime(
          tz.local,
          ovDate.year,
          ovDate.month,
          ovDate.day,
          hour,
          minute,
        );
        if (scheduledDate.isBefore(nowTz)) {
          scheduledDate = scheduledDate.add(
            Duration(days: AppState.instance.periodData.cycleLength),
          );
        }
      }

      final canExact = await canScheduleExactAlarms();
      final scheduleMode = canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;

      const title = 'আপনার সম্ভাব্য Ovulation সময় আসছে';
      const body =
          'আপনার মাসিক চক্রের হিসাব অনুযায়ী উর্বর সময় (Fertile Window) ও সম্ভাব্য ওভুলেশন আসন্ন। সুস্থ থাকুন ও পুষ্টিকর খাবার গ্রহণ করুন। (এটি একটি আনুমানিক হিসাব)';

      const bigTextStyleInformation = BigTextStyleInformation(
        body,
        htmlFormatBigText: false,
        contentTitle: title,
        htmlFormatContentTitle: false,
        summaryText: 'ওভুলেশন রিমাইন্ডার',
        htmlFormatSummaryText: false,
      );

      final androidDetails = AndroidNotificationDetails(
        _kPeriodOvulationChannelId,
        _kPeriodOvulationChannelName,
        channelDescription: _kPeriodOvulationChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
        styleInformation: bigTextStyleInformation,
      );
      const iosDetails = DarwinNotificationDetails();
      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        id: 2003,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: scheduleMode,
        payload: jsonEncode({'type': 'ovulation'}),
      );
    } catch (e) {
      debugPrint('Error scheduling ovulation reminder: $e');
    }
  }

  Future<void> cancelOvulationReminder() async {
    if (!_isInitialized) return;
    try {
      await _notificationsPlugin.cancel(id: 2003);
    } catch (e) {
      debugPrint('Error canceling ovulation reminder: $e');
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

      final androidDetails = AndroidNotificationDetails(
        _kAppointmentsChannelId,
        _kAppointmentsChannelName,
        channelDescription: _kAppointmentsChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      final notificationDetails = NotificationDetails(
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
        payload: jsonEncode({'type': 'appointment', 'id': app.id}),
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
      final androidDetails = AndroidNotificationDetails(
        _kVaccinesChannelId,
        _kVaccinesChannelName,
        channelDescription: _kVaccinesChannelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      final notificationDetails = NotificationDetails(
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
        payload: jsonEncode({'type': 'vaccine', 'id': vaccine.id}),
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

    if (AppState.instance.selectedJourney == JourneyType.pregnant) {
      await cancelPeriodReminder();
      await cancelOvulationReminder();
    } else {
      if (AppState.instance.notifPeriod) {
        await schedulePeriodReminder();
      } else {
        await cancelPeriodReminder();
      }

      if (AppState.instance.notifOvulation) {
        await scheduleOvulationReminder();
      } else {
        await cancelOvulationReminder();
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
      final androidDetails = AndroidNotificationDetails(
        'mombee_general',
        'সাধারণ নোটিফিকেশন',
        importance: Importance.high,
        priority: Priority.high,
        icon: _kNotificationIcon,
        color: _kBrandMaroonColor,
        largeIcon: _kLargeIcon,
      );
      const iosDetails = DarwinNotificationDetails();
      final details =
          NotificationDetails(android: androidDetails, iOS: iosDetails);

      final payload = jsonEncode({'type': category});

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );

      await addHistoryItem(NotificationLogItem(
        id: id.toString(),
        title: title,
        body: body,
        category: category,
        timestamp: DateTime.now(),
        isRead: false,
        payload: payload,
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
