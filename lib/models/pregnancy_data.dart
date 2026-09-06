import '../state/app_state.dart';

class PregnancyData {
  final DateTime? lmpDate;
  final DateTime? eddDate;
  final bool isSetup;

  const PregnancyData({
    this.lmpDate,
    this.eddDate,
    this.isSetup = false,
  });

  /// Calculate Estimated Due Date (280 days after LMP)
  DateTime get estimatedDueDate {
    if (eddDate != null) return eddDate!;
    if (lmpDate != null) {
      return lmpDate!.add(const Duration(days: 280));
    }
    return DateTime.now().add(const Duration(days: 112)); // Default fallback
  }

  /// Calculates current week of pregnancy (1 to 40)
  int calculateCurrentWeek([DateTime? referenceDate]) {
    if (!isSetup || lmpDate == null) return 1;
    final now = referenceDate ?? DateTime.now();
    final differenceInDays = now.difference(lmpDate!).inDays;
    if (differenceInDays < 0) return 1;
    final week = (differenceInDays / 7).floor() + 1;
    return week.clamp(1, 40);
  }

  /// Calculates current day in the current week (1 to 7)
  int calculateCurrentDay([DateTime? referenceDate]) {
    if (!isSetup || lmpDate == null) return 3;
    final now = referenceDate ?? DateTime.now();
    final differenceInDays = now.difference(lmpDate!).inDays;
    if (differenceInDays < 0) return 1;
    return (differenceInDays % 7) + 1;
  }

  /// Calculates trimester (1, 2, or 3)
  int calculateTrimester([DateTime? referenceDate]) {
    final week = calculateCurrentWeek(referenceDate);
    if (week <= 13) return 1;
    if (week <= 27) return 2;
    return 3;
  }

  /// Calculates overall progress from 0.0 to 1.0
  double calculateProgress([DateTime? referenceDate]) {
    if (!isSetup || lmpDate == null) return 0.60;
    final now = referenceDate ?? DateTime.now();
    final differenceInDays = now.difference(lmpDate!).inDays;
    if (differenceInDays <= 0) return 0.02;
    final progress = differenceInDays / 280.0;
    return progress.clamp(0.0, 1.0);
  }

  /// Calculates remaining days until delivery
  int calculateRemainingDays([DateTime? referenceDate]) {
    final now = referenceDate ?? DateTime.now();
    final remaining = estimatedDueDate.difference(now).inDays;
    return remaining > 0 ? remaining : 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'lmpDate': lmpDate?.toIso8601String(),
      'eddDate': eddDate?.toIso8601String(),
      'isSetup': isSetup,
    };
  }

  factory PregnancyData.fromJson(Map<String, dynamic> json) {
    return PregnancyData(
      lmpDate: json['lmpDate'] != null ? DateTime.parse(json['lmpDate']) : null,
      eddDate: json['eddDate'] != null ? DateTime.parse(json['eddDate']) : null,
      isSetup: json['isSetup'] as bool? ?? false,
    );
  }
}

String toBanglaDigits(dynamic number) {
  if (AppState.instance.isEnglish) {
    return number.toString();
  }
  const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return number.toString().split('').map((c) {
    final parsed = int.tryParse(c);
    return parsed != null ? digits[parsed] : c;
  }).join();
}
