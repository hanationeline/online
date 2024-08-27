class Event {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String type;

  Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  // Map 형식으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type,
    };
  }

  // Map에서 Event 객체로 변환하는 팩토리 메서드
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      type: map['type'],
    );
  }

  // copyWith 메서드 추가
  Event copyWith({
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? type,
  }) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
    );
  }
}
