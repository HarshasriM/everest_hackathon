import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/auth_remote_source.dart';
import '../models/profile_update_request.dart';

/// Implementation of profile repository
class ProfileRepositoryImpl implements ProfileRepository {
  final AuthRemoteSource _authRemoteSource;

  ProfileRepositoryImpl(this._authRemoteSource);

  @override
  Future<UserEntity> getUserProfile(String userId) async {
    try {
      final userModel = await _authRemoteSource.getUserProfile(userId);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserEntity> updateProfile(
    String userId,
    ProfileUpdateRequest request,
  ) async {
    try {
      final updatedUserModel = await _authRemoteSource.updateProfileWithRequest(
        userId,
        request,
      );
      return updatedUserModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
