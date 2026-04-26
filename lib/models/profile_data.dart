import 'package:e_pass_system/models/user.dart';

class ProfileData {
  final String id;
  final String email;
  final Role role;
  final bool isActive;
  final String createdAt;
  final String? lastLoginAt;

  ProfileData({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: Role.fromString(json['role'] ?? ''),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? '',
      lastLoginAt: json['lastLoginAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.toApiString(),
      'isActive': isActive,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
    };
  }

  String get roleDisplayName {
    switch (role) {
      case Role.PASSENGER:
        return 'Passenger';
      case Role.ADMIN:
        return 'Admin';
      case Role.TICKET_CHECKER:
        return 'Ticket Checker';
    }
  }

  String get statusText {
    return isActive ? 'Active' : 'Inactive';
  }

  String get statusColor {
    return isActive ? 'green' : 'red';
  }

  String get formattedCreatedAt {
    if (createdAt.isEmpty) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(createdAt);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdAt;
    }
  }

  String get formattedLastLogin {
    if (lastLoginAt == null || lastLoginAt!.isEmpty) return 'Never';
    try {
      DateTime dateTime = DateTime.parse(lastLoginAt!);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return lastLoginAt ?? 'Never';
    }
  }
}
