class Volunteer {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String city;
  final List<String> skills;
  final String status;
  final DateTime createdAt;
  final int tasksCompleted;
  final double attendancePct;

  Volunteer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.skills,
    required this.status,
    required this.createdAt,
    this.tasksCompleted = 0,
    this.attendancePct = 0.0,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      tasksCompleted: json['tasksCompleted'] as int? ?? 0,
      attendancePct: (json['attendancePct'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'skills': skills,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'tasksCompleted': tasksCompleted,
      'attendancePct': attendancePct,
    };
  }
}
