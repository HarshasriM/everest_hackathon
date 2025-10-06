import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/auth/send_otp_usecase.dart';
import '../../../domain/usecases/auth/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  Timer? _resendTimer;
  String? _lastPhoneNumber;

  AuthBloc({
    required AuthRepository authRepository,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
  }) : _authRepository = authRepository,
       _sendOtpUseCase = sendOtpUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
        checkAuthStatus: () => _onCheckAuthStatus(emit),
        sendOtp: (phoneNumber) => _onSendOtp(phoneNumber, emit),
        resendOtp: () => _onResendOtp(emit),
        verifyOtp: (phoneNumber, otp) => _onVerifyOtp(phoneNumber, otp, emit),
        updateProfile: (name, email, address, bloodGroup) =>
            _onUpdateProfile(name, email, address, bloodGroup, emit),
        addEmergencyContact: (contact) => _onAddEmergencyContact(contact, emit),
        updateEmergencyContact: (contact) =>
            _onUpdateEmergencyContact(contact, emit),
        removeEmergencyContact: (contactId) =>
            _onRemoveEmergencyContact(contactId, emit),
        completeProfileSetup: () => _onCompleteProfileSetup(emit),
        logout: () => _onLogout(emit),
        deleteAccount: () => _onDeleteAccount(emit),
      );
    });
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }

  Future<void> _onCheckAuthStatus(Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.loading());

      Logger.bloc('AuthBloc', 'CheckAuthStatus');

      final isAuthenticated = await _authRepository.isAuthenticated();

      if (isAuthenticated) {
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          // Check if profile is complete (only name is required)
          if (!user.hasRequiredInfo) {
            emit(AuthState.profileIncomplete(user: user));
          } else {
            emit(AuthState.authenticated(user: user, isNewUser: false));
          }
        } else {
          emit(const AuthState.unauthenticated());
        }
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      Logger.error('Error checking auth status', error: e);
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSendOtp(String phoneNumber, Emitter<AuthState> emit) async {
    try {
      emit(const AuthState.otpSending());

      Logger.bloc('AuthBloc', 'SendOtp', data: {'phone': phoneNumber});

      _lastPhoneNumber = phoneNumber;

      await _sendOtpUseCase(SendOtpParams(phoneNumber: phoneNumber));

      emit(AuthState.otpSent(phoneNumber: phoneNumber, resendCooldown: 30));

      // Start countdown timer
      _startResendTimer(emit);
    } catch (e) {
      Logger.error('Error sending OTP', error: e);
      emit(
        AuthState.error(
          message: e.toString().replaceAll('Exception: ', ''),
          phoneNumber: phoneNumber,
        ),
      );
    }
  }

  Future<void> _onResendOtp(Emitter<AuthState> emit) async {
    if (_lastPhoneNumber != null) {
      await _onSendOtp(_lastPhoneNumber!, emit);
    }
  }

  Future<void> _onVerifyOtp(
    String phoneNumber,
    String otp,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthState.verifyingOtp());

      Logger.bloc(
        'AuthBloc',
        'VerifyOtp',
        data: {'phone': phoneNumber, 'otp': '***${otp.substring(3)}'},
      );

      final authEntity = await _verifyOtpUseCase(
        VerifyOtpParams(phoneNumber: phoneNumber, otp: otp),
      );

      // Fetch user profile
      final user = await _authRepository.getCurrentUser();

      if (user != null) {
        if (authEntity.isNewUser || !user.hasRequiredInfo) {
          emit(AuthState.profileIncomplete(user: user));
        } else {
          emit(
            AuthState.authenticated(
              user: user,
              isNewUser: authEntity.isNewUser,
            ),
          );
        }
      } else {
        // Create new user if not exists
        emit(AuthState.profileIncomplete(user: UserEntity.empty()));
      }
    } catch (e) {
      Logger.error('Error verifying OTP', error: e);
      emit(
        AuthState.error(
          message: e.toString().replaceAll('Exception: ', ''),
          phoneNumber: phoneNumber,
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    String name,
    String? email,
    String? address,
    String? bloodGroup,
    Emitter<AuthState> emit,
  ) async {
    try {
      final currentUser = state.maybeWhen(
        profileIncomplete: (user) => user,
        authenticated: (user, isNewUser) => user,
        orElse: () => null,
      );

      if (currentUser != null) {
        emit(const AuthState.loading());

        Logger.bloc('AuthBloc', 'UpdateProfile', data: {'name': name});

        // Create updated user entity
        final updatedUser = UserEntity(
          id: currentUser.id,
          phoneNumber: currentUser.phoneNumber,
          name: name,
          email: email,
          address: address,
          bloodGroup: bloodGroup,
          emergencyContacts: currentUser.emergencyContacts,
          isProfileComplete: true, // Only name is required
          isVerified: currentUser.isVerified,
          createdAt: currentUser.createdAt,
          lastLoginAt: DateTime.now(),
          settings: currentUser.settings,
          profileImageUrl: currentUser.profileImageUrl,
          dateOfBirth: currentUser.dateOfBirth,
        );

        final savedUser = await _authRepository.updateProfile(updatedUser);

        if (savedUser.hasRequiredInfo) {
          emit(AuthState.authenticated(user: savedUser, isNewUser: false));
        } else {
          emit(AuthState.profileIncomplete(user: savedUser));
        }
      }
    } catch (e) {
      Logger.error('Error updating profile', error: e);
      emit(
        AuthState.error(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onAddEmergencyContact(
    EmergencyContactEntity contact,
    Emitter<AuthState> emit,
  ) async {
    try {
      final hasUser = state.maybeWhen(
        profileIncomplete: (_) => true,
        authenticated: (_, __) => true,
        orElse: () => false,
      );

      if (hasUser) {
        Logger.bloc(
          'AuthBloc',
          'AddEmergencyContact',
          data: {'contact': contact.name},
        );

        await _authRepository.addEmergencyContact(contact);

        // Refresh user
        final user = await _authRepository.getCurrentUser();
        if (user != null) {
          if (user.hasRequiredInfo) {
            emit(AuthState.authenticated(user: user, isNewUser: false));
          } else {
            emit(AuthState.profileIncomplete(user: user));
          }
        }
      }
    } catch (e) {
      Logger.error('Error adding emergency contact', error: e);
      emit(
        AuthState.error(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onUpdateEmergencyContact(
    EmergencyContactEntity contact,
    Emitter<AuthState> emit,
  ) async {
    try {
      Logger.bloc(
        'AuthBloc',
        'UpdateEmergencyContact',
        data: {'contact': contact.name},
      );

      await _authRepository.updateEmergencyContact(contact);

      // Refresh user
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        if (user.hasRequiredInfo) {
          emit(AuthState.authenticated(user: user, isNewUser: false));
        } else {
          emit(AuthState.profileIncomplete(user: user));
        }
      }
    } catch (e) {
      Logger.error('Error updating emergency contact', error: e);
      emit(
        AuthState.error(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onRemoveEmergencyContact(
    String contactId,
    Emitter<AuthState> emit,
  ) async {
    try {
      Logger.bloc(
        'AuthBloc',
        'RemoveEmergencyContact',
        data: {'contactId': contactId},
      );

      await _authRepository.removeEmergencyContact(contactId);

      // Refresh user
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        if (user.hasRequiredInfo) {
          emit(AuthState.authenticated(user: user, isNewUser: false));
        } else {
          emit(AuthState.profileIncomplete(user: user));
        }
      }
    } catch (e) {
      Logger.error('Error removing emergency contact', error: e);
      emit(
        AuthState.error(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onCompleteProfileSetup(Emitter<AuthState> emit) async {
    try {
      final user = state.maybeWhen(
        profileIncomplete: (user) => user,
        orElse: () => null,
      );

      if (user != null) {
        // Validate profile completion
        if (user.name.isEmpty) {
          emit(const AuthState.error(message: 'Please enter your name'));
          return;
        }

        // Emergency contacts are now optional

        Logger.bloc('AuthBloc', 'CompleteProfileSetup');

        // Mark profile as complete
        final updatedUser = UserEntity(
          id: user.id,
          phoneNumber: user.phoneNumber,
          name: user.name,
          email: user.email,
          profileImageUrl: user.profileImageUrl,
          dateOfBirth: user.dateOfBirth,
          bloodGroup: user.bloodGroup,
          address: user.address,
          emergencyContacts: user.emergencyContacts,
          isProfileComplete: true,
          isVerified: user.isVerified,
          createdAt: user.createdAt,
          lastLoginAt: DateTime.now(),
          settings: user.settings,
        );

        final savedUser = await _authRepository.updateProfile(updatedUser);

        emit(AuthState.authenticated(user: savedUser, isNewUser: false));
      }
    } catch (e) {
      Logger.error('Error completing profile setup', error: e);
      emit(
        AuthState.error(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> _onLogout(Emitter<AuthState> emit) async {
    try {
      Logger.bloc('AuthBloc', 'Logout');

      emit(const AuthState.loading());

      await _authRepository.logout();

      emit(const AuthState.unauthenticated());
    } catch (e) {
      Logger.error('Error during logout', error: e);
      // Even if logout fails, mark as unauthenticated
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onDeleteAccount(Emitter<AuthState> emit) async {
    try {
      Logger.bloc('AuthBloc', 'DeleteAccount');

      emit(const AuthState.loading());

      await _authRepository.deleteAccount();

      emit(const AuthState.unauthenticated());
    } catch (e) {
      Logger.error('Error deleting account', error: e);
      emit(
        AuthState.error(message: e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  void _startResendTimer(Emitter<AuthState> emit) {
    _resendTimer?.cancel();

    int countdown = 30;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown--;

      if (countdown <= 0) {
        timer.cancel();
      }

      state.maybeWhen(
        otpSent: (phoneNumber, _) {
          emit(
            AuthState.otpSent(
              phoneNumber: phoneNumber,
              resendCooldown: countdown,
            ),
          );
        },
        orElse: () {},
      );
    });
  }
}
