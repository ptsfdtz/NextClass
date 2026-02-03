import 'package:flutter/material.dart';

import '../../../data/models/course.dart';
import '../../../data/models/period.dart';
import '../models/timetable_models.dart';

class TimetableGrid extends StatelessWidget {
  static const int _days = 7;
  static const double _timeColumnWidth = 44;
  static const double _cellHeight = 88;
  static const double _rowGap = 4;
  static const double _columnGap = 4;
  static const double _timeColumnGap = 6;

  final List<String> _dayLabels = const [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  const TimetableGrid({super.key, required this.courses, required this.periods});

  final List<Course> courses;
  final List<Period> periods;

  @override
  Widget build(BuildContext context) {
    final blocksByDay = <int, List<CourseBlock>>{};
    final periodCount = periods.isEmpty ? 8 : periods.length;
    for (final course in courses) {
      if (course.weekday < 1 || course.weekday > _days) {
        continue;
      }
      if (course.startPeriod < 1 || course.startPeriod > periodCount) {
        continue;
      }
      final normalizedEnd = course.endPeriod.clamp(1, periodCount);
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
                  _buildTimeColumn(periods),
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
                        periodCount: periodCount,
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
              borderRadius: BorderRadius.circular(8),
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

  Widget _buildTimeColumn(List<Period> periods) {
    return Column(
      children: List.generate(periods.length, (index) {
        final period = index + 1;
        final time = periods[index];
        return Padding(
          padding:
              EdgeInsets.only(bottom: index == periods.length - 1 ? 0 : _rowGap),
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
                  '${time.startTime}\n${time.endTime}',
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
    required int periodCount,
  }) {
    final children = <Widget>[];
    var period = 1;
    while (period <= periodCount) {
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
        final span =
            (block.endPeriod - block.startPeriod + 1).clamp(1, periodCount);
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

      if (period <= periodCount) {
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
    final contentWidth = width - 12;
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: block.color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: block.color.withOpacity(0.6)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: contentWidth > 0 ? contentWidth : width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.name,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: block.color,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                block.room,
                softWrap: true,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
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
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
