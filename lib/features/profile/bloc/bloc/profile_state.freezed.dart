// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState()';
}


}

/// @nodoc
class $ProfileStateCopyWith<$Res>  {
$ProfileStateCopyWith(ProfileState _, $Res Function(ProfileState) __);
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProfileInitialState value)?  initial,TResult Function( ProfileLoadingState value)?  loading,TResult Function( ProfileLoadedState value)?  loaded,TResult Function( ProfileUpdatedState value)?  updated,TResult Function( ProfileErrorState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProfileInitialState() when initial != null:
return initial(_that);case ProfileLoadingState() when loading != null:
return loading(_that);case ProfileLoadedState() when loaded != null:
return loaded(_that);case ProfileUpdatedState() when updated != null:
return updated(_that);case ProfileErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProfileInitialState value)  initial,required TResult Function( ProfileLoadingState value)  loading,required TResult Function( ProfileLoadedState value)  loaded,required TResult Function( ProfileUpdatedState value)  updated,required TResult Function( ProfileErrorState value)  error,}){
final _that = this;
switch (_that) {
case ProfileInitialState():
return initial(_that);case ProfileLoadingState():
return loading(_that);case ProfileLoadedState():
return loaded(_that);case ProfileUpdatedState():
return updated(_that);case ProfileErrorState():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProfileInitialState value)?  initial,TResult? Function( ProfileLoadingState value)?  loading,TResult? Function( ProfileLoadedState value)?  loaded,TResult? Function( ProfileUpdatedState value)?  updated,TResult? Function( ProfileErrorState value)?  error,}){
final _that = this;
switch (_that) {
case ProfileInitialState() when initial != null:
return initial(_that);case ProfileLoadingState() when loading != null:
return loading(_that);case ProfileLoadedState() when loaded != null:
return loaded(_that);case ProfileUpdatedState() when updated != null:
return updated(_that);case ProfileErrorState() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( UserEntity user)?  loaded,TResult Function( UserEntity user,  String message)?  updated,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProfileInitialState() when initial != null:
return initial();case ProfileLoadingState() when loading != null:
return loading();case ProfileLoadedState() when loaded != null:
return loaded(_that.user);case ProfileUpdatedState() when updated != null:
return updated(_that.user,_that.message);case ProfileErrorState() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( UserEntity user)  loaded,required TResult Function( UserEntity user,  String message)  updated,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ProfileInitialState():
return initial();case ProfileLoadingState():
return loading();case ProfileLoadedState():
return loaded(_that.user);case ProfileUpdatedState():
return updated(_that.user,_that.message);case ProfileErrorState():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( UserEntity user)?  loaded,TResult? Function( UserEntity user,  String message)?  updated,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ProfileInitialState() when initial != null:
return initial();case ProfileLoadingState() when loading != null:
return loading();case ProfileLoadedState() when loaded != null:
return loaded(_that.user);case ProfileUpdatedState() when updated != null:
return updated(_that.user,_that.message);case ProfileErrorState() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ProfileInitialState implements ProfileState {
  const ProfileInitialState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileInitialState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.initial()';
}


}




/// @nodoc


class ProfileLoadingState implements ProfileState {
  const ProfileLoadingState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLoadingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.loading()';
}


}




/// @nodoc


class ProfileLoadedState implements ProfileState {
  const ProfileLoadedState(this.user);
  

 final  UserEntity user;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileLoadedStateCopyWith<ProfileLoadedState> get copyWith => _$ProfileLoadedStateCopyWithImpl<ProfileLoadedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileLoadedState&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'ProfileState.loaded(user: $user)';
}


}

/// @nodoc
abstract mixin class $ProfileLoadedStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileLoadedStateCopyWith(ProfileLoadedState value, $Res Function(ProfileLoadedState) _then) = _$ProfileLoadedStateCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class _$ProfileLoadedStateCopyWithImpl<$Res>
    implements $ProfileLoadedStateCopyWith<$Res> {
  _$ProfileLoadedStateCopyWithImpl(this._self, this._then);

  final ProfileLoadedState _self;
  final $Res Function(ProfileLoadedState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(ProfileLoadedState(
null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class ProfileUpdatedState implements ProfileState {
  const ProfileUpdatedState({required this.user, required this.message});
  

 final  UserEntity user;
 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUpdatedStateCopyWith<ProfileUpdatedState> get copyWith => _$ProfileUpdatedStateCopyWithImpl<ProfileUpdatedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUpdatedState&&(identical(other.user, user) || other.user == user)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,user,message);

@override
String toString() {
  return 'ProfileState.updated(user: $user, message: $message)';
}


}

/// @nodoc
abstract mixin class $ProfileUpdatedStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileUpdatedStateCopyWith(ProfileUpdatedState value, $Res Function(ProfileUpdatedState) _then) = _$ProfileUpdatedStateCopyWithImpl;
@useResult
$Res call({
 UserEntity user, String message
});




}
/// @nodoc
class _$ProfileUpdatedStateCopyWithImpl<$Res>
    implements $ProfileUpdatedStateCopyWith<$Res> {
  _$ProfileUpdatedStateCopyWithImpl(this._self, this._then);

  final ProfileUpdatedState _self;
  final $Res Function(ProfileUpdatedState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? message = null,}) {
  return _then(ProfileUpdatedState(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProfileErrorState implements ProfileState {
  const ProfileErrorState(this.message);
  

 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileErrorStateCopyWith<ProfileErrorState> get copyWith => _$ProfileErrorStateCopyWithImpl<ProfileErrorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileErrorState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProfileState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProfileErrorStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileErrorStateCopyWith(ProfileErrorState value, $Res Function(ProfileErrorState) _then) = _$ProfileErrorStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProfileErrorStateCopyWithImpl<$Res>
    implements $ProfileErrorStateCopyWith<$Res> {
  _$ProfileErrorStateCopyWithImpl(this._self, this._then);

  final ProfileErrorState _self;
  final $Res Function(ProfileErrorState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProfileErrorState(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
