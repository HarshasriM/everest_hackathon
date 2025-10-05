// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AuthInitial value)?  initial,TResult Function( _AuthUnauthenticated value)?  unauthenticated,TResult Function( _AuthOtpSending value)?  otpSending,TResult Function( _AuthOtpSent value)?  otpSent,TResult Function( _AuthVerifyingOtp value)?  verifyingOtp,TResult Function( _AuthAuthenticated value)?  authenticated,TResult Function( _AuthProfileIncomplete value)?  profileIncomplete,TResult Function( _AuthError value)?  error,TResult Function( _AuthLoading value)?  loading,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial(_that);case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _AuthOtpSending() when otpSending != null:
return otpSending(_that);case _AuthOtpSent() when otpSent != null:
return otpSent(_that);case _AuthVerifyingOtp() when verifyingOtp != null:
return verifyingOtp(_that);case _AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _AuthProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that);case _AuthError() when error != null:
return error(_that);case _AuthLoading() when loading != null:
return loading(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AuthInitial value)  initial,required TResult Function( _AuthUnauthenticated value)  unauthenticated,required TResult Function( _AuthOtpSending value)  otpSending,required TResult Function( _AuthOtpSent value)  otpSent,required TResult Function( _AuthVerifyingOtp value)  verifyingOtp,required TResult Function( _AuthAuthenticated value)  authenticated,required TResult Function( _AuthProfileIncomplete value)  profileIncomplete,required TResult Function( _AuthError value)  error,required TResult Function( _AuthLoading value)  loading,}){
final _that = this;
switch (_that) {
case _AuthInitial():
return initial(_that);case _AuthUnauthenticated():
return unauthenticated(_that);case _AuthOtpSending():
return otpSending(_that);case _AuthOtpSent():
return otpSent(_that);case _AuthVerifyingOtp():
return verifyingOtp(_that);case _AuthAuthenticated():
return authenticated(_that);case _AuthProfileIncomplete():
return profileIncomplete(_that);case _AuthError():
return error(_that);case _AuthLoading():
return loading(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AuthInitial value)?  initial,TResult? Function( _AuthUnauthenticated value)?  unauthenticated,TResult? Function( _AuthOtpSending value)?  otpSending,TResult? Function( _AuthOtpSent value)?  otpSent,TResult? Function( _AuthVerifyingOtp value)?  verifyingOtp,TResult? Function( _AuthAuthenticated value)?  authenticated,TResult? Function( _AuthProfileIncomplete value)?  profileIncomplete,TResult? Function( _AuthError value)?  error,TResult? Function( _AuthLoading value)?  loading,}){
final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial(_that);case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _AuthOtpSending() when otpSending != null:
return otpSending(_that);case _AuthOtpSent() when otpSent != null:
return otpSent(_that);case _AuthVerifyingOtp() when verifyingOtp != null:
return verifyingOtp(_that);case _AuthAuthenticated() when authenticated != null:
return authenticated(_that);case _AuthProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that);case _AuthError() when error != null:
return error(_that);case _AuthLoading() when loading != null:
return loading(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  unauthenticated,TResult Function()?  otpSending,TResult Function( String phoneNumber,  int resendCooldown)?  otpSent,TResult Function()?  verifyingOtp,TResult Function( UserEntity user,  bool isNewUser)?  authenticated,TResult Function( UserEntity user)?  profileIncomplete,TResult Function( String message,  String? phoneNumber)?  error,TResult Function()?  loading,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial();case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case _AuthOtpSending() when otpSending != null:
return otpSending();case _AuthOtpSent() when otpSent != null:
return otpSent(_that.phoneNumber,_that.resendCooldown);case _AuthVerifyingOtp() when verifyingOtp != null:
return verifyingOtp();case _AuthAuthenticated() when authenticated != null:
return authenticated(_that.user,_that.isNewUser);case _AuthProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that.user);case _AuthError() when error != null:
return error(_that.message,_that.phoneNumber);case _AuthLoading() when loading != null:
return loading();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  unauthenticated,required TResult Function()  otpSending,required TResult Function( String phoneNumber,  int resendCooldown)  otpSent,required TResult Function()  verifyingOtp,required TResult Function( UserEntity user,  bool isNewUser)  authenticated,required TResult Function( UserEntity user)  profileIncomplete,required TResult Function( String message,  String? phoneNumber)  error,required TResult Function()  loading,}) {final _that = this;
switch (_that) {
case _AuthInitial():
return initial();case _AuthUnauthenticated():
return unauthenticated();case _AuthOtpSending():
return otpSending();case _AuthOtpSent():
return otpSent(_that.phoneNumber,_that.resendCooldown);case _AuthVerifyingOtp():
return verifyingOtp();case _AuthAuthenticated():
return authenticated(_that.user,_that.isNewUser);case _AuthProfileIncomplete():
return profileIncomplete(_that.user);case _AuthError():
return error(_that.message,_that.phoneNumber);case _AuthLoading():
return loading();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  unauthenticated,TResult? Function()?  otpSending,TResult? Function( String phoneNumber,  int resendCooldown)?  otpSent,TResult? Function()?  verifyingOtp,TResult? Function( UserEntity user,  bool isNewUser)?  authenticated,TResult? Function( UserEntity user)?  profileIncomplete,TResult? Function( String message,  String? phoneNumber)?  error,TResult? Function()?  loading,}) {final _that = this;
switch (_that) {
case _AuthInitial() when initial != null:
return initial();case _AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case _AuthOtpSending() when otpSending != null:
return otpSending();case _AuthOtpSent() when otpSent != null:
return otpSent(_that.phoneNumber,_that.resendCooldown);case _AuthVerifyingOtp() when verifyingOtp != null:
return verifyingOtp();case _AuthAuthenticated() when authenticated != null:
return authenticated(_that.user,_that.isNewUser);case _AuthProfileIncomplete() when profileIncomplete != null:
return profileIncomplete(_that.user);case _AuthError() when error != null:
return error(_that.message,_that.phoneNumber);case _AuthLoading() when loading != null:
return loading();case _:
  return null;

}
}

}

/// @nodoc


class _AuthInitial implements AuthState {
  const _AuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _AuthUnauthenticated implements AuthState {
  const _AuthUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class _AuthOtpSending implements AuthState {
  const _AuthOtpSending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthOtpSending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.otpSending()';
}


}




/// @nodoc


class _AuthOtpSent implements AuthState {
  const _AuthOtpSent({required this.phoneNumber, this.resendCooldown = 30});
  

 final  String phoneNumber;
@JsonKey() final  int resendCooldown;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthOtpSentCopyWith<_AuthOtpSent> get copyWith => __$AuthOtpSentCopyWithImpl<_AuthOtpSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthOtpSent&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.resendCooldown, resendCooldown) || other.resendCooldown == resendCooldown));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,resendCooldown);

@override
String toString() {
  return 'AuthState.otpSent(phoneNumber: $phoneNumber, resendCooldown: $resendCooldown)';
}


}

/// @nodoc
abstract mixin class _$AuthOtpSentCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthOtpSentCopyWith(_AuthOtpSent value, $Res Function(_AuthOtpSent) _then) = __$AuthOtpSentCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, int resendCooldown
});




}
/// @nodoc
class __$AuthOtpSentCopyWithImpl<$Res>
    implements _$AuthOtpSentCopyWith<$Res> {
  __$AuthOtpSentCopyWithImpl(this._self, this._then);

  final _AuthOtpSent _self;
  final $Res Function(_AuthOtpSent) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? resendCooldown = null,}) {
  return _then(_AuthOtpSent(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,resendCooldown: null == resendCooldown ? _self.resendCooldown : resendCooldown // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _AuthVerifyingOtp implements AuthState {
  const _AuthVerifyingOtp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthVerifyingOtp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.verifyingOtp()';
}


}




/// @nodoc


class _AuthAuthenticated implements AuthState {
  const _AuthAuthenticated({required this.user, required this.isNewUser});
  

 final  UserEntity user;
 final  bool isNewUser;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthAuthenticatedCopyWith<_AuthAuthenticated> get copyWith => __$AuthAuthenticatedCopyWithImpl<_AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthAuthenticated&&(identical(other.user, user) || other.user == user)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser));
}


@override
int get hashCode => Object.hash(runtimeType,user,isNewUser);

@override
String toString() {
  return 'AuthState.authenticated(user: $user, isNewUser: $isNewUser)';
}


}

/// @nodoc
abstract mixin class _$AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthAuthenticatedCopyWith(_AuthAuthenticated value, $Res Function(_AuthAuthenticated) _then) = __$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserEntity user, bool isNewUser
});




}
/// @nodoc
class __$AuthAuthenticatedCopyWithImpl<$Res>
    implements _$AuthAuthenticatedCopyWith<$Res> {
  __$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final _AuthAuthenticated _self;
  final $Res Function(_AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? isNewUser = null,}) {
  return _then(_AuthAuthenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AuthProfileIncomplete implements AuthState {
  const _AuthProfileIncomplete({required this.user});
  

 final  UserEntity user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthProfileIncompleteCopyWith<_AuthProfileIncomplete> get copyWith => __$AuthProfileIncompleteCopyWithImpl<_AuthProfileIncomplete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthProfileIncomplete&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.profileIncomplete(user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthProfileIncompleteCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthProfileIncompleteCopyWith(_AuthProfileIncomplete value, $Res Function(_AuthProfileIncomplete) _then) = __$AuthProfileIncompleteCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class __$AuthProfileIncompleteCopyWithImpl<$Res>
    implements _$AuthProfileIncompleteCopyWith<$Res> {
  __$AuthProfileIncompleteCopyWithImpl(this._self, this._then);

  final _AuthProfileIncomplete _self;
  final $Res Function(_AuthProfileIncomplete) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_AuthProfileIncomplete(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class _AuthError implements AuthState {
  const _AuthError({required this.message, this.phoneNumber});
  

 final  String message;
 final  String? phoneNumber;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthErrorCopyWith<_AuthError> get copyWith => __$AuthErrorCopyWithImpl<_AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthError&&(identical(other.message, message) || other.message == message)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}


@override
int get hashCode => Object.hash(runtimeType,message,phoneNumber);

@override
String toString() {
  return 'AuthState.error(message: $message, phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class _$AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthErrorCopyWith(_AuthError value, $Res Function(_AuthError) _then) = __$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? phoneNumber
});




}
/// @nodoc
class __$AuthErrorCopyWithImpl<$Res>
    implements _$AuthErrorCopyWith<$Res> {
  __$AuthErrorCopyWithImpl(this._self, this._then);

  final _AuthError _self;
  final $Res Function(_AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? phoneNumber = freezed,}) {
  return _then(_AuthError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _AuthLoading implements AuthState {
  const _AuthLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




// dart format on
