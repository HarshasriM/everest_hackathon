import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'auth_event.freezed.dart';

/// Authentication events using Freezed
@freezed
abstract class AuthEvent with _$AuthEvent {
  /// Check authentication status event
  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;
  
  /// Send OTP event
  const factory AuthEvent.sendOtp({
    required String phoneNumber,
  }) = _SendOtp;
  
  /// Resend OTP event
  const factory AuthEvent.resendOtp() = _ResendOtp;
  
  /// Verify OTP event
  const factory AuthEvent.verifyOtp({
    required String phoneNumber,
    required String otp,
  }) = _VerifyOtp;
  
  /// Update profile event
  const factory AuthEvent.updateProfile({
    required String name,
    String? email,
    String? address,
    String? bloodGroup,
  }) = _UpdateProfile;
  
  /// Add emergency contact event
  const factory AuthEvent.addEmergencyContact({
    required EmergencyContactEntity contact,
  }) = _AddEmergencyContact;
  
  /// Remove emergency contact event
  const factory AuthEvent.removeEmergencyContact({
    required String contactId,
  }) = _RemoveEmergencyContact;
  
  /// Complete profile setup event
  const factory AuthEvent.completeProfileSetup() = _CompleteProfileSetup;
  
  /// Logout event
  const factory AuthEvent.logout() = _Logout;
  
  /// Delete account event
  const factory AuthEvent.deleteAccount() = _DeleteAccount;
}
