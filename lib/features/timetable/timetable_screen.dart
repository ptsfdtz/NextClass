import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_course_repository.dart';
import '../../data/local/hive_settings_repository.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/course.dart';
import '../courses/course_form_sheet.dart';
import 'widgets/timetable_grid.dart';
import 'widgets/timetable_header.dart';

class TimetableScreen extends StatelessWidget {
  TimetableScreen({super.key});

  final _repository = HiveCourseRepository();
  final _settingsRepository = HiveSettingsRepository();

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Map>('courses');
    final settingsBox = Hive.box<Map>('settings');
    final colorScheme = Theme.of(context).colorScheme;
    final surface = Theme.of(context).scaffoldBackgroundColor;
    final tinted = Color.alphaBlend(
      colorScheme.primary.withOpacity(0.08),
      surface,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [surface, tinted],
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
                child: ValueListenableBuilder<Box<Map>>(
                  valueListenable: settingsBox.listenable(),
                  builder: (context, settingsValue, child) {
                    final settings = _readSettings(settingsValue);
                    return TimetableHeader(
                      settings: settings,
                      onAdd: () =>
                          _openForm(context, maxPeriods: settings.periodCount),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 16, 16),
                child: ValueListenableBuilder<Box<Map>>(
                  valueListenable: settingsBox.listenable(),
                  builder: (context, settingsValue, child) {
                    final settings = _readSettings(settingsValue);
                    return ValueListenableBuilder<Box<Map>>(
                      valueListenable: box.listenable(),
                      builder: (context, value, child) {
                        final courses = value.values.map(Course.fromMap).toList();
                        return TimetableGrid(
                          courses: courses,
                          periods: settings.periods,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppSettings _readSettings(Box<Map> box) {
    final map = box.get('app');
    final settings = AppSettings.fromMap(map);
    if (map == null) {
      _settingsRepository.save(settings);
    }
    return settings;
  }

  Future<void> _openForm(
    BuildContext context, {
    Course? initial,
    required int maxPeriods,
  }) async {
    final result = await showModalBottomSheet<Course>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CourseFormSheet(initial: initial, maxPeriods: maxPeriods),
    );

    if (result != null) {
      await _repository.saveCourse(result);
    }
  }
}
