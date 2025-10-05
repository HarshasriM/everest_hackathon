import '../../entities/auth_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for verifying OTP and authenticating user
class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<AuthEntity> call(VerifyOtpParams params) async {
    // Validate OTP format
    if (params.otp.length != 6 || !RegExp(r'^\d+$').hasMatch(params.otp)) {
      throw Exception('Invalid OTP format');
    }
    
    // Create verification entity
    final verification = OtpVerificationEntity(
      phoneNumber: params.phoneNumber,
      otp: params.otp,
      deviceId: params.deviceId,
      deviceName: params.deviceName,
      fcmToken: params.fcmToken,
    );
    
    // Verify OTP and get auth entity
    return await _repository.verifyOtp(verification);
  }
}

/// Parameters for verifying OTP
class VerifyOtpParams {
  final String phoneNumber;
  final String otp;
  final String? deviceId;
  final String? deviceName;
  final String? fcmToken;

  const VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
    this.deviceId,
    this.deviceName,
    this.fcmToken,
  });
}
