import 'period.dart';

class AppSettings {
  AppSettings({
    required this.semesterStart,
    required this.semesterEnd,
    required this.weekStartDay,
    required this.periods,
    required this.reminderEnabled,
    required this.reminderMinutes,
    required this.themeMode,
    required this.themePreset,
  });

  final DateTime semesterStart;
  final DateTime semesterEnd;
  final int weekStartDay;
  final List<Period> periods;
  final bool reminderEnabled;
  final int reminderMinutes;
  final String themeMode;
  final String themePreset;

  int get periodCount => periods.length;

  AppSettings copyWith({
    DateTime? semesterStart,
    DateTime? semesterEnd,
    int? weekStartDay,
    List<Period>? periods,
    bool? reminderEnabled,
    int? reminderMinutes,
    String? themeMode,
    String? themePreset,
  }) {
    return AppSettings(
      semesterStart: semesterStart ?? this.semesterStart,
      semesterEnd: semesterEnd ?? this.semesterEnd,
      weekStartDay: weekStartDay ?? this.weekStartDay,
      periods: periods ?? this.periods,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      themeMode: themeMode ?? this.themeMode,
      themePreset: themePreset ?? this.themePreset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'semesterStart': semesterStart.toIso8601String(),
      'semesterEnd': semesterEnd.toIso8601String(),
      'weekStartDay': weekStartDay,
      'periods': periods.map((p) => p.toMap()).toList(),
      'reminderEnabled': reminderEnabled,
      'reminderMinutes': reminderMinutes,
      'themeMode': themeMode,
      'themePreset': themePreset,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return AppSettings.defaults();
    }

    final startRaw = map['semesterStart']?.toString();
    final endRaw = map['semesterEnd']?.toString();
    final start = DateTime.tryParse(startRaw ?? '') ?? DateTime.now();
    final end = DateTime.tryParse(endRaw ?? '') ?? start.add(const Duration(days: 140));
    final weekStartDay = map['weekStartDay'] is int ? map['weekStartDay'] as int : 1;

    final periodList = <Period>[];
    final periodsRaw = map['periods'];
    if (periodsRaw is List) {
      for (var i = 0; i < periodsRaw.length; i += 1) {
        final item = periodsRaw[i];
        if (item is Map) {
          periodList.add(Period.fromMap(item, i + 1));
        }
      }
    }

    final periods = periodList.isEmpty ? AppSettings.defaults().periods : periodList;

    return AppSettings(
      semesterStart: DateTime(start.year, start.month, start.day),
      semesterEnd: DateTime(end.year, end.month, end.day),
      weekStartDay: weekStartDay,
      periods: periods,
      reminderEnabled: map['reminderEnabled'] is bool
          ? map['reminderEnabled'] as bool
          : false,
      reminderMinutes: map['reminderMinutes'] is int
          ? map['reminderMinutes'] as int
          : 10,
      themeMode: map['themeMode']?.toString() ?? 'system',
      themePreset: map['themePreset']?.toString() ?? 'ocean',
    );
  }

  factory AppSettings.defaults() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 140));
    return AppSettings(
      semesterStart: start,
      semesterEnd: end,
      weekStartDay: 1,
      periods: const [
        Period(index: 1, startTime: '08:00', endTime: '08:45'),
        Period(index: 2, startTime: '08:55', endTime: '09:40'),
        Period(index: 3, startTime: '10:00', endTime: '10:45'),
        Period(index: 4, startTime: '10:55', endTime: '11:40'),
        Period(index: 5, startTime: '14:00', endTime: '14:45'),
        Period(index: 6, startTime: '14:55', endTime: '15:40'),
        Period(index: 7, startTime: '16:00', endTime: '16:45'),
        Period(index: 8, startTime: '16:55', endTime: '17:40'),
      ],
      reminderEnabled: false,
      reminderMinutes: 10,
      themeMode: 'system',
      themePreset: 'ocean',
    );
  }
}
