enum JourneyType {
  planning,
  pregnant,
  baby,
  general,
}

extension JourneyTypeExtension on JourneyType {
  String get id {
    switch (this) {
      case JourneyType.planning:
        return 'planning';
      case JourneyType.pregnant:
        return 'pregnant';
      case JourneyType.baby:
        return 'baby';
      case JourneyType.general:
        return 'general';
    }
  }

  String get titleBangla {
    switch (this) {
      case JourneyType.planning:
        return 'গর্ভধারণের পরিকল্পনা করছি';
      case JourneyType.pregnant:
        return 'আমি গর্ভবতী';
      case JourneyType.baby:
        return 'আমার শিশু আছে';
      case JourneyType.general:
        return 'শুধু তথ্য জানতে চাই';
    }
  }

  String get titleEnglish {
    switch (this) {
      case JourneyType.planning:
        return 'Planning Pregnancy';
      case JourneyType.pregnant:
        return 'I am Pregnant';
      case JourneyType.baby:
        return 'I have a Baby';
      case JourneyType.general:
        return 'General Information';
    }
  }

  String get badgeBangla {
    switch (this) {
      case JourneyType.planning:
        return 'গর্ভধারণের প্রস্তুতি';
      case JourneyType.pregnant:
        return 'গর্ভাবস্থা';
      case JourneyType.baby:
        return 'শিশুর যত্ন';
      case JourneyType.general:
        return 'তথ্য ও শিক্ষা';
    }
  }

  String get badgeEnglish {
    switch (this) {
      case JourneyType.planning:
        return 'Planning';
      case JourneyType.pregnant:
        return 'Pregnancy';
      case JourneyType.baby:
        return 'Baby Care';
      case JourneyType.general:
        return 'Information';
    }
  }

  static JourneyType fromString(String? id) {
    switch (id) {
      case 'planning':
        return JourneyType.planning;
      case 'baby':
      case 'parenting':
        return JourneyType.baby;
      case 'general':
      case 'info':
        return JourneyType.general;
      case 'pregnant':
      default:
        return JourneyType.pregnant;
    }
  }
}
