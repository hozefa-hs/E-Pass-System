enum PassType {
  STUDENT,
  SENIOR_CITIZEN,
  CORPORATE;
  
  static PassType fromString(String passType) {
    switch (passType) {
      case 'STUDENT':
        return PassType.STUDENT;
      case 'SENIOR_CITIZEN':
        return PassType.SENIOR_CITIZEN;
      case 'CORPORATE':
        return PassType.CORPORATE;
      default:
        throw ArgumentError('Invalid pass type: $passType');
    }
  }
  
  String toApiString() {
    switch (this) {
      case PassType.STUDENT:
        return 'STUDENT';
      case PassType.SENIOR_CITIZEN:
        return 'SENIOR_CITIZEN';
      case PassType.CORPORATE:
        return 'CORPORATE';
    }
  }
  
  String get displayName {
    switch (this) {
      case PassType.STUDENT:
        return 'Student Pass';
      case PassType.SENIOR_CITIZEN:
        return 'Senior Citizen Pass';
      case PassType.CORPORATE:
        return 'Corporate Pass';
    }
  }
}

enum PassDuration {
  ONE_MONTH(1),
  THREE_MONTHS(3),
  SIX_MONTHS(6);
  
  final int months;
  
  const PassDuration(this.months);
  
  static PassDuration fromString(String duration) {
    switch (duration) {
      case 'ONE_MONTH':
        return PassDuration.ONE_MONTH;
      case 'THREE_MONTHS':
        return PassDuration.THREE_MONTHS;
      case 'SIX_MONTHS':
        return PassDuration.SIX_MONTHS;
      default:
        throw ArgumentError('Invalid duration: $duration');
    }
  }
  
  String toApiString() {
    switch (this) {
      case PassDuration.ONE_MONTH:
        return 'ONE_MONTH';
      case PassDuration.THREE_MONTHS:
        return 'THREE_MONTHS';
      case PassDuration.SIX_MONTHS:
        return 'SIX_MONTHS';
    }
  }
  
  String get displayName {
    switch (this) {
      case PassDuration.ONE_MONTH:
        return '1 Month';
      case PassDuration.THREE_MONTHS:
        return '3 Months';
      case PassDuration.SIX_MONTHS:
        return '6 Months';
    }
  }
}

enum PassStatus {
  PENDING,
  APPROVED,
  REJECTED;
  
  static PassStatus fromString(String status) {
    switch (status) {
      case 'PENDING':
        return PassStatus.PENDING;
      case 'APPROVED':
        return PassStatus.APPROVED;
      case 'REJECTED':
        return PassStatus.REJECTED;
      default:
        throw ArgumentError('Invalid pass status: $status');
    }
  }
  
  String get displayName {
    switch (this) {
      case PassStatus.PENDING:
        return 'Pending';
      case PassStatus.APPROVED:
        return 'Approved';
      case PassStatus.REJECTED:
        return 'Rejected';
    }
  }
  
  String get displayColor {
    switch (this) {
      case PassStatus.PENDING:
        return 'orange';
      case PassStatus.APPROVED:
        return 'green';
      case PassStatus.REJECTED:
        return 'red';
    }
  }
}

class Pass {
  final String id;
  final String userId;
  final PassType passType;
  final PassDuration duration;
  final PassStatus status;
  final String? validFrom;
  final String? validTill;
  final String createdAt;
  final String? updatedAt;
  final bool isActive;

  Pass({
    required this.id,
    required this.userId,
    required this.passType,
    required this.duration,
    required this.status,
    this.validFrom,
    this.validTill,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });

  factory Pass.fromJson(Map<String, dynamic> json) {
    return Pass(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      passType: PassType.fromString(json['passType'] ?? ''),
      duration: PassDuration.fromString(json['duration'] ?? ''),
      status: PassStatus.fromString(json['status'] ?? ''),
      validFrom: json['validFrom'],
      validTill: json['validTill'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'passType': passType.toApiString(),
      'duration': duration.toApiString(),
      'status': status.toString().split('.').last,
      'validFrom': validFrom,
      'validTill': validTill,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }
}

class PassRequest {
  final PassType passType;
  final PassDuration duration;

  PassRequest({
    required this.passType,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'passType': passType.toApiString(),
      'duration': duration.toApiString(),
    };
  }
}
