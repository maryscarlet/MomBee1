import 'dart:convert';

/// Category of in-app notification logs
class NotificationCategory {
  static const String water = 'water';
  static const String dailyCare = 'daily_care';
  static const String appointment = 'appointment';
  static const String vaccine = 'vaccine';
  static const String general = 'general';
}

/// A persistent log of notifications delivered to or scheduled for the user.
/// Stored locally to allow reading history in the in-app Notification Center.
class NotificationLogItem {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime timestamp;
  final bool isRead;
  final String? payload;

  const NotificationLogItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.timestamp,
    this.isRead = false,
    this.payload,
  });

  NotificationLogItem copyWith({
    String? id,
    String? title,
    String? body,
    String? category,
    DateTime? timestamp,
    bool? isRead,
    String? payload,
  }) {
    return NotificationLogItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      if (payload != null) 'payload': payload,
    };
  }

  factory NotificationLogItem.fromJson(Map<String, dynamic> json) {
    return NotificationLogItem(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? NotificationCategory.general,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
      payload: json['payload'] as String?,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory NotificationLogItem.fromJsonString(String source) =>
      NotificationLogItem.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
