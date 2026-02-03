import '../models/course.dart';

abstract class CourseRepository {
  Future<List<Course>> fetchCourses();
  Future<void> saveCourse(Course course);
  Future<void> deleteCourse(String id);
}
