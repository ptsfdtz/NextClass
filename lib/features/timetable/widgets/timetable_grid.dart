import 'package:flutter/material.dart';

import '../../../data/models/course.dart';
import '../models/timetable_models.dart';

class TimetableGrid extends StatelessWidget {
  static const int _days = 7;
  static const int _periods = 8;
  static const double _timeColumnWidth = 44;
  static const double _cellHeight = 88;
  static const double _rowGap = 6;
  static const double _columnGap = 6;
  static const double _timeColumnGap = 8;

  final List<String> _dayLabels = const [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  final List<PeriodTime> _periodTimes = const [
    PeriodTime('08:00', '08:45'),
    PeriodTime('08:55', '09:40'),
    PeriodTime('10:00', '10:45'),
    PeriodTime('10:55', '11:40'),
    PeriodTime('14:00', '14:45'),
    PeriodTime('14:55', '15:40'),
    PeriodTime('16:00', '16:45'),
    PeriodTime('16:55', '17:40'),
  ];

  const TimetableGrid({super.key, required this.courses});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    final blocksByDay = <int, List<CourseBlock>>{};
    for (final course in courses) {
      if (course.weekday < 1 || course.weekday > _days) {
        continue;
      }
      if (course.startPeriod < 1 || course.startPeriod > _periods) {
        continue;
      }
      final normalizedEnd = course.endPeriod.clamp(1, _periods);
      final block = CourseBlock(
        day: course.weekday,
        startPeriod: course.startPeriod,
        endPeriod: normalizedEnd,
        name: course.name,
        room: course.location,
        color: Color(course.colorHex),
      );
      blocksByDay.putIfAbsent(block.day, () => []).add(block);
    }
    for (final dayBlocks in blocksByDay.values) {
      dayBlocks.sort((a, b) => a.startPeriod.compareTo(b.startPeriod));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final dayWidth = (maxWidth -
                _timeColumnWidth -
                _timeColumnGap -
                _columnGap * (_days - 1)) /
            _days;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 350),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 8 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              _buildHeaderRow(dayWidth),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeColumn(),
                  const SizedBox(width: _timeColumnGap),
                  ...List.generate(_days, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == _days - 1 ? 0 : _columnGap,
                      ),
                      child: _buildDayColumn(
                        day: index + 1,
                        width: dayWidth,
                        blocks: blocksByDay[index + 1] ?? const [],
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow(double dayWidth) {
    return Row(
      children: [
        SizedBox(
          width: _timeColumnWidth,
          height: 36,
          child: const Center(
            child: Text(
              '节次',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: _timeColumnGap),
        ...List.generate(_days, (index) {
          return Container(
            width: dayWidth,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(right: index == _days - 1 ? 0 : _columnGap),
            child: Text(
              _dayLabels[index],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTimeColumn() {
    return Column(
      children: List.generate(_periods, (index) {
        final period = index + 1;
        final time = _periodTimes[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == _periods - 1 ? 0 : _rowGap),
          child: SizedBox(
            width: _timeColumnWidth,
            height: _cellHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  period.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${time.start}\n${time.end}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDayColumn({
    required int day,
    required double width,
    required List<CourseBlock> blocks,
  }) {
    final children = <Widget>[];
    var period = 1;
    while (period <= _periods) {
      CourseBlock? block;
      for (final candidate in blocks) {
        if (candidate.startPeriod == period) {
          block = candidate;
          break;
        }
      }

      if (block == null) {
        children.add(_EmptyCell(width: width, height: _cellHeight));
        period += 1;
      } else {
        final span = (block.endPeriod - block.startPeriod + 1).clamp(1, _periods);
        final height = _cellHeight * span + _rowGap * (span - 1).toDouble();
        children.add(
          _CourseCell(
            width: width,
            height: height,
            block: block,
          ),
        );
        period += span;
      }

      if (period <= _periods) {
        children.add(const SizedBox(height: _rowGap));
      }
    }

    return SizedBox(
      width: width,
      child: Column(children: children),
    );
  }
}

class _CourseCell extends StatelessWidget {
  const _CourseCell({
    required this.width,
    required this.height,
    required this.block,
  });

  final double width;
  final double height;
  final CourseBlock block;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: block.color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: block.color.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            block.name,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: block.color,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            block.room,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCell extends StatelessWidget {
  const _EmptyCell({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
