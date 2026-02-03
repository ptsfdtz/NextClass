import 'package:hive/hive.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class HiveCourseRepository implements CourseRepository {
  HiveCourseRepository({Box<Map>? box}) : _box = box ?? Hive.box<Map>('courses');

  final Box<Map> _box;

  @override
  Future<List<Course>> fetchCourses() async {
    return _box.values.map(Course.fromMap).toList();
  }

  @override
  Future<void> saveCourse(Course course) async {
    await _box.put(course.id, course.toMap());
  }

  @override
  Future<void> deleteCourse(String id) async {
    await _box.delete(id);
  }
}
