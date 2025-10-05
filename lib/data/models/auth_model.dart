import '../../domain/entities/auth_entity.dart';

/// Authentication data model
class AuthModel {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final bool isNewUser;

  const AuthModel({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.isNewUser,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isNewUser: json['isNewUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'isNewUser': isNewUser,
    };
  }

  // Convert to entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
      isNewUser: isNewUser,
    );
  }

  // Create from entity
  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      userId: entity.userId,
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
      expiresAt: entity.expiresAt,
      isNewUser: entity.isNewUser,
    );
  }
}

/// OTP response model
class OtpResponseModel {
  final bool success;
  final String message;
  final String? requestId;
  final int? expiresInSeconds;
  final int? resendAfterSeconds;

  const OtpResponseModel({
    required this.success,
    required this.message,
    this.requestId,
    this.expiresInSeconds,
    this.resendAfterSeconds,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      requestId: json['requestId'] as String?,
      expiresInSeconds: json['expiresInSeconds'] as int?,
      resendAfterSeconds: json['resendAfterSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'requestId': requestId,
      'expiresInSeconds': expiresInSeconds,
      'resendAfterSeconds': resendAfterSeconds,
    };
  }
}

/// OTP verification request model
class OtpVerificationRequestModel {
  final String phoneNumber;
  final String otp;
  final String? deviceId;
  final String? deviceName;
  final String? deviceType;
  final String? fcmToken;
  final String? appVersion;

  const OtpVerificationRequestModel({
    required this.phoneNumber,
    required this.otp,
    this.deviceId,
    this.deviceName,
    this.deviceType,
    this.fcmToken,
    this.appVersion,
  });

  factory OtpVerificationRequestModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationRequestModel(
      phoneNumber: json['phoneNumber'] as String,
      otp: json['otp'] as String,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceType: json['deviceType'] as String?,
      fcmToken: json['fcmToken'] as String?,
      appVersion: json['appVersion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'fcmToken': fcmToken,
      'appVersion': appVersion,
    };
  }
}
