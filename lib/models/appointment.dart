class Appointment {
  final String id;
  final String doctorName;
  final DateTime dateTime;
  final String location;
  final String notes;
  final bool isCompleted;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.dateTime,
    required this.location,
    this.notes = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      location: json['location'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Appointment copyWith({
    String? id,
    String? doctorName,
    DateTime? dateTime,
    String? location,
    String? notes,
    bool? isCompleted,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
