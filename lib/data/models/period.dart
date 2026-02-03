class Period {
  const Period({
    required this.index,
    required this.startTime,
    required this.endTime,
  });

  final int index;
  final String startTime;
  final String endTime;

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Period.fromMap(Map<dynamic, dynamic> map, int fallbackIndex) {
    return Period(
      index: map['index'] is int ? map['index'] as int : fallbackIndex,
      startTime: map['startTime']?.toString() ?? '08:00',
      endTime: map['endTime']?.toString() ?? '08:45',
    );
  }
}
