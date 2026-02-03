import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_course_repository.dart';
import '../../data/models/course.dart';
import 'course_form_sheet.dart';

class CourseListScreen extends StatelessWidget {
  CourseListScreen({super.key});

  final _repository = HiveCourseRepository();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Map>('courses');
    return Scaffold(
      appBar: AppBar(
        title: const Text('课程'),
        actions: [
          IconButton(
            onPressed: () => _openForm(context),
            icon: const Icon(Icons.add),
            tooltip: '新增课程',
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Map>>(
        valueListenable: box.listenable(),
        builder: (context, value, child) {
          final courses = value.values.map(Course.fromMap).toList()
            ..sort((a, b) {
              final weekdayCompare = a.weekday.compareTo(b.weekday);
              if (weekdayCompare != 0) {
                return weekdayCompare;
              }
              return a.startPeriod.compareTo(b.startPeriod);
            });

          if (courses.isEmpty) {
            return const Center(
              child: Text('暂无课程，点击右上角新增'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return _CourseTile(
                title: course.name,
                subtitle: _formatSubtitle(course),
                color: Color(course.colorHex),
                onTap: () => _openForm(context, initial: course),
                onDelete: () => _repository.deleteCourse(course.id),
              );
            },
          );
        },
      ),
    );
  }

  String _formatSubtitle(Course course) {
    final labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final weekday = labels[(course.weekday - 1) % 7];
    final period = course.startPeriod == course.endPeriod
        ? '第 ${course.startPeriod} 节'
        : '${course.startPeriod}-${course.endPeriod} 节';
    return '$weekday $period · ${course.location}';
  }

  Future<void> _openForm(BuildContext context, {Course? initial}) async {
    final result = await showModalBottomSheet<Course>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CourseFormSheet(initial: initial),
    );

    if (result != null) {
      await _repository.saveCourse(result);
    }
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Container(
          width: 8,
          height: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: '删除',
        ),
      ),
    );
  }
}
