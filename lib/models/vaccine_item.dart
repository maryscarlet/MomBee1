class VaccineItem {
  final String id;
  final String name;
  final String targetAudience; // 'গর্ভকালীন', 'নবজাতক', '১.৫ মাস', '২.৫ মাস', '৩.৫ মাস', '৯ মাস', '১৫ মাস'
  final String schedule;
  final String description;
  final bool isCompleted;
  final DateTime? completedDate;

  const VaccineItem({
    required this.id,
    required this.name,
    required this.targetAudience,
    required this.schedule,
    required this.description,
    this.isCompleted = false,
    this.completedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAudience': targetAudience,
      'schedule': schedule,
      'description': description,
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  factory VaccineItem.fromJson(Map<String, dynamic> json) {
    return VaccineItem(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAudience: json['targetAudience'] as String,
      schedule: json['schedule'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'] as String)
          : null,
    );
  }

  VaccineItem copyWith({
    String? id,
    String? name,
    String? targetAudience,
    String? schedule,
    String? description,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return VaccineItem(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAudience: targetAudience ?? this.targetAudience,
      schedule: schedule ?? this.schedule,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}
