// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileEvent()';
}


}

/// @nodoc
class $ProfileEventCopyWith<$Res>  {
$ProfileEventCopyWith(ProfileEvent _, $Res Function(ProfileEvent) __);
}


/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadProfileEvent value)?  loadProfile,TResult Function( UpdateProfileEvent value)?  updateProfile,TResult Function( ResetStateEvent value)?  resetState,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that);case UpdateProfileEvent() when updateProfile != null:
return updateProfile(_that);case ResetStateEvent() when resetState != null:
return resetState(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadProfileEvent value)  loadProfile,required TResult Function( UpdateProfileEvent value)  updateProfile,required TResult Function( ResetStateEvent value)  resetState,}){
final _that = this;
switch (_that) {
case LoadProfileEvent():
return loadProfile(_that);case UpdateProfileEvent():
return updateProfile(_that);case ResetStateEvent():
return resetState(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadProfileEvent value)?  loadProfile,TResult? Function( UpdateProfileEvent value)?  updateProfile,TResult? Function( ResetStateEvent value)?  resetState,}){
final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that);case UpdateProfileEvent() when updateProfile != null:
return updateProfile(_that);case ResetStateEvent() when resetState != null:
return resetState(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String userId)?  loadProfile,TResult Function( String userId,  ProfileUpdateRequest request)?  updateProfile,TResult Function()?  resetState,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that.userId);case UpdateProfileEvent() when updateProfile != null:
return updateProfile(_that.userId,_that.request);case ResetStateEvent() when resetState != null:
return resetState();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String userId)  loadProfile,required TResult Function( String userId,  ProfileUpdateRequest request)  updateProfile,required TResult Function()  resetState,}) {final _that = this;
switch (_that) {
case LoadProfileEvent():
return loadProfile(_that.userId);case UpdateProfileEvent():
return updateProfile(_that.userId,_that.request);case ResetStateEvent():
return resetState();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String userId)?  loadProfile,TResult? Function( String userId,  ProfileUpdateRequest request)?  updateProfile,TResult? Function()?  resetState,}) {final _that = this;
switch (_that) {
case LoadProfileEvent() when loadProfile != null:
return loadProfile(_that.userId);case UpdateProfileEvent() when updateProfile != null:
return updateProfile(_that.userId,_that.request);case ResetStateEvent() when resetState != null:
return resetState();case _:
  return null;

}
}

}

/// @nodoc


class LoadProfileEvent implements ProfileEvent {
  const LoadProfileEvent(this.userId);
  

 final  String userId;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadProfileEventCopyWith<LoadProfileEvent> get copyWith => _$LoadProfileEventCopyWithImpl<LoadProfileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProfileEvent&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileEvent.loadProfile(userId: $userId)';
}


}

/// @nodoc
abstract mixin class $LoadProfileEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $LoadProfileEventCopyWith(LoadProfileEvent value, $Res Function(LoadProfileEvent) _then) = _$LoadProfileEventCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class _$LoadProfileEventCopyWithImpl<$Res>
    implements $LoadProfileEventCopyWith<$Res> {
  _$LoadProfileEventCopyWithImpl(this._self, this._then);

  final LoadProfileEvent _self;
  final $Res Function(LoadProfileEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(LoadProfileEvent(
null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateProfileEvent implements ProfileEvent {
  const UpdateProfileEvent({required this.userId, required this.request});
  

 final  String userId;
 final  ProfileUpdateRequest request;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileEventCopyWith<UpdateProfileEvent> get copyWith => _$UpdateProfileEventCopyWithImpl<UpdateProfileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfileEvent&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,userId,request);

@override
String toString() {
  return 'ProfileEvent.updateProfile(userId: $userId, request: $request)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileEventCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $UpdateProfileEventCopyWith(UpdateProfileEvent value, $Res Function(UpdateProfileEvent) _then) = _$UpdateProfileEventCopyWithImpl;
@useResult
$Res call({
 String userId, ProfileUpdateRequest request
});




}
/// @nodoc
class _$UpdateProfileEventCopyWithImpl<$Res>
    implements $UpdateProfileEventCopyWith<$Res> {
  _$UpdateProfileEventCopyWithImpl(this._self, this._then);

  final UpdateProfileEvent _self;
  final $Res Function(UpdateProfileEvent) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? request = null,}) {
  return _then(UpdateProfileEvent(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as ProfileUpdateRequest,
  ));
}


}

/// @nodoc


class ResetStateEvent implements ProfileEvent {
  const ResetStateEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetStateEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileEvent.resetState()';
}


}




// dart format on
