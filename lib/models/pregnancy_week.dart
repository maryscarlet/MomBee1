class PregnancyWeek {
  final int weekNumber;
  final int trimester;
  final String babySizeComparison;
  final String babyLength;
  final String babyWeight;
  final String babyDevelopment;
  final String motherChanges;
  final String nutrition;
  final String healthAndCare;
  final List<String> weeklyTodos;
  final List<String> warningSigns;
  final List<String> checklist;
  final String fruitIconName;

  const PregnancyWeek({
    required this.weekNumber,
    required this.trimester,
    required this.babySizeComparison,
    required this.babyLength,
    required this.babyWeight,
    required this.babyDevelopment,
    required this.motherChanges,
    required this.nutrition,
    required this.healthAndCare,
    required this.weeklyTodos,
    required this.warningSigns,
    required this.checklist,
    this.fruitIconName = 'child_care',
  });

  String get trimesterBangla {
    switch (trimester) {
      case 1:
        return '১ম ট্রাইমেস্টার';
      case 2:
        return '২য় ট্রাইমেস্টার';
      case 3:
        return '৩য় ট্রাইমেস্টার';
      default:
        return '$trimester ট্রাইমেস্টার';
    }
  }

  String get weekNumberBangla {
    const digits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    final weekStr = weekNumber.toString();
    return weekStr.split('').map((c) => digits[int.parse(c)]).join();
  }
}
