import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/user_entity.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitialState;
  
  const factory ProfileState.loading() = ProfileLoadingState;
  
  const factory ProfileState.loaded(UserEntity user) = ProfileLoadedState;
  
  const factory ProfileState.updated({
    required UserEntity user,
    required String message,
  }) = ProfileUpdatedState;
  
  const factory ProfileState.error(String message) = ProfileErrorState;
}
