import 'package:flutter/material.dart';

class CourseBlock {
  const CourseBlock({
    required this.day,
    required this.startPeriod,
    required this.endPeriod,
    required this.name,
    required this.room,
    required this.color,
  });

  final int day;
  final int startPeriod;
  final int endPeriod;
  final String name;
  final String room;
  final Color color;
}
