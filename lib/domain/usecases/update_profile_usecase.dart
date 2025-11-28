import '../entities/user_entity.dart';
import '../repositories/profile_repository.dart';
import '../../data/models/profile_update_request.dart';

/// Use case for updating user profile
class UpdateProfileUseCase {
  final ProfileRepository _profileRepository;

  UpdateProfileUseCase(this._profileRepository);

  /// Execute the update profile use case
  Future<UserEntity> call(String userId, ProfileUpdateRequest request) async {
    // Validate input
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    if (!request.isValid) {
      throw Exception('Profile data is invalid: ${request.nameError}');
    }

    if (request.emailError != null) {
      throw Exception('Email is invalid: ${request.emailError}');
    }

    try {
      return await _profileRepository.updateProfile(userId, request);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
