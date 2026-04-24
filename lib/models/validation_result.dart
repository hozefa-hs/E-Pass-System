import 'package:e_pass_system/models/pass.dart';

class ValidationResult {
  final String passId;
  final bool valid;
  final PassStatus? status;
  final PassType? passType;
  final PassDuration? passDuration;
  final String message;
  final String validatedAt;

  ValidationResult({
    required this.passId,
    required this.valid,
    this.status,
    this.passType,
    this.passDuration,
    required this.message,
    required this.validatedAt,
  });

  factory ValidationResult.fromJson(Map<String, dynamic> json) {
    return ValidationResult(
      passId: json['passId'] ?? '',
      valid: json['valid'] ?? false,
      status: json['status'] != null ? PassStatus.fromString(json['status']) : null,
      passType: json['passType'] != null ? PassType.fromString(json['passType']) : null,
      passDuration: json['passDuration'] != null ? PassDuration.fromString(json['passDuration']) : null,
      message: json['message'] ?? '',
      validatedAt: json['validatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passId': passId,
      'valid': valid,
      'status': status?.toString().split('.').last,
      'passType': passType?.toApiString(),
      'passDuration': passDuration?.toApiString(),
      'message': message,
      'validatedAt': validatedAt,
    };
  }

  String get displayColor {
    if (valid) return 'green';
    if (status == PassStatus.PENDING) return 'orange';
    return 'red';
  }

  String get displayTitle {
    if (valid) return 'PASS VALID';
    if (status == PassStatus.PENDING) return 'PASS PENDING';
    return 'PASS INVALID';
  }

  String get displaySubtitle {
    if (valid) return 'Allow Travel';
    return 'Deny Travel';
  }
}
