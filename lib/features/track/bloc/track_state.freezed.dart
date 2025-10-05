// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackState()';
}


}

/// @nodoc
class $TrackStateCopyWith<$Res>  {
$TrackStateCopyWith(TrackState _, $Res Function(TrackState) __);
}


/// Adds pattern-matching-related methods to [TrackState].
extension TrackStatePatterns on TrackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _CheckingPermission value)?  checkingPermission,TResult Function( _PermissionDenied value)?  permissionDenied,TResult Function( _LocationServiceDisabled value)?  locationServiceDisabled,TResult Function( _LocationLoaded value)?  locationLoaded,TResult Function( _LocationUpdating value)?  locationUpdating,TResult Function( _AddressLoading value)?  addressLoading,TResult Function( _Error value)?  error,TResult Function( _NoLocation value)?  noLocation,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _CheckingPermission() when checkingPermission != null:
return checkingPermission(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _LocationServiceDisabled() when locationServiceDisabled != null:
return locationServiceDisabled(_that);case _LocationLoaded() when locationLoaded != null:
return locationLoaded(_that);case _LocationUpdating() when locationUpdating != null:
return locationUpdating(_that);case _AddressLoading() when addressLoading != null:
return addressLoading(_that);case _Error() when error != null:
return error(_that);case _NoLocation() when noLocation != null:
return noLocation(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _CheckingPermission value)  checkingPermission,required TResult Function( _PermissionDenied value)  permissionDenied,required TResult Function( _LocationServiceDisabled value)  locationServiceDisabled,required TResult Function( _LocationLoaded value)  locationLoaded,required TResult Function( _LocationUpdating value)  locationUpdating,required TResult Function( _AddressLoading value)  addressLoading,required TResult Function( _Error value)  error,required TResult Function( _NoLocation value)  noLocation,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _CheckingPermission():
return checkingPermission(_that);case _PermissionDenied():
return permissionDenied(_that);case _LocationServiceDisabled():
return locationServiceDisabled(_that);case _LocationLoaded():
return locationLoaded(_that);case _LocationUpdating():
return locationUpdating(_that);case _AddressLoading():
return addressLoading(_that);case _Error():
return error(_that);case _NoLocation():
return noLocation(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _CheckingPermission value)?  checkingPermission,TResult? Function( _PermissionDenied value)?  permissionDenied,TResult? Function( _LocationServiceDisabled value)?  locationServiceDisabled,TResult? Function( _LocationLoaded value)?  locationLoaded,TResult? Function( _LocationUpdating value)?  locationUpdating,TResult? Function( _AddressLoading value)?  addressLoading,TResult? Function( _Error value)?  error,TResult? Function( _NoLocation value)?  noLocation,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _CheckingPermission() when checkingPermission != null:
return checkingPermission(_that);case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case _LocationServiceDisabled() when locationServiceDisabled != null:
return locationServiceDisabled(_that);case _LocationLoaded() when locationLoaded != null:
return locationLoaded(_that);case _LocationUpdating() when locationUpdating != null:
return locationUpdating(_that);case _AddressLoading() when addressLoading != null:
return addressLoading(_that);case _Error() when error != null:
return error(_that);case _NoLocation() when noLocation != null:
return noLocation(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String message)?  loading,TResult Function()?  checkingPermission,TResult Function( LocationPermissionStatus permissionStatus,  String message)?  permissionDenied,TResult Function( String message)?  locationServiceDisabled,TResult Function( double latitude,  double longitude,  double accuracy,  String address,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates)?  locationLoaded,TResult Function( double latitude,  double longitude,  double accuracy,  String address,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates,  String updateMessage)?  locationUpdating,TResult Function( double latitude,  double longitude,  double accuracy,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates,  String message)?  addressLoading,TResult Function( String message,  String? details,  bool canRetry)?  error,TResult Function( String message)?  noLocation,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.message);case _CheckingPermission() when checkingPermission != null:
return checkingPermission();case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.permissionStatus,_that.message);case _LocationServiceDisabled() when locationServiceDisabled != null:
return locationServiceDisabled(_that.message);case _LocationLoaded() when locationLoaded != null:
return locationLoaded(_that.latitude,_that.longitude,_that.accuracy,_that.address,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates);case _LocationUpdating() when locationUpdating != null:
return locationUpdating(_that.latitude,_that.longitude,_that.accuracy,_that.address,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates,_that.updateMessage);case _AddressLoading() when addressLoading != null:
return addressLoading(_that.latitude,_that.longitude,_that.accuracy,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates,_that.message);case _Error() when error != null:
return error(_that.message,_that.details,_that.canRetry);case _NoLocation() when noLocation != null:
return noLocation(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String message)  loading,required TResult Function()  checkingPermission,required TResult Function( LocationPermissionStatus permissionStatus,  String message)  permissionDenied,required TResult Function( String message)  locationServiceDisabled,required TResult Function( double latitude,  double longitude,  double accuracy,  String address,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates)  locationLoaded,required TResult Function( double latitude,  double longitude,  double accuracy,  String address,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates,  String updateMessage)  locationUpdating,required TResult Function( double latitude,  double longitude,  double accuracy,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates,  String message)  addressLoading,required TResult Function( String message,  String? details,  bool canRetry)  error,required TResult Function( String message)  noLocation,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading(_that.message);case _CheckingPermission():
return checkingPermission();case _PermissionDenied():
return permissionDenied(_that.permissionStatus,_that.message);case _LocationServiceDisabled():
return locationServiceDisabled(_that.message);case _LocationLoaded():
return locationLoaded(_that.latitude,_that.longitude,_that.accuracy,_that.address,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates);case _LocationUpdating():
return locationUpdating(_that.latitude,_that.longitude,_that.accuracy,_that.address,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates,_that.updateMessage);case _AddressLoading():
return addressLoading(_that.latitude,_that.longitude,_that.accuracy,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates,_that.message);case _Error():
return error(_that.message,_that.details,_that.canRetry);case _NoLocation():
return noLocation(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String message)?  loading,TResult? Function()?  checkingPermission,TResult? Function( LocationPermissionStatus permissionStatus,  String message)?  permissionDenied,TResult? Function( String message)?  locationServiceDisabled,TResult? Function( double latitude,  double longitude,  double accuracy,  String address,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates)?  locationLoaded,TResult? Function( double latitude,  double longitude,  double accuracy,  String address,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates,  String updateMessage)?  locationUpdating,TResult? Function( double latitude,  double longitude,  double accuracy,  DateTime timestamp,  bool isLocationEnabled,  bool isListeningToUpdates,  String message)?  addressLoading,TResult? Function( String message,  String? details,  bool canRetry)?  error,TResult? Function( String message)?  noLocation,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading(_that.message);case _CheckingPermission() when checkingPermission != null:
return checkingPermission();case _PermissionDenied() when permissionDenied != null:
return permissionDenied(_that.permissionStatus,_that.message);case _LocationServiceDisabled() when locationServiceDisabled != null:
return locationServiceDisabled(_that.message);case _LocationLoaded() when locationLoaded != null:
return locationLoaded(_that.latitude,_that.longitude,_that.accuracy,_that.address,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates);case _LocationUpdating() when locationUpdating != null:
return locationUpdating(_that.latitude,_that.longitude,_that.accuracy,_that.address,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates,_that.updateMessage);case _AddressLoading() when addressLoading != null:
return addressLoading(_that.latitude,_that.longitude,_that.accuracy,_that.timestamp,_that.isLocationEnabled,_that.isListeningToUpdates,_that.message);case _Error() when error != null:
return error(_that.message,_that.details,_that.canRetry);case _NoLocation() when noLocation != null:
return noLocation(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TrackState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackState.initial()';
}


}




/// @nodoc


class _Loading implements TrackState {
  const _Loading({this.message = 'Initializing...'});
  

@JsonKey() final  String message;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TrackState.loading(message: $message)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Loading(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _CheckingPermission implements TrackState {
  const _CheckingPermission();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckingPermission);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackState.checkingPermission()';
}


}




/// @nodoc


class _PermissionDenied implements TrackState {
  const _PermissionDenied({required this.permissionStatus, this.message = 'Location permission is required'});
  

 final  LocationPermissionStatus permissionStatus;
@JsonKey() final  String message;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionDeniedCopyWith<_PermissionDenied> get copyWith => __$PermissionDeniedCopyWithImpl<_PermissionDenied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermissionDenied&&(identical(other.permissionStatus, permissionStatus) || other.permissionStatus == permissionStatus)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,permissionStatus,message);

@override
String toString() {
  return 'TrackState.permissionDenied(permissionStatus: $permissionStatus, message: $message)';
}


}

/// @nodoc
abstract mixin class _$PermissionDeniedCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$PermissionDeniedCopyWith(_PermissionDenied value, $Res Function(_PermissionDenied) _then) = __$PermissionDeniedCopyWithImpl;
@useResult
$Res call({
 LocationPermissionStatus permissionStatus, String message
});




}
/// @nodoc
class __$PermissionDeniedCopyWithImpl<$Res>
    implements _$PermissionDeniedCopyWith<$Res> {
  __$PermissionDeniedCopyWithImpl(this._self, this._then);

  final _PermissionDenied _self;
  final $Res Function(_PermissionDenied) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? permissionStatus = null,Object? message = null,}) {
  return _then(_PermissionDenied(
permissionStatus: null == permissionStatus ? _self.permissionStatus : permissionStatus // ignore: cast_nullable_to_non_nullable
as LocationPermissionStatus,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LocationServiceDisabled implements TrackState {
  const _LocationServiceDisabled({this.message = 'Location services are disabled'});
  

@JsonKey() final  String message;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationServiceDisabledCopyWith<_LocationServiceDisabled> get copyWith => __$LocationServiceDisabledCopyWithImpl<_LocationServiceDisabled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationServiceDisabled&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TrackState.locationServiceDisabled(message: $message)';
}


}

/// @nodoc
abstract mixin class _$LocationServiceDisabledCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$LocationServiceDisabledCopyWith(_LocationServiceDisabled value, $Res Function(_LocationServiceDisabled) _then) = __$LocationServiceDisabledCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$LocationServiceDisabledCopyWithImpl<$Res>
    implements _$LocationServiceDisabledCopyWith<$Res> {
  __$LocationServiceDisabledCopyWithImpl(this._self, this._then);

  final _LocationServiceDisabled _self;
  final $Res Function(_LocationServiceDisabled) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_LocationServiceDisabled(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _LocationLoaded implements TrackState {
  const _LocationLoaded({required this.latitude, required this.longitude, required this.accuracy, required this.address, required this.timestamp, this.isLocationEnabled = true, this.isListeningToUpdates = false});
  

 final  double latitude;
 final  double longitude;
 final  double accuracy;
 final  String address;
 final  DateTime timestamp;
@JsonKey() final  bool isLocationEnabled;
@JsonKey() final  bool isListeningToUpdates;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationLoadedCopyWith<_LocationLoaded> get copyWith => __$LocationLoadedCopyWithImpl<_LocationLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationLoaded&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.address, address) || other.address == address)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isLocationEnabled, isLocationEnabled) || other.isLocationEnabled == isLocationEnabled)&&(identical(other.isListeningToUpdates, isListeningToUpdates) || other.isListeningToUpdates == isListeningToUpdates));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,address,timestamp,isLocationEnabled,isListeningToUpdates);

@override
String toString() {
  return 'TrackState.locationLoaded(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, address: $address, timestamp: $timestamp, isLocationEnabled: $isLocationEnabled, isListeningToUpdates: $isListeningToUpdates)';
}


}

/// @nodoc
abstract mixin class _$LocationLoadedCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$LocationLoadedCopyWith(_LocationLoaded value, $Res Function(_LocationLoaded) _then) = __$LocationLoadedCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracy, String address, DateTime timestamp, bool isLocationEnabled, bool isListeningToUpdates
});




}
/// @nodoc
class __$LocationLoadedCopyWithImpl<$Res>
    implements _$LocationLoadedCopyWith<$Res> {
  __$LocationLoadedCopyWithImpl(this._self, this._then);

  final _LocationLoaded _self;
  final $Res Function(_LocationLoaded) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? address = null,Object? timestamp = null,Object? isLocationEnabled = null,Object? isListeningToUpdates = null,}) {
  return _then(_LocationLoaded(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isLocationEnabled: null == isLocationEnabled ? _self.isLocationEnabled : isLocationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isListeningToUpdates: null == isListeningToUpdates ? _self.isListeningToUpdates : isListeningToUpdates // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _LocationUpdating implements TrackState {
  const _LocationUpdating({required this.latitude, required this.longitude, required this.accuracy, required this.address, required this.timestamp, this.isLocationEnabled = true, this.isListeningToUpdates = true, this.updateMessage = 'Updating location...'});
  

 final  double latitude;
 final  double longitude;
 final  double accuracy;
 final  String address;
 final  DateTime timestamp;
@JsonKey() final  bool isLocationEnabled;
@JsonKey() final  bool isListeningToUpdates;
@JsonKey() final  String updateMessage;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationUpdatingCopyWith<_LocationUpdating> get copyWith => __$LocationUpdatingCopyWithImpl<_LocationUpdating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationUpdating&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.address, address) || other.address == address)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isLocationEnabled, isLocationEnabled) || other.isLocationEnabled == isLocationEnabled)&&(identical(other.isListeningToUpdates, isListeningToUpdates) || other.isListeningToUpdates == isListeningToUpdates)&&(identical(other.updateMessage, updateMessage) || other.updateMessage == updateMessage));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,address,timestamp,isLocationEnabled,isListeningToUpdates,updateMessage);

@override
String toString() {
  return 'TrackState.locationUpdating(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, address: $address, timestamp: $timestamp, isLocationEnabled: $isLocationEnabled, isListeningToUpdates: $isListeningToUpdates, updateMessage: $updateMessage)';
}


}

/// @nodoc
abstract mixin class _$LocationUpdatingCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$LocationUpdatingCopyWith(_LocationUpdating value, $Res Function(_LocationUpdating) _then) = __$LocationUpdatingCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracy, String address, DateTime timestamp, bool isLocationEnabled, bool isListeningToUpdates, String updateMessage
});




}
/// @nodoc
class __$LocationUpdatingCopyWithImpl<$Res>
    implements _$LocationUpdatingCopyWith<$Res> {
  __$LocationUpdatingCopyWithImpl(this._self, this._then);

  final _LocationUpdating _self;
  final $Res Function(_LocationUpdating) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? address = null,Object? timestamp = null,Object? isLocationEnabled = null,Object? isListeningToUpdates = null,Object? updateMessage = null,}) {
  return _then(_LocationUpdating(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isLocationEnabled: null == isLocationEnabled ? _self.isLocationEnabled : isLocationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isListeningToUpdates: null == isListeningToUpdates ? _self.isListeningToUpdates : isListeningToUpdates // ignore: cast_nullable_to_non_nullable
as bool,updateMessage: null == updateMessage ? _self.updateMessage : updateMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AddressLoading implements TrackState {
  const _AddressLoading({required this.latitude, required this.longitude, required this.accuracy, required this.timestamp, this.isLocationEnabled = true, this.isListeningToUpdates = false, this.message = 'Getting address...'});
  

 final  double latitude;
 final  double longitude;
 final  double accuracy;
 final  DateTime timestamp;
@JsonKey() final  bool isLocationEnabled;
@JsonKey() final  bool isListeningToUpdates;
@JsonKey() final  String message;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressLoadingCopyWith<_AddressLoading> get copyWith => __$AddressLoadingCopyWithImpl<_AddressLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressLoading&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isLocationEnabled, isLocationEnabled) || other.isLocationEnabled == isLocationEnabled)&&(identical(other.isListeningToUpdates, isListeningToUpdates) || other.isListeningToUpdates == isListeningToUpdates)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy,timestamp,isLocationEnabled,isListeningToUpdates,message);

@override
String toString() {
  return 'TrackState.addressLoading(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, timestamp: $timestamp, isLocationEnabled: $isLocationEnabled, isListeningToUpdates: $isListeningToUpdates, message: $message)';
}


}

/// @nodoc
abstract mixin class _$AddressLoadingCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$AddressLoadingCopyWith(_AddressLoading value, $Res Function(_AddressLoading) _then) = __$AddressLoadingCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracy, DateTime timestamp, bool isLocationEnabled, bool isListeningToUpdates, String message
});




}
/// @nodoc
class __$AddressLoadingCopyWithImpl<$Res>
    implements _$AddressLoadingCopyWith<$Res> {
  __$AddressLoadingCopyWithImpl(this._self, this._then);

  final _AddressLoading _self;
  final $Res Function(_AddressLoading) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,Object? timestamp = null,Object? isLocationEnabled = null,Object? isListeningToUpdates = null,Object? message = null,}) {
  return _then(_AddressLoading(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isLocationEnabled: null == isLocationEnabled ? _self.isLocationEnabled : isLocationEnabled // ignore: cast_nullable_to_non_nullable
as bool,isListeningToUpdates: null == isListeningToUpdates ? _self.isListeningToUpdates : isListeningToUpdates // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements TrackState {
  const _Error({required this.message, this.details, this.canRetry = false});
  

 final  String message;
 final  String? details;
@JsonKey() final  bool canRetry;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry));
}


@override
int get hashCode => Object.hash(runtimeType,message,details,canRetry);

@override
String toString() {
  return 'TrackState.error(message: $message, details: $details, canRetry: $canRetry)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, String? details, bool canRetry
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? details = freezed,Object? canRetry = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _NoLocation implements TrackState {
  const _NoLocation({this.message = 'Unable to get location'});
  

@JsonKey() final  String message;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoLocationCopyWith<_NoLocation> get copyWith => __$NoLocationCopyWithImpl<_NoLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoLocation&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TrackState.noLocation(message: $message)';
}


}

/// @nodoc
abstract mixin class _$NoLocationCopyWith<$Res> implements $TrackStateCopyWith<$Res> {
  factory _$NoLocationCopyWith(_NoLocation value, $Res Function(_NoLocation) _then) = __$NoLocationCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$NoLocationCopyWithImpl<$Res>
    implements _$NoLocationCopyWith<$Res> {
  __$NoLocationCopyWithImpl(this._self, this._then);

  final _NoLocation _self;
  final $Res Function(_NoLocation) _then;

/// Create a copy of TrackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_NoLocation(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
