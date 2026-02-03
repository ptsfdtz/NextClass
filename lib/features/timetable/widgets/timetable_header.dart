import 'package:flutter/material.dart';

import '../../../data/models/app_settings.dart';

class TimetableHeader extends StatelessWidget {
  const TimetableHeader({super.key, required this.settings, this.onAdd});

  final AppSettings settings;
  final VoidCallback? onAdd;

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _formatDate(DateTime date) {
    final year = date.year;
    final month = _twoDigits(date.month);
    final day = _twoDigits(date.day);
    return '$year/$month/$day';
  }

  String _weekdayLabel(int weekday) {
    const labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return labels[(weekday - 1) % 7];
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _weekStart(DateTime date, int weekStartDay) {
    final normalized = (weekStartDay == 7) ? 7 : 1;
    var delta = date.weekday - normalized;
    if (delta < 0) {
      delta += 7;
    }
    return date.subtract(Duration(days: delta));
  }

  int _semesterWeekNumber(DateTime today) {
    final start = _dateOnly(settings.semesterStart);
    final anchor = _weekStart(start, settings.weekStartDay);
    final now = _dateOnly(today);
    final diffDays = now.difference(anchor).inDays;
    final week = diffDays ~/ 7 + 1;
    return week < 1 ? 1 : week;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekNumber = _semesterWeekNumber(today);
    final weekday = _weekdayLabel(today.weekday);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(today),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '第 $weekNumber 周 · $weekday',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          tooltip: '新增课程',
        ),
      ],
    );
  }
}
