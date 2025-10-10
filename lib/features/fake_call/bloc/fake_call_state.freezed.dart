// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fake_call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FakeCallState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FakeCallState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FakeCallState()';
}


}

/// @nodoc
class $FakeCallStateCopyWith<$Res>  {
$FakeCallStateCopyWith(FakeCallState _, $Res Function(FakeCallState) __);
}


/// Adds pattern-matching-related methods to [FakeCallState].
extension FakeCallStatePatterns on FakeCallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _SettingUp value)?  settingUp,TResult Function( _DetailsSaved value)?  detailsSaved,TResult Function( _Waiting value)?  waiting,TResult Function( _IncomingCall value)?  incomingCall,TResult Function( _InCall value)?  inCall,TResult Function( _CallEnded value)?  callEnded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _SettingUp() when settingUp != null:
return settingUp(_that);case _DetailsSaved() when detailsSaved != null:
return detailsSaved(_that);case _Waiting() when waiting != null:
return waiting(_that);case _IncomingCall() when incomingCall != null:
return incomingCall(_that);case _InCall() when inCall != null:
return inCall(_that);case _CallEnded() when callEnded != null:
return callEnded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _SettingUp value)  settingUp,required TResult Function( _DetailsSaved value)  detailsSaved,required TResult Function( _Waiting value)  waiting,required TResult Function( _IncomingCall value)  incomingCall,required TResult Function( _InCall value)  inCall,required TResult Function( _CallEnded value)  callEnded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _SettingUp():
return settingUp(_that);case _DetailsSaved():
return detailsSaved(_that);case _Waiting():
return waiting(_that);case _IncomingCall():
return incomingCall(_that);case _InCall():
return inCall(_that);case _CallEnded():
return callEnded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _SettingUp value)?  settingUp,TResult? Function( _DetailsSaved value)?  detailsSaved,TResult? Function( _Waiting value)?  waiting,TResult? Function( _IncomingCall value)?  incomingCall,TResult? Function( _InCall value)?  inCall,TResult? Function( _CallEnded value)?  callEnded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _SettingUp() when settingUp != null:
return settingUp(_that);case _DetailsSaved() when detailsSaved != null:
return detailsSaved(_that);case _Waiting() when waiting != null:
return waiting(_that);case _IncomingCall() when incomingCall != null:
return incomingCall(_that);case _InCall() when inCall != null:
return inCall(_that);case _CallEnded() when callEnded != null:
return callEnded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int timerSeconds)?  settingUp,TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int timerSeconds)?  detailsSaved,TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int remainingSeconds)?  waiting,TResult Function( String callerName,  String callerNumber,  String? callerImagePath)?  incomingCall,TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int callDurationSeconds)?  inCall,TResult Function()?  callEnded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _SettingUp() when settingUp != null:
return settingUp(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.timerSeconds);case _DetailsSaved() when detailsSaved != null:
return detailsSaved(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.timerSeconds);case _Waiting() when waiting != null:
return waiting(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.remainingSeconds);case _IncomingCall() when incomingCall != null:
return incomingCall(_that.callerName,_that.callerNumber,_that.callerImagePath);case _InCall() when inCall != null:
return inCall(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.callDurationSeconds);case _CallEnded() when callEnded != null:
return callEnded();case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int timerSeconds)  settingUp,required TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int timerSeconds)  detailsSaved,required TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int remainingSeconds)  waiting,required TResult Function( String callerName,  String callerNumber,  String? callerImagePath)  incomingCall,required TResult Function( String callerName,  String callerNumber,  String? callerImagePath,  int callDurationSeconds)  inCall,required TResult Function()  callEnded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _SettingUp():
return settingUp(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.timerSeconds);case _DetailsSaved():
return detailsSaved(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.timerSeconds);case _Waiting():
return waiting(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.remainingSeconds);case _IncomingCall():
return incomingCall(_that.callerName,_that.callerNumber,_that.callerImagePath);case _InCall():
return inCall(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.callDurationSeconds);case _CallEnded():
return callEnded();case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String callerName,  String callerNumber,  String? callerImagePath,  int timerSeconds)?  settingUp,TResult? Function( String callerName,  String callerNumber,  String? callerImagePath,  int timerSeconds)?  detailsSaved,TResult? Function( String callerName,  String callerNumber,  String? callerImagePath,  int remainingSeconds)?  waiting,TResult? Function( String callerName,  String callerNumber,  String? callerImagePath)?  incomingCall,TResult? Function( String callerName,  String callerNumber,  String? callerImagePath,  int callDurationSeconds)?  inCall,TResult? Function()?  callEnded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _SettingUp() when settingUp != null:
return settingUp(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.timerSeconds);case _DetailsSaved() when detailsSaved != null:
return detailsSaved(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.timerSeconds);case _Waiting() when waiting != null:
return waiting(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.remainingSeconds);case _IncomingCall() when incomingCall != null:
return incomingCall(_that.callerName,_that.callerNumber,_that.callerImagePath);case _InCall() when inCall != null:
return inCall(_that.callerName,_that.callerNumber,_that.callerImagePath,_that.callDurationSeconds);case _CallEnded() when callEnded != null:
return callEnded();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements FakeCallState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FakeCallState.initial()';
}


}




/// @nodoc


class _SettingUp implements FakeCallState {
  const _SettingUp({required this.callerName, required this.callerNumber, this.callerImagePath, required this.timerSeconds});
  

 final  String callerName;
 final  String callerNumber;
 final  String? callerImagePath;
 final  int timerSeconds;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingUpCopyWith<_SettingUp> get copyWith => __$SettingUpCopyWithImpl<_SettingUp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingUp&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.callerImagePath, callerImagePath) || other.callerImagePath == callerImagePath)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,callerName,callerNumber,callerImagePath,timerSeconds);

@override
String toString() {
  return 'FakeCallState.settingUp(callerName: $callerName, callerNumber: $callerNumber, callerImagePath: $callerImagePath, timerSeconds: $timerSeconds)';
}


}

/// @nodoc
abstract mixin class _$SettingUpCopyWith<$Res> implements $FakeCallStateCopyWith<$Res> {
  factory _$SettingUpCopyWith(_SettingUp value, $Res Function(_SettingUp) _then) = __$SettingUpCopyWithImpl;
@useResult
$Res call({
 String callerName, String callerNumber, String? callerImagePath, int timerSeconds
});




}
/// @nodoc
class __$SettingUpCopyWithImpl<$Res>
    implements _$SettingUpCopyWith<$Res> {
  __$SettingUpCopyWithImpl(this._self, this._then);

  final _SettingUp _self;
  final $Res Function(_SettingUp) _then;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? callerName = null,Object? callerNumber = null,Object? callerImagePath = freezed,Object? timerSeconds = null,}) {
  return _then(_SettingUp(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,callerImagePath: freezed == callerImagePath ? _self.callerImagePath : callerImagePath // ignore: cast_nullable_to_non_nullable
as String?,timerSeconds: null == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _DetailsSaved implements FakeCallState {
  const _DetailsSaved({required this.callerName, required this.callerNumber, this.callerImagePath, required this.timerSeconds});
  

 final  String callerName;
 final  String callerNumber;
 final  String? callerImagePath;
 final  int timerSeconds;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailsSavedCopyWith<_DetailsSaved> get copyWith => __$DetailsSavedCopyWithImpl<_DetailsSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailsSaved&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.callerImagePath, callerImagePath) || other.callerImagePath == callerImagePath)&&(identical(other.timerSeconds, timerSeconds) || other.timerSeconds == timerSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,callerName,callerNumber,callerImagePath,timerSeconds);

@override
String toString() {
  return 'FakeCallState.detailsSaved(callerName: $callerName, callerNumber: $callerNumber, callerImagePath: $callerImagePath, timerSeconds: $timerSeconds)';
}


}

/// @nodoc
abstract mixin class _$DetailsSavedCopyWith<$Res> implements $FakeCallStateCopyWith<$Res> {
  factory _$DetailsSavedCopyWith(_DetailsSaved value, $Res Function(_DetailsSaved) _then) = __$DetailsSavedCopyWithImpl;
@useResult
$Res call({
 String callerName, String callerNumber, String? callerImagePath, int timerSeconds
});




}
/// @nodoc
class __$DetailsSavedCopyWithImpl<$Res>
    implements _$DetailsSavedCopyWith<$Res> {
  __$DetailsSavedCopyWithImpl(this._self, this._then);

  final _DetailsSaved _self;
  final $Res Function(_DetailsSaved) _then;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? callerName = null,Object? callerNumber = null,Object? callerImagePath = freezed,Object? timerSeconds = null,}) {
  return _then(_DetailsSaved(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,callerImagePath: freezed == callerImagePath ? _self.callerImagePath : callerImagePath // ignore: cast_nullable_to_non_nullable
as String?,timerSeconds: null == timerSeconds ? _self.timerSeconds : timerSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Waiting implements FakeCallState {
  const _Waiting({required this.callerName, required this.callerNumber, this.callerImagePath, required this.remainingSeconds});
  

 final  String callerName;
 final  String callerNumber;
 final  String? callerImagePath;
 final  int remainingSeconds;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaitingCopyWith<_Waiting> get copyWith => __$WaitingCopyWithImpl<_Waiting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Waiting&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.callerImagePath, callerImagePath) || other.callerImagePath == callerImagePath)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,callerName,callerNumber,callerImagePath,remainingSeconds);

@override
String toString() {
  return 'FakeCallState.waiting(callerName: $callerName, callerNumber: $callerNumber, callerImagePath: $callerImagePath, remainingSeconds: $remainingSeconds)';
}


}

/// @nodoc
abstract mixin class _$WaitingCopyWith<$Res> implements $FakeCallStateCopyWith<$Res> {
  factory _$WaitingCopyWith(_Waiting value, $Res Function(_Waiting) _then) = __$WaitingCopyWithImpl;
@useResult
$Res call({
 String callerName, String callerNumber, String? callerImagePath, int remainingSeconds
});




}
/// @nodoc
class __$WaitingCopyWithImpl<$Res>
    implements _$WaitingCopyWith<$Res> {
  __$WaitingCopyWithImpl(this._self, this._then);

  final _Waiting _self;
  final $Res Function(_Waiting) _then;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? callerName = null,Object? callerNumber = null,Object? callerImagePath = freezed,Object? remainingSeconds = null,}) {
  return _then(_Waiting(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,callerImagePath: freezed == callerImagePath ? _self.callerImagePath : callerImagePath // ignore: cast_nullable_to_non_nullable
as String?,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _IncomingCall implements FakeCallState {
  const _IncomingCall({required this.callerName, required this.callerNumber, this.callerImagePath});
  

 final  String callerName;
 final  String callerNumber;
 final  String? callerImagePath;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingCallCopyWith<_IncomingCall> get copyWith => __$IncomingCallCopyWithImpl<_IncomingCall>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingCall&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.callerImagePath, callerImagePath) || other.callerImagePath == callerImagePath));
}


@override
int get hashCode => Object.hash(runtimeType,callerName,callerNumber,callerImagePath);

@override
String toString() {
  return 'FakeCallState.incomingCall(callerName: $callerName, callerNumber: $callerNumber, callerImagePath: $callerImagePath)';
}


}

/// @nodoc
abstract mixin class _$IncomingCallCopyWith<$Res> implements $FakeCallStateCopyWith<$Res> {
  factory _$IncomingCallCopyWith(_IncomingCall value, $Res Function(_IncomingCall) _then) = __$IncomingCallCopyWithImpl;
@useResult
$Res call({
 String callerName, String callerNumber, String? callerImagePath
});




}
/// @nodoc
class __$IncomingCallCopyWithImpl<$Res>
    implements _$IncomingCallCopyWith<$Res> {
  __$IncomingCallCopyWithImpl(this._self, this._then);

  final _IncomingCall _self;
  final $Res Function(_IncomingCall) _then;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? callerName = null,Object? callerNumber = null,Object? callerImagePath = freezed,}) {
  return _then(_IncomingCall(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,callerImagePath: freezed == callerImagePath ? _self.callerImagePath : callerImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _InCall implements FakeCallState {
  const _InCall({required this.callerName, required this.callerNumber, this.callerImagePath, required this.callDurationSeconds});
  

 final  String callerName;
 final  String callerNumber;
 final  String? callerImagePath;
 final  int callDurationSeconds;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InCallCopyWith<_InCall> get copyWith => __$InCallCopyWithImpl<_InCall>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InCall&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.callerImagePath, callerImagePath) || other.callerImagePath == callerImagePath)&&(identical(other.callDurationSeconds, callDurationSeconds) || other.callDurationSeconds == callDurationSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,callerName,callerNumber,callerImagePath,callDurationSeconds);

@override
String toString() {
  return 'FakeCallState.inCall(callerName: $callerName, callerNumber: $callerNumber, callerImagePath: $callerImagePath, callDurationSeconds: $callDurationSeconds)';
}


}

/// @nodoc
abstract mixin class _$InCallCopyWith<$Res> implements $FakeCallStateCopyWith<$Res> {
  factory _$InCallCopyWith(_InCall value, $Res Function(_InCall) _then) = __$InCallCopyWithImpl;
@useResult
$Res call({
 String callerName, String callerNumber, String? callerImagePath, int callDurationSeconds
});




}
/// @nodoc
class __$InCallCopyWithImpl<$Res>
    implements _$InCallCopyWith<$Res> {
  __$InCallCopyWithImpl(this._self, this._then);

  final _InCall _self;
  final $Res Function(_InCall) _then;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? callerName = null,Object? callerNumber = null,Object? callerImagePath = freezed,Object? callDurationSeconds = null,}) {
  return _then(_InCall(
callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,callerImagePath: freezed == callerImagePath ? _self.callerImagePath : callerImagePath // ignore: cast_nullable_to_non_nullable
as String?,callDurationSeconds: null == callDurationSeconds ? _self.callDurationSeconds : callDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _CallEnded implements FakeCallState {
  const _CallEnded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallEnded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FakeCallState.callEnded()';
}


}




/// @nodoc


class _Error implements FakeCallState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FakeCallState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $FakeCallStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of FakeCallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
