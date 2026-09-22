class Event {
  final String id;
  final String eventName;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final DateTime createdAt;
  final int? attendanceCount;

  Event({
    required this.id,
    required this.eventName,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    this.attendanceCount,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String? ?? '',
      eventName: json['eventName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : DateTime.now(),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : DateTime.now(),
      status: json['status'] as String? ?? 'upcoming',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      attendanceCount: json['attendanceCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'description': description,
      'location': location,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      if (attendanceCount != null) 'attendanceCount': attendanceCount,
    };
  }
}
