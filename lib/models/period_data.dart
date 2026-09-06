class PeriodData {
  final DateTime lastPeriodDate;
  final int cycleLength; // Average days e.g. 28
  final int periodDuration; // Days of bleeding e.g. 5
  final List<DateTime> loggedPeriodDays;
  final List<Map<String, dynamic>> pastCycles;

  const PeriodData({
    required this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodDuration = 5,
    this.loggedPeriodDays = const [],
    this.pastCycles = const [],
  });

  /// Current day in the menstrual cycle (1 to cycleLength)
  int get currentCycleDay {
    final now = DateTime.now();
    final cleanNow = DateTime(now.year, now.month, now.day);
    final cleanLmp =
        DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day);
    final difference = cleanNow.difference(cleanLmp).inDays;
    if (difference < 0) return 1;
    return (difference % cycleLength) + 1;
  }

  /// Estimated Next Period Date (always on or after today)
  DateTime get estimatedNextPeriod {
    final now = DateTime.now();
    final cleanNow = DateTime(now.year, now.month, now.day);
    final cleanLmp =
        DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day);
    var next = cleanLmp.add(Duration(days: cycleLength));
    while (next.isBefore(cleanNow)) {
      next = next.add(Duration(days: cycleLength));
    }
    return next;
  }

  /// Estimated Ovulation Day (typically 14 days before next period)
  DateTime get estimatedOvulationDate {
    return estimatedNextPeriod.subtract(const Duration(days: 14));
  }

  /// Estimated Fertile Window Start (5 days before ovulation)
  DateTime get fertileWindowStart {
    return estimatedOvulationDate.subtract(const Duration(days: 5));
  }

  /// Estimated Fertile Window End (1 day after ovulation)
  DateTime get fertileWindowEnd {
    return estimatedOvulationDate.add(const Duration(days: 1));
  }

  /// Checks if a date falls inside fertile window (including recurring future cycles)
  bool isFertileDay(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final cleanLmp =
        DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day);
    final diff = cleanDate.difference(cleanLmp).inDays;
    if (diff < 0) return false;
    final dayInCycle = (diff % cycleLength) + 1;
    final ovulationCycleDay = cycleLength - 14;
    final fertileStart = ovulationCycleDay - 5;
    final fertileEnd = ovulationCycleDay + 1;
    return dayInCycle >= fertileStart && dayInCycle <= fertileEnd;
  }

  /// Checks if a date is ovulation day (including recurring future cycles)
  bool isOvulationDay(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final cleanLmp =
        DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day);
    final diff = cleanDate.difference(cleanLmp).inDays;
    if (diff < 0) return false;
    final dayInCycle = (diff % cycleLength) + 1;
    final ovulationCycleDay = cycleLength - 14;
    return dayInCycle == ovulationCycleDay;
  }

  /// Checks if a date is a logged or predicted period day (including recurring future cycles)
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
    // Check recurring cycle bleeding window
    final cleanLmp =
        DateTime(lastPeriodDate.year, lastPeriodDate.month, lastPeriodDate.day);
    final diff = cleanDate.difference(cleanLmp).inDays;
    if (diff < 0) return false;
    final dayInCycle = (diff % cycleLength) + 1;
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
    );
  }

  PeriodData copyWith({
    DateTime? lastPeriodDate,
    int? cycleLength,
    int? periodDuration,
    List<DateTime>? loggedPeriodDays,
    List<Map<String, dynamic>>? pastCycles,
  }) {
    return PeriodData(
      lastPeriodDate: lastPeriodDate ?? this.lastPeriodDate,
      cycleLength: cycleLength ?? this.cycleLength,
      periodDuration: periodDuration ?? this.periodDuration,
      loggedPeriodDays: loggedPeriodDays ?? this.loggedPeriodDays,
      pastCycles: pastCycles ?? this.pastCycles,
    );
  }
}
