import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Authentication states using Freezed
@freezed
abstract class AuthState with _$AuthState {
  /// Initial state
  const factory AuthState.initial() = _AuthInitial;
  
  /// Unauthenticated state
  const factory AuthState.unauthenticated() = _AuthUnauthenticated;
  
  /// OTP sending state
  const factory AuthState.otpSending() = _AuthOtpSending;
  
  /// OTP sent state
  const factory AuthState.otpSent({
    required String phoneNumber,
    @Default(30) int resendCooldown,
  }) = _AuthOtpSent;
  
  /// Verifying OTP state
  const factory AuthState.verifyingOtp() = _AuthVerifyingOtp;
  
  /// Authenticated state
  const factory AuthState.authenticated({
    required UserEntity user,
    required bool isNewUser,
  }) = _AuthAuthenticated;
  
  /// Profile incomplete state
  const factory AuthState.profileIncomplete({
    required UserEntity user,
  }) = _AuthProfileIncomplete;
  
  /// Error state
  const factory AuthState.error({
    required String message,
    String? phoneNumber,
  }) = _AuthError;
  
  /// Loading state
  const factory AuthState.loading() = _AuthLoading;
}
