import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

/// Authentication events using Freezed
@freezed
abstract class AuthEvent with _$AuthEvent {
  /// Check authentication status event
  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;

  /// Send OTP event
  const factory AuthEvent.sendOtp({required String phoneNumber}) = _SendOtp;

  /// Resend OTP event
  const factory AuthEvent.resendOtp({String? phoneNumber}) = _ResendOtp;

  /// Verify OTP event
  const factory AuthEvent.verifyOtp({
    required String phoneNumber,
    required String otp,
  }) = _VerifyOtp;

  /// Update profile event
  const factory AuthEvent.updateProfile({
    required String name,
    String? email,
  }) = _UpdateProfile;
  
  /// Complete profile setup event
  const factory AuthEvent.completeProfileSetup() = _CompleteProfileSetup;

  /// Logout event
  const factory AuthEvent.logout() = _Logout;

  /// Delete account event
  const factory AuthEvent.deleteAccount() = _DeleteAccount;
}
