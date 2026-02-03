class Course {
  Course({
    required this.id,
    required this.name,
    this.teacher,
    required this.location,
    required this.weekday,
    required this.startPeriod,
    required this.endPeriod,
    required this.weekStart,
    required this.weekEnd,
    required this.colorHex,
    this.note,
    this.reminderEnabled = false,
    this.reminderMinutes = 10,
  });

  final String id;
  final String name;
  final String? teacher;
  final String location;
  final int weekday;
  final int startPeriod;
  final int endPeriod;
  final int weekStart;
  final int weekEnd;
  final int colorHex;
  final String? note;
  final bool reminderEnabled;
  final int reminderMinutes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'teacher': teacher,
      'location': location,
      'weekday': weekday,
      'startPeriod': startPeriod,
      'endPeriod': endPeriod,
      'weekStart': weekStart,
      'weekEnd': weekEnd,
      'colorHex': colorHex,
      'note': note,
      'reminderEnabled': reminderEnabled,
      'reminderMinutes': reminderMinutes,
    };
  }

  factory Course.fromMap(Map<dynamic, dynamic> map) {
    return Course(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      teacher: map['teacher']?.toString(),
      location: map['location']?.toString() ?? '',
      weekday: map['weekday'] is int ? map['weekday'] as int : 1,
      startPeriod: map['startPeriod'] is int ? map['startPeriod'] as int : 1,
      endPeriod: map['endPeriod'] is int ? map['endPeriod'] as int : 1,
      weekStart: map['weekStart'] is int ? map['weekStart'] as int : 1,
      weekEnd: map['weekEnd'] is int ? map['weekEnd'] as int : 20,
      colorHex:
          map['colorHex'] is int ? map['colorHex'] as int : 0xFF5B8DEF,
      note: map['note']?.toString(),
      reminderEnabled: map['reminderEnabled'] is bool
          ? map['reminderEnabled'] as bool
          : false,
      reminderMinutes: map['reminderMinutes'] is int
          ? map['reminderMinutes'] as int
          : 10,
    );
  }
}
