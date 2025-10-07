import '../../domain/entities/auth_entity.dart';
import 'user_model.dart';

/// OTP Send Response Model
class OtpSendResponseModel {
  final String message;
  final String sid;

  const OtpSendResponseModel({
    required this.message,
    required this.sid,
  });

  factory OtpSendResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpSendResponseModel(
      message: json['message'] as String,
      sid: json['sid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sid': sid,
    };
  }
}

/// OTP Verify Response Model (Auth Model)
class AuthModel {
  final String message;
  final String userId;
  final UserModel? user;
  final bool isProfileComplete;

  const AuthModel({
    required this.message,
    required this.userId,
    this.user,
    required this.isProfileComplete,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message'] as String,
      userId: json['userId'] as String,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'user': user?.toJson(),
      'isProfileComplete': isProfileComplete,
    };
  }

  // Convert to entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      isProfileComplete: isProfileComplete,
      user: user?.toEntity(),
    );
  }

  // Create from entity
  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      message: 'Success',
      userId: entity.userId,
      user: entity.user != null ? UserModel.fromEntity(entity.user!) : null,
      isProfileComplete: entity.isProfileComplete,
    );
  }
}

/// OTP request model
class OtpRequestModel {
  final String phoneNumber;

  const OtpRequestModel({
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }
}

/// OTP verification request model
class OtpVerificationRequestModel {
  final String phoneNumber;
  final String otp;

  const OtpVerificationRequestModel({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
    };
  }
}
