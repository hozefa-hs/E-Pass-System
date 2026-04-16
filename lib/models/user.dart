enum Role {
  PASSENGER,
  ADMIN,
  TICKET_CHECKER;
  
  static Role fromString(String role) {
    switch (role.toLowerCase()) {
      case 'passenger':
        return Role.PASSENGER;
      case 'admin':
        return Role.ADMIN;
      case 'ticket_checker':
        return Role.TICKET_CHECKER;
      default:
        throw ArgumentError('Invalid role: $role');
    }
  }
  
  String toApiString() {
    switch (this) {
      case Role.PASSENGER:
        return 'PASSENGER';
      case Role.ADMIN:
        return 'ADMIN';
      case Role.TICKET_CHECKER:
        return 'TICKET_CHECKER';
    }
  }
}

class User {
  final String id;
  final String email;
  final Role role;
  final String token;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      role: Role.fromString(json['role'] ?? ''),
      token: json['token'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.toApiString(),
      'token': token,
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? email,
    Role? role,
    String? token,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      isActive: isActive ?? this.isActive,
    );
  }
}
