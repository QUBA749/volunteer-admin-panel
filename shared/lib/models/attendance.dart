class Attendance {
  final String id;
  final String volunteerId;
  final String eventId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String status;
  final DateTime createdAt;
  final String? volunteerName;
  final String? eventName;

  Attendance({
    required this.id,
    required this.volunteerId,
    required this.eventId,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.createdAt,
    this.volunteerName,
    this.eventName,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String? ?? '',
      volunteerId: json['volunteerId'] as String? ?? '',
      eventId: json['eventId'] as String? ?? '',
      checkIn: json['checkIn'] != null ? DateTime.parse(json['checkIn']) : null,
      checkOut: json['checkOut'] != null ? DateTime.parse(json['checkOut']) : null,
      status: json['status'] as String? ?? 'present',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      volunteerName: json['volunteerName'] as String?,
      eventName: json['eventName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volunteerId': volunteerId,
      'eventId': eventId,
      if (checkIn != null) 'checkIn': checkIn?.toIso8601String(),
      if (checkOut != null) 'checkOut': checkOut?.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      if (volunteerName != null) 'volunteerName': volunteerName,
      if (eventName != null) 'eventName': eventName,
    };
  }
}
