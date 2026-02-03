import '../models/course.dart';
import '../repositories/course_repository.dart';

class LocalCourseRepository implements CourseRepository {
  final List<Course> _cache = [];

  @override
  Future<List<Course>> fetchCourses() async {
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> saveCourse(Course course) async {
    _cache.removeWhere((item) => item.id == course.id);
    _cache.add(course);
  }

  @override
  Future<void> deleteCourse(String id) async {
    _cache.removeWhere((item) => item.id == id);
  }
}
