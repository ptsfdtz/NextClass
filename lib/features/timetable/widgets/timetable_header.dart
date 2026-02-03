import 'package:flutter/material.dart';

class TimetableHeader extends StatelessWidget {
  const TimetableHeader({super.key, this.onAdd});

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

  int _isoWeekNumber(DateTime date) {
    final weekday = date.weekday;
    final thursday = date.add(Duration(days: 4 - weekday));
    final firstThursday = DateTime(thursday.year, 1, 4);
    final firstThursdayWeekday = firstThursday.weekday;
    final firstWeekThursday =
        firstThursday.add(Duration(days: 4 - firstThursdayWeekday));
    final diffDays = thursday.difference(firstWeekThursday).inDays;
    return diffDays ~/ 7 + 1;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final weekNumber = _isoWeekNumber(today);
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
