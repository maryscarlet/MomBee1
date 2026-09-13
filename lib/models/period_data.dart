class PeriodData {
  final DateTime lastPeriodDate;
  final int cycleLength; // Average days e.g. 28
  final int periodDuration; // Days of bleeding e.g. 5
  final List<DateTime> loggedPeriodDays;
  final List<Map<String, dynamic>> pastCycles;
  final bool isSetup;

  const PeriodData({
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodDuration = 5,
    this.loggedPeriodDays = const [],
    this.pastCycles = const [],
    this.isSetup = true,
  });

  /// Normalized Last Period Date (midnight)
  DateTime get normalizedLmp =>
      DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day);

  /// Helper calculating exact calendar days between two dates immune to DST / hour shifts
  static int daysDifference(DateTime from, DateTime to) {
    final fromUtc = DateTime.utc(from.year, from.month, from.day);
    final toUtc = DateTime.utc(to.year, to.month, to.day);
    return toUtc.difference(fromUtc).inDays;
  }

  /// Current day in the menstrual cycle (1 to cycleLength)
  int get currentCycleDay {
    final now = DateTime.now();
    final cleanNow = DateTime(now.year, now.month, now.day);
    final diff = daysDifference(normalizedLmp, cleanNow);
    if (diff < 0) return 1;
    return (diff % cycleLength) + 1;
  }

  /// Estimated Next Period Date: First day of last period + cycle length
  DateTime get estimatedNextPeriod {
    final lmp = normalizedLmp;
    return DateTime(lmp.year, lmp.month, lmp.day + cycleLength);
  }

  /// Next Upcoming Period Date (advances to today or future for overdue tracking)
  DateTime get upcomingNextPeriod {
    final now = DateTime.now();
    final cleanNow = DateTime(now.year, now.month, now.day);
    var next = estimatedNextPeriod;
    while (next.isBefore(cleanNow)) {
      next = DateTime(next.year, next.month, next.day + cycleLength);
    }
    return next;
  }

  /// Estimated Ovulation Day: Approximately 14 days before next expected period
  DateTime get estimatedOvulationDate {
    final next = estimatedNextPeriod;
    return DateTime(next.year, next.month, next.day - 14);
  }

  /// Next Upcoming Ovulation Day: Approximately 14 days before upcoming next period
  DateTime get upcomingOvulationDate {
    final next = upcomingNextPeriod;
    return DateTime(next.year, next.month, next.day - 14);
  }

  /// 1-based cycle day of ovulation (e.g. Day 15 for 28-day cycle: 28 - 14 + 1)
  int get ovulationCycleDay => cycleLength - 14 + 1;

  /// Estimated Fertile Window Start (5 days before ovulation)
  DateTime get fertileWindowStart {
    final ov = estimatedOvulationDate;
    return DateTime(ov.year, ov.month, ov.day - 5);
  }

  /// Estimated Fertile Window End (1 day after ovulation)
  DateTime get fertileWindowEnd {
    final ov = estimatedOvulationDate;
    return DateTime(ov.year, ov.month, ov.day + 1);
  }

  /// Next Upcoming Fertile Window Start (5 days before upcoming ovulation)
  DateTime get upcomingFertileWindowStart {
    final ov = upcomingOvulationDate;
    return DateTime(ov.year, ov.month, ov.day - 5);
  }

  /// Next Upcoming Fertile Window End (1 day after upcoming ovulation)
  DateTime get upcomingFertileWindowEnd {
    final ov = upcomingOvulationDate;
    return DateTime(ov.year, ov.month, ov.day + 1);
  }

  /// 1-based cycle day for start of fertile window
  int get fertileStartCycleDay => ovulationCycleDay - 5;

  /// 1-based cycle day for end of fertile window
  int get fertileEndCycleDay => ovulationCycleDay + 1;

  /// Checks if a date falls inside the fertile window
  bool isFertileDay(DateTime date) {
    if (!isSetup) return false;
    final cleanDate = DateTime(date.year, date.month, date.day);
    final diff = daysDifference(normalizedLmp, cleanDate);
    final dayInCycle = (((diff % cycleLength) + cycleLength) % cycleLength) + 1;
    return dayInCycle >= fertileStartCycleDay && dayInCycle <= fertileEndCycleDay;
  }

  /// Checks if a date is ovulation day
  bool isOvulationDay(DateTime date) {
    if (!isSetup) return false;
    final cleanDate = DateTime(date.year, date.month, date.day);
    final diff = daysDifference(normalizedLmp, cleanDate);
    final dayInCycle = (((diff % cycleLength) + cycleLength) % cycleLength) + 1;
    return dayInCycle == ovulationCycleDay;
  }

  /// Checks if a date is a logged or predicted period day
  bool isPeriodDay(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    // Check logged days
    for (final logged in loggedPeriodDays) {
      if (logged.year == cleanDate.year &&
          logged.month == cleanDate.month &&
          logged.day == cleanDate.day) {
        return true;
      }
    }
    if (!isSetup) return false;
    // Check recurring cycle bleeding window across past and future cycles
    final diff = daysDifference(normalizedLmp, cleanDate);
    final dayInCycle = (((diff % cycleLength) + cycleLength) % cycleLength) + 1;
    return dayInCycle <= periodDuration;
  }

  Map<String, dynamic> toJson() {
    return {
      'lastPeriodDate': lastPeriodDate.toIso8601String(),
      'cycleLength': cycleLength,
      'periodDuration': periodDuration,
      'loggedPeriodDays':
          loggedPeriodDays.map((d) => d.toIso8601String()).toList(),
      'pastCycles': pastCycles,
      'isSetup': isSetup,
    };
  }

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.parse(json['lastPeriodDate'])
          : DateTime.now().subtract(const Duration(days: 14)),
      cycleLength: json['cycleLength'] as int? ?? 28,
      periodDuration: json['periodDuration'] as int? ?? 5,
      loggedPeriodDays: (json['loggedPeriodDays'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d as String))
              .toList() ??
          [],
      pastCycles: (json['pastCycles'] as List<dynamic>?)
              ?.map((c) => Map<String, dynamic>.from(c as Map))
              .toList() ??
          [],
      isSetup: json['isSetup'] as bool? ?? (json['lastPeriodDate'] != null),
    );
  }

  PeriodData copyWith({
    DateTime? lastPeriodDate,
    int? cycleLength,
    int? periodDuration,
    List<DateTime>? loggedPeriodDays,
    List<Map<String, dynamic>>? pastCycles,
    bool? isSetup,
  }) {
    return PeriodData(
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodDuration: periodDuration ?? this.periodDuration,
      loggedPeriodDays: loggedPeriodDays ?? this.loggedPeriodDays,
      pastCycles: pastCycles ?? this.pastCycles,
      isSetup: isSetup ?? this.isSetup,
    );
  }
}
