class BabyStage {
  final String id;
  final String title;
  final String ageRange;
  final String physicalGrowth;
  final String cognitiveDevelopment;
  final String feedingGuide;
  final String sleepGuide;
  final List<String> milestones;
  final List<String> careTips;

  const BabyStage({
    required this.id,
    required this.title,
    required this.ageRange,
    required this.physicalGrowth,
    required this.cognitiveDevelopment,
    required this.feedingGuide,
    required this.sleepGuide,
    required this.milestones,
    required this.careTips,
  });
}
