import 'package:bloc/bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../../domain/usecases/update_profile_usecase.dart';
import '../../../../domain/repositories/profile_repository.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final ProfileRepository _profileRepository;

  ProfileBloc({
    required UpdateProfileUseCase updateProfileUseCase,
    required ProfileRepository profileRepository,
  })  : _updateProfileUseCase = updateProfileUseCase,
        _profileRepository = profileRepository,
        super(const ProfileState.initial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ResetStateEvent>(_onResetState);
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      Logger.info('Loading profile for user: ${event.userId}');
      emit(const ProfileState.loading());

      final user = await _profileRepository.getUserProfile(event.userId);
      
      Logger.info('Profile loaded successfully for user: ${event.userId}');
      emit(ProfileState.loaded(user));
    } catch (e) {
      Logger.error('Failed to load profile', error: e);
      emit(ProfileState.error('Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      Logger.info('Updating profile for user: ${event.userId}');
      emit(const ProfileState.loading());

      final updatedUser = await _updateProfileUseCase(event.userId, event.request);
      
      Logger.info('Profile updated successfully for user: ${event.userId}');
      emit(ProfileState.updated(user: updatedUser, message: 'Profile updated successfully'));
    } catch (e) {
      Logger.error('Failed to update profile', error: e);
      emit(ProfileState.error('Failed to update profile: ${e.toString()}'));
    }
  }

  Future<void> _onResetState(ResetStateEvent event, Emitter<ProfileState> emit) async {
    Logger.info('Resetting profile state');
    emit(const ProfileState.initial());
  }
}
