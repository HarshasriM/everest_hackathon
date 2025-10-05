import '../../entities/auth_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for sending OTP to a phone number
class SendOtpUseCase {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  Future<void> call(SendOtpParams params) async {
    // Validate phone number format
    if (params.phoneNumber.length != 10) {
      throw Exception('Invalid phone number format');
    }
    
    // Create OTP request entity
    final request = OtpRequestEntity(
      phoneNumber: params.phoneNumber,
      countryCode: params.countryCode,
      purpose: params.purpose,
    );
    
    // Send OTP via repository
    return await _repository.sendOtp(request);
  }
}

/// Parameters for sending OTP
class SendOtpParams {
  final String phoneNumber;
  final String countryCode;
  final OtpPurpose purpose;

  const SendOtpParams({
    required this.phoneNumber,
    this.countryCode = '+91',
    this.purpose = OtpPurpose.login,
  });
}
