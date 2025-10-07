// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CheckAuthStatus value)?  checkAuthStatus,TResult Function( _SendOtp value)?  sendOtp,TResult Function( _ResendOtp value)?  resendOtp,TResult Function( _VerifyOtp value)?  verifyOtp,TResult Function( _UpdateProfile value)?  updateProfile,TResult Function( _CompleteProfileSetup value)?  completeProfileSetup,TResult Function( _Logout value)?  logout,TResult Function( _DeleteAccount value)?  deleteAccount,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case _SendOtp() when sendOtp != null:
return sendOtp(_that);case _ResendOtp() when resendOtp != null:
return resendOtp(_that);case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that);case _CompleteProfileSetup() when completeProfileSetup != null:
return completeProfileSetup(_that);case _Logout() when logout != null:
return logout(_that);case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CheckAuthStatus value)  checkAuthStatus,required TResult Function( _SendOtp value)  sendOtp,required TResult Function( _ResendOtp value)  resendOtp,required TResult Function( _VerifyOtp value)  verifyOtp,required TResult Function( _UpdateProfile value)  updateProfile,required TResult Function( _CompleteProfileSetup value)  completeProfileSetup,required TResult Function( _Logout value)  logout,required TResult Function( _DeleteAccount value)  deleteAccount,}){
final _that = this;
switch (_that) {
case _CheckAuthStatus():
return checkAuthStatus(_that);case _SendOtp():
return sendOtp(_that);case _ResendOtp():
return resendOtp(_that);case _VerifyOtp():
return verifyOtp(_that);case _UpdateProfile():
return updateProfile(_that);case _CompleteProfileSetup():
return completeProfileSetup(_that);case _Logout():
return logout(_that);case _DeleteAccount():
return deleteAccount(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CheckAuthStatus value)?  checkAuthStatus,TResult? Function( _SendOtp value)?  sendOtp,TResult? Function( _ResendOtp value)?  resendOtp,TResult? Function( _VerifyOtp value)?  verifyOtp,TResult? Function( _UpdateProfile value)?  updateProfile,TResult? Function( _CompleteProfileSetup value)?  completeProfileSetup,TResult? Function( _Logout value)?  logout,TResult? Function( _DeleteAccount value)?  deleteAccount,}){
final _that = this;
switch (_that) {
case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus(_that);case _SendOtp() when sendOtp != null:
return sendOtp(_that);case _ResendOtp() when resendOtp != null:
return resendOtp(_that);case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that);case _CompleteProfileSetup() when completeProfileSetup != null:
return completeProfileSetup(_that);case _Logout() when logout != null:
return logout(_that);case _DeleteAccount() when deleteAccount != null:
return deleteAccount(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checkAuthStatus,TResult Function( String phoneNumber)?  sendOtp,TResult Function()?  resendOtp,TResult Function( String phoneNumber,  String otp)?  verifyOtp,TResult Function( String name,  String? email,  String? address,  String? bloodGroup)?  updateProfile,TResult Function()?  completeProfileSetup,TResult Function()?  logout,TResult Function()?  deleteAccount,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case _SendOtp() when sendOtp != null:
return sendOtp(_that.phoneNumber);case _ResendOtp() when resendOtp != null:
return resendOtp();case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.phoneNumber,_that.otp);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that.name,_that.email,_that.address,_that.bloodGroup);case _CompleteProfileSetup() when completeProfileSetup != null:
return completeProfileSetup();case _Logout() when logout != null:
return logout();case _DeleteAccount() when deleteAccount != null:
return deleteAccount();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checkAuthStatus,required TResult Function( String phoneNumber)  sendOtp,required TResult Function()  resendOtp,required TResult Function( String phoneNumber,  String otp)  verifyOtp,required TResult Function( String name,  String? email,  String? address,  String? bloodGroup)  updateProfile,required TResult Function()  completeProfileSetup,required TResult Function()  logout,required TResult Function()  deleteAccount,}) {final _that = this;
switch (_that) {
case _CheckAuthStatus():
return checkAuthStatus();case _SendOtp():
return sendOtp(_that.phoneNumber);case _ResendOtp():
return resendOtp();case _VerifyOtp():
return verifyOtp(_that.phoneNumber,_that.otp);case _UpdateProfile():
return updateProfile(_that.name,_that.email,_that.address,_that.bloodGroup);case _CompleteProfileSetup():
return completeProfileSetup();case _Logout():
return logout();case _DeleteAccount():
return deleteAccount();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checkAuthStatus,TResult? Function( String phoneNumber)?  sendOtp,TResult? Function()?  resendOtp,TResult? Function( String phoneNumber,  String otp)?  verifyOtp,TResult? Function( String name,  String? email,  String? address,  String? bloodGroup)?  updateProfile,TResult? Function()?  completeProfileSetup,TResult? Function()?  logout,TResult? Function()?  deleteAccount,}) {final _that = this;
switch (_that) {
case _CheckAuthStatus() when checkAuthStatus != null:
return checkAuthStatus();case _SendOtp() when sendOtp != null:
return sendOtp(_that.phoneNumber);case _ResendOtp() when resendOtp != null:
return resendOtp();case _VerifyOtp() when verifyOtp != null:
return verifyOtp(_that.phoneNumber,_that.otp);case _UpdateProfile() when updateProfile != null:
return updateProfile(_that.name,_that.email,_that.address,_that.bloodGroup);case _CompleteProfileSetup() when completeProfileSetup != null:
return completeProfileSetup();case _Logout() when logout != null:
return logout();case _DeleteAccount() when deleteAccount != null:
return deleteAccount();case _:
  return null;

}
}

}

/// @nodoc


class _CheckAuthStatus implements AuthEvent {
  const _CheckAuthStatus();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckAuthStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.checkAuthStatus()';
}


}




/// @nodoc


class _SendOtp implements AuthEvent {
  const _SendOtp({required this.phoneNumber});
  

 final  String phoneNumber;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpCopyWith<_SendOtp> get copyWith => __$SendOtpCopyWithImpl<_SendOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtp&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber);

@override
String toString() {
  return 'AuthEvent.sendOtp(phoneNumber: $phoneNumber)';
}


}

/// @nodoc
abstract mixin class _$SendOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SendOtpCopyWith(_SendOtp value, $Res Function(_SendOtp) _then) = __$SendOtpCopyWithImpl;
@useResult
$Res call({
 String phoneNumber
});




}
/// @nodoc
class __$SendOtpCopyWithImpl<$Res>
    implements _$SendOtpCopyWith<$Res> {
  __$SendOtpCopyWithImpl(this._self, this._then);

  final _SendOtp _self;
  final $Res Function(_SendOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,}) {
  return _then(_SendOtp(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ResendOtp implements AuthEvent {
  const _ResendOtp();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResendOtp);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.resendOtp()';
}


}




/// @nodoc


class _VerifyOtp implements AuthEvent {
  const _VerifyOtp({required this.phoneNumber, required this.otp});
  

 final  String phoneNumber;
 final  String otp;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpCopyWith<_VerifyOtp> get copyWith => __$VerifyOtpCopyWithImpl<_VerifyOtp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtp&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otp, otp) || other.otp == otp));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,otp);

@override
String toString() {
  return 'AuthEvent.verifyOtp(phoneNumber: $phoneNumber, otp: $otp)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$VerifyOtpCopyWith(_VerifyOtp value, $Res Function(_VerifyOtp) _then) = __$VerifyOtpCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, String otp
});




}
/// @nodoc
class __$VerifyOtpCopyWithImpl<$Res>
    implements _$VerifyOtpCopyWith<$Res> {
  __$VerifyOtpCopyWithImpl(this._self, this._then);

  final _VerifyOtp _self;
  final $Res Function(_VerifyOtp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? otp = null,}) {
  return _then(_VerifyOtp(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateProfile implements AuthEvent {
  const _UpdateProfile({required this.name, this.email, this.address, this.bloodGroup});
  

 final  String name;
 final  String? email;
 final  String? address;
 final  String? bloodGroup;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProfileCopyWith<_UpdateProfile> get copyWith => __$UpdateProfileCopyWithImpl<_UpdateProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,address,bloodGroup);

@override
String toString() {
  return 'AuthEvent.updateProfile(name: $name, email: $email, address: $address, bloodGroup: $bloodGroup)';
}


}

/// @nodoc
abstract mixin class _$UpdateProfileCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$UpdateProfileCopyWith(_UpdateProfile value, $Res Function(_UpdateProfile) _then) = __$UpdateProfileCopyWithImpl;
@useResult
$Res call({
 String name, String? email, String? address, String? bloodGroup
});




}
/// @nodoc
class __$UpdateProfileCopyWithImpl<$Res>
    implements _$UpdateProfileCopyWith<$Res> {
  __$UpdateProfileCopyWithImpl(this._self, this._then);

  final _UpdateProfile _self;
  final $Res Function(_UpdateProfile) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = freezed,Object? address = freezed,Object? bloodGroup = freezed,}) {
  return _then(_UpdateProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,bloodGroup: freezed == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _CompleteProfileSetup implements AuthEvent {
  const _CompleteProfileSetup();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteProfileSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.completeProfileSetup()';
}


}




/// @nodoc


class _Logout implements AuthEvent {
  const _Logout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Logout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logout()';
}


}




/// @nodoc


class _DeleteAccount implements AuthEvent {
  const _DeleteAccount();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteAccount);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.deleteAccount()';
}


}




// dart format on
