import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/profile_update_request.dart';

part 'profile_event.freezed.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile(String userId) = LoadProfileEvent;
  
  const factory ProfileEvent.updateProfile({
    required String userId,
    required ProfileUpdateRequest request,
  }) = UpdateProfileEvent;
  
  const factory ProfileEvent.resetState() = ResetStateEvent;
}