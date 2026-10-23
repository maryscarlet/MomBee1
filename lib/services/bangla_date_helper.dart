import '../models/pregnancy_data.dart';
import '../state/app_state.dart';

/// Helper for Bangla date formatting and dynamic time-based greetings.
class BanglaDateHelper {
  static const List<String> bengaliWeekdays = [
    'সোমবার', // 1: Monday
    'মঙ্গলবার', // 2: Tuesday
    'বুধবার',   // 3: Wednesday
    'বৃহস্পতিবার', // 4: Thursday
    'শুক্রবার',  // 5: Friday
    'শনিবার',   // 6: Saturday
    'রবিবার',   // 7: Sunday
  ];

  static const List<String> bengaliMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  /// Formats date in natural Bengali: e.g. "শুক্রবার, ২৩ অক্টোবর ২০২৬"
  static String formatBanglaDate(DateTime date) {
    if (AppState.instance.isEnglish) {
      const enWeekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      const enMonths = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${enWeekdays[date.weekday - 1]}, ${date.day} ${enMonths[date.month - 1]} ${date.year}';
    }

    final weekday = bengaliWeekdays[date.weekday - 1];
    final day = toBanglaDigits(date.day);
    final month = bengaliMonths[date.month - 1];
    final year = toBanglaDigits(date.year);
    return '$weekday, $day $month $year';
  }

  /// Dynamic time-based greeting matching exact user requirements:
  /// - সকাল (5:00 AM to before 12:00 PM): "শুভ সকাল"
  /// - দুপুর (12:00 PM to before 3:00 PM): "শুভ দুপুর"
  /// - বিকাল (3:00 PM to before 6:00 PM): "শুভ বিকাল"
  /// - সন্ধ্যা (6:00 PM to before 9:00 PM): "শুভ সন্ধ্যা"
  /// - রাত (9:00 PM to before 5:00 AM): "শুভ রাত্রি"
  static String getGreetingPhrase({DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 12) {
      return 'শুভ সকাল';
    } else if (hour >= 12 && hour < 15) {
      return 'শুভ দুপুর';
    } else if (hour >= 15 && hour < 18) {
      return 'শুভ বিকাল';
    } else if (hour >= 18 && hour < 21) {
      return 'শুভ সন্ধ্যা';
    } else {
      return 'শুভ রাত্রি';
    }
  }

  /// Dynamic time-based greeting with optional name:
  static String getTimeBasedGreeting({String? userName, DateTime? dateTime}) {
    final greeting = getGreetingPhrase(dateTime: dateTime);
    final trimmedName = userName?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      return '$greeting, $trimmedName!';
    }
    return '$greeting!';
  }
}
