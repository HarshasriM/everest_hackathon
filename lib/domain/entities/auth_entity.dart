import 'user_entity.dart';

/// Authentication related entities
class AuthEntity {
  final String userId;
  final String? sid; // Session ID from OTP send
  final bool isProfileComplete;
  final UserEntity? user;

  const AuthEntity({
    required this.userId,
    this.sid,
    required this.isProfileComplete,
    this.user,
  });
}

/// OTP request entity
class OtpRequestEntity {
  final String phoneNumber;
  final String countryCode;
  final OtpPurpose purpose;

  const OtpRequestEntity({
    required this.phoneNumber,
    this.countryCode = '+91',
    this.purpose = OtpPurpose.login,
  });

  String get fullPhoneNumber => '$countryCode$phoneNumber';
}

/// OTP verification entity
class OtpVerificationEntity {
  final String phoneNumber;
  final String otp;
  final String? deviceId;
  final String? deviceName;
  final String? fcmToken;

  const OtpVerificationEntity({
    required this.phoneNumber,
    required this.otp,
    this.deviceId,
    this.deviceName,
    this.fcmToken,
  });
}

/// OTP purpose enum
enum OtpPurpose {
  login,
  registration,
  passwordReset,
  phoneVerification,
  emergencyAccess,
}
