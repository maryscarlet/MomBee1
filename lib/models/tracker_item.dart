import 'package:flutter/material.dart';

class TrackerCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final String unit;
  final double currentProgress;

  const TrackerCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    this.unit = '',
    this.currentProgress = 0.0,
  });
}

class JourneyStage {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;

  const JourneyStage({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
  });
}
