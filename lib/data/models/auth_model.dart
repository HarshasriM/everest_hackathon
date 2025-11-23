import '../../domain/entities/auth_entity.dart';
import 'user_model.dart';

/// OTP Send Response Model
class OtpSendResponseModel {
  final String message;
  final String sid;

  const OtpSendResponseModel({required this.message, required this.sid});

  factory OtpSendResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return OtpSendResponseModel(
        message: json['message']?.toString() ?? 'OTP sent successfully',
        sid: json['sid']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Failed to parse OTP response: $e. JSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'sid': sid};
  }
}

/// OTP Verify Response Model (Auth Model)
class AuthModel {
  final String message;
  final String userId;
  final String? token;
  final UserModel? user;
  final bool isProfileComplete;

  const AuthModel({
    required this.message,
    required this.userId,
    this.token,
    this.user,
    required this.isProfileComplete,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    try {
      return AuthModel(
        message: json['message']?.toString() ?? 'Authentication successful',
        userId: json['userId']?.toString() ?? json['id']?.toString() ?? '',
        token: json['token']?.toString() ?? json['accessToken']?.toString(),
        user: json['user'] != null
            ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : null,
        isProfileComplete:
            json['isProfileComplete'] as bool? ??
            json['profileComplete'] as bool? ??
            false,
      );
    } catch (e) {
      throw Exception('Failed to parse auth response: $e. JSON: $json');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'token': token,
      'user': user?.toJson(),
      'isProfileComplete': isProfileComplete,
    };
  }

  // Convert to entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      token: token,
      isProfileComplete: isProfileComplete,
      user: user?.toEntity(),
    );
  }

  // Create from entity
  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      message: 'Success',
      userId: entity.userId,
      token: entity.token,
      user: entity.user != null ? UserModel.fromEntity(entity.user!) : null,
      isProfileComplete: entity.isProfileComplete,
    );
  }
}

/// OTP request model
class OtpRequestModel {
  final String phoneNumber;

  const OtpRequestModel({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber};
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
    return {'phoneNumber': phoneNumber, 'otp': otp};
  }
}
