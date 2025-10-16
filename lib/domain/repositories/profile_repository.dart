import '../entities/user_entity.dart';
import '../../data/models/profile_update_request.dart';

/// Repository interface for profile operations
abstract class ProfileRepository {
  /// Get user profile by user ID
  Future<UserEntity> getUserProfile(String userId);
  
  /// Update user profile with ProfileUpdateRequest
  Future<UserEntity> updateProfile(String userId, ProfileUpdateRequest request);
}
