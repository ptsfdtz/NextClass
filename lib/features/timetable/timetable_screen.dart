import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_course_repository.dart';
import '../../data/models/course.dart';
import '../courses/course_form_sheet.dart';
import 'widgets/timetable_grid.dart';
import 'widgets/timetable_header.dart';

class TimetableScreen extends StatelessWidget {
  TimetableScreen({super.key});

  final _repository = HiveCourseRepository();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Map>('courses');
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6F7FB), Color(0xFFEAF1FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: TimetableHeader(onAdd: () => _openForm(context)),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 16, 16),
                child: ValueListenableBuilder<Box<Map>>(
                  valueListenable: box.listenable(),
                  builder: (context, value, child) {
                    final courses = value.values.map(Course.fromMap).toList();
                    return TimetableGrid(courses: courses);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
