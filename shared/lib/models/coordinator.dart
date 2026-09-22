class Coordinator {
  final String id;
  final String authUserId;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String status;
  final DateTime createdAt;

  Coordinator({
    required this.id,
    required this.authUserId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.createdAt,
  });

  factory Coordinator.fromJson(Map<String, dynamic> json) {
    return Coordinator(
      id: json['id'] as String? ?? '',
      authUserId: json['authUserId'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'admin',
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authUserId': authUserId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
