import 'pregnancy_data.dart';
import '../state/app_state.dart';

class BabyData {
  final String name;
  final DateTime birthDate;
  final String gender;
  final bool isSetup;

  const BabyData({
    this.name = '',
    required this.birthDate,
    this.gender = 'unspecified',
    this.isSetup = false,
  });

  int get totalDays {
    final now = DateTime.now();
    final diff = now.difference(birthDate).inDays;
    return diff > 0 ? diff : 0;
  }

  int get ageInMonths {
    return (totalDays / 30.44).floor();
  }

  int get ageRemainingDays {
    return (totalDays % 30.44).floor();
  }

  int get ageInYears {
    return (totalDays / 365.25).floor();
  }

  String get ageStringBangla {
    if (!isSetup) return '০ দিন';
    final months = ageInMonths;
    final days = ageRemainingDays;
    final years = ageInYears;

    if (years >= 1) {
      final remMonths = months % 12;
      if (remMonths > 0) {
        return '${toBanglaDigits(years)} বছর ${toBanglaDigits(remMonths)} মাস';
      }
      return '${toBanglaDigits(years)} বছর';
    }

    if (months > 0) {
      if (days > 0) {
        return '${toBanglaDigits(months)} মাস ${toBanglaDigits(days)} দিন';
      }
      return '${toBanglaDigits(months)} মাস';
    }

    return '${toBanglaDigits(totalDays)} দিন';
  }

  String get ageStringEnglish {
    if (!isSetup) return '0 days';
    final months = ageInMonths;
    final days = ageRemainingDays;
    final years = ageInYears;

    if (years >= 1) {
      final remMonths = months % 12;
      if (remMonths > 0) {
        return '$years yr $remMonths mo';
      }
      return '$years yr';
    }

    if (months > 0) {
      if (days > 0) {
        return '$months mo $days d';
      }
      return '$months mo';
    }

    return '$totalDays d';
  }

  String get ageString =>
      AppState.instance.isEnglish ? ageStringEnglish : ageStringBangla;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'isSetup': isSetup,
    };
  }

  factory BabyData.fromJson(Map<String, dynamic> json) {
    return BabyData(
      name: json['name'] as String? ?? '',
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : DateTime.now().subtract(const Duration(days: 132)),
      gender: json['gender'] as String? ?? 'unspecified',
      isSetup: json['isSetup'] as bool? ?? false,
    );
  }

  BabyData copyWith({
    String? name,
    DateTime? birthDate,
    String? gender,
    bool? isSetup,
  }) {
    return BabyData(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      isSetup: isSetup ?? this.isSetup,
    );
  }
}
