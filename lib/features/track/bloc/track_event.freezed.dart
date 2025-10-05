// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent()';
}


}

/// @nodoc
class $TrackEventCopyWith<$Res>  {
$TrackEventCopyWith(TrackEvent _, $Res Function(TrackEvent) __);
}


/// Adds pattern-matching-related methods to [TrackEvent].
extension TrackEventPatterns on TrackEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initialize value)?  initialize,TResult Function( _RequestPermission value)?  requestPermission,TResult Function( _GetCurrentLocation value)?  getCurrentLocation,TResult Function( _StartLocationUpdates value)?  startLocationUpdates,TResult Function( _StopLocationUpdates value)?  stopLocationUpdates,TResult Function( _UpdateLocation value)?  updateLocation,TResult Function( _FetchAddress value)?  fetchAddress,TResult Function( _CenterOnCurrentLocation value)?  centerOnCurrentLocation,TResult Function( _LocationError value)?  locationError,TResult Function( _Retry value)?  retry,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that);case _RequestPermission() when requestPermission != null:
return requestPermission(_that);case _GetCurrentLocation() when getCurrentLocation != null:
return getCurrentLocation(_that);case _StartLocationUpdates() when startLocationUpdates != null:
return startLocationUpdates(_that);case _StopLocationUpdates() when stopLocationUpdates != null:
return stopLocationUpdates(_that);case _UpdateLocation() when updateLocation != null:
return updateLocation(_that);case _FetchAddress() when fetchAddress != null:
return fetchAddress(_that);case _CenterOnCurrentLocation() when centerOnCurrentLocation != null:
return centerOnCurrentLocation(_that);case _LocationError() when locationError != null:
return locationError(_that);case _Retry() when retry != null:
return retry(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initialize value)  initialize,required TResult Function( _RequestPermission value)  requestPermission,required TResult Function( _GetCurrentLocation value)  getCurrentLocation,required TResult Function( _StartLocationUpdates value)  startLocationUpdates,required TResult Function( _StopLocationUpdates value)  stopLocationUpdates,required TResult Function( _UpdateLocation value)  updateLocation,required TResult Function( _FetchAddress value)  fetchAddress,required TResult Function( _CenterOnCurrentLocation value)  centerOnCurrentLocation,required TResult Function( _LocationError value)  locationError,required TResult Function( _Retry value)  retry,}){
final _that = this;
switch (_that) {
case _Initialize():
return initialize(_that);case _RequestPermission():
return requestPermission(_that);case _GetCurrentLocation():
return getCurrentLocation(_that);case _StartLocationUpdates():
return startLocationUpdates(_that);case _StopLocationUpdates():
return stopLocationUpdates(_that);case _UpdateLocation():
return updateLocation(_that);case _FetchAddress():
return fetchAddress(_that);case _CenterOnCurrentLocation():
return centerOnCurrentLocation(_that);case _LocationError():
return locationError(_that);case _Retry():
return retry(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initialize value)?  initialize,TResult? Function( _RequestPermission value)?  requestPermission,TResult? Function( _GetCurrentLocation value)?  getCurrentLocation,TResult? Function( _StartLocationUpdates value)?  startLocationUpdates,TResult? Function( _StopLocationUpdates value)?  stopLocationUpdates,TResult? Function( _UpdateLocation value)?  updateLocation,TResult? Function( _FetchAddress value)?  fetchAddress,TResult? Function( _CenterOnCurrentLocation value)?  centerOnCurrentLocation,TResult? Function( _LocationError value)?  locationError,TResult? Function( _Retry value)?  retry,}){
final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that);case _RequestPermission() when requestPermission != null:
return requestPermission(_that);case _GetCurrentLocation() when getCurrentLocation != null:
return getCurrentLocation(_that);case _StartLocationUpdates() when startLocationUpdates != null:
return startLocationUpdates(_that);case _StopLocationUpdates() when stopLocationUpdates != null:
return stopLocationUpdates(_that);case _UpdateLocation() when updateLocation != null:
return updateLocation(_that);case _FetchAddress() when fetchAddress != null:
return fetchAddress(_that);case _CenterOnCurrentLocation() when centerOnCurrentLocation != null:
return centerOnCurrentLocation(_that);case _LocationError() when locationError != null:
return locationError(_that);case _Retry() when retry != null:
return retry(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initialize,TResult Function()?  requestPermission,TResult Function()?  getCurrentLocation,TResult Function()?  startLocationUpdates,TResult Function()?  stopLocationUpdates,TResult Function( double latitude,  double longitude,  double accuracy)?  updateLocation,TResult Function( double latitude,  double longitude)?  fetchAddress,TResult Function()?  centerOnCurrentLocation,TResult Function( String message)?  locationError,TResult Function()?  retry,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize();case _RequestPermission() when requestPermission != null:
return requestPermission();case _GetCurrentLocation() when getCurrentLocation != null:
return getCurrentLocation();case _StartLocationUpdates() when startLocationUpdates != null:
return startLocationUpdates();case _StopLocationUpdates() when stopLocationUpdates != null:
return stopLocationUpdates();case _UpdateLocation() when updateLocation != null:
return updateLocation(_that.latitude,_that.longitude,_that.accuracy);case _FetchAddress() when fetchAddress != null:
return fetchAddress(_that.latitude,_that.longitude);case _CenterOnCurrentLocation() when centerOnCurrentLocation != null:
return centerOnCurrentLocation();case _LocationError() when locationError != null:
return locationError(_that.message);case _Retry() when retry != null:
return retry();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initialize,required TResult Function()  requestPermission,required TResult Function()  getCurrentLocation,required TResult Function()  startLocationUpdates,required TResult Function()  stopLocationUpdates,required TResult Function( double latitude,  double longitude,  double accuracy)  updateLocation,required TResult Function( double latitude,  double longitude)  fetchAddress,required TResult Function()  centerOnCurrentLocation,required TResult Function( String message)  locationError,required TResult Function()  retry,}) {final _that = this;
switch (_that) {
case _Initialize():
return initialize();case _RequestPermission():
return requestPermission();case _GetCurrentLocation():
return getCurrentLocation();case _StartLocationUpdates():
return startLocationUpdates();case _StopLocationUpdates():
return stopLocationUpdates();case _UpdateLocation():
return updateLocation(_that.latitude,_that.longitude,_that.accuracy);case _FetchAddress():
return fetchAddress(_that.latitude,_that.longitude);case _CenterOnCurrentLocation():
return centerOnCurrentLocation();case _LocationError():
return locationError(_that.message);case _Retry():
return retry();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initialize,TResult? Function()?  requestPermission,TResult? Function()?  getCurrentLocation,TResult? Function()?  startLocationUpdates,TResult? Function()?  stopLocationUpdates,TResult? Function( double latitude,  double longitude,  double accuracy)?  updateLocation,TResult? Function( double latitude,  double longitude)?  fetchAddress,TResult? Function()?  centerOnCurrentLocation,TResult? Function( String message)?  locationError,TResult? Function()?  retry,}) {final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize();case _RequestPermission() when requestPermission != null:
return requestPermission();case _GetCurrentLocation() when getCurrentLocation != null:
return getCurrentLocation();case _StartLocationUpdates() when startLocationUpdates != null:
return startLocationUpdates();case _StopLocationUpdates() when stopLocationUpdates != null:
return stopLocationUpdates();case _UpdateLocation() when updateLocation != null:
return updateLocation(_that.latitude,_that.longitude,_that.accuracy);case _FetchAddress() when fetchAddress != null:
return fetchAddress(_that.latitude,_that.longitude);case _CenterOnCurrentLocation() when centerOnCurrentLocation != null:
return centerOnCurrentLocation();case _LocationError() when locationError != null:
return locationError(_that.message);case _Retry() when retry != null:
return retry();case _:
  return null;

}
}

}

/// @nodoc


class _Initialize implements TrackEvent {
  const _Initialize();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initialize);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.initialize()';
}


}




/// @nodoc


class _RequestPermission implements TrackEvent {
  const _RequestPermission();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestPermission);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.requestPermission()';
}


}




/// @nodoc


class _GetCurrentLocation implements TrackEvent {
  const _GetCurrentLocation();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCurrentLocation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.getCurrentLocation()';
}


}




/// @nodoc


class _StartLocationUpdates implements TrackEvent {
  const _StartLocationUpdates();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartLocationUpdates);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.startLocationUpdates()';
}


}




/// @nodoc


class _StopLocationUpdates implements TrackEvent {
  const _StopLocationUpdates();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopLocationUpdates);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.stopLocationUpdates()';
}


}




/// @nodoc


class _UpdateLocation implements TrackEvent {
  const _UpdateLocation({required this.latitude, required this.longitude, required this.accuracy});
  

 final  double latitude;
 final  double longitude;
 final  double accuracy;

/// Create a copy of TrackEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLocationCopyWith<_UpdateLocation> get copyWith => __$UpdateLocationCopyWithImpl<_UpdateLocation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLocation&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude,accuracy);

@override
String toString() {
  return 'TrackEvent.updateLocation(latitude: $latitude, longitude: $longitude, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class _$UpdateLocationCopyWith<$Res> implements $TrackEventCopyWith<$Res> {
  factory _$UpdateLocationCopyWith(_UpdateLocation value, $Res Function(_UpdateLocation) _then) = __$UpdateLocationCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracy
});




}
/// @nodoc
class __$UpdateLocationCopyWithImpl<$Res>
    implements _$UpdateLocationCopyWith<$Res> {
  __$UpdateLocationCopyWithImpl(this._self, this._then);

  final _UpdateLocation _self;
  final $Res Function(_UpdateLocation) _then;

/// Create a copy of TrackEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracy = null,}) {
  return _then(_UpdateLocation(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _FetchAddress implements TrackEvent {
  const _FetchAddress({required this.latitude, required this.longitude});
  

 final  double latitude;
 final  double longitude;

/// Create a copy of TrackEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FetchAddressCopyWith<_FetchAddress> get copyWith => __$FetchAddressCopyWithImpl<_FetchAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchAddress&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'TrackEvent.fetchAddress(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$FetchAddressCopyWith<$Res> implements $TrackEventCopyWith<$Res> {
  factory _$FetchAddressCopyWith(_FetchAddress value, $Res Function(_FetchAddress) _then) = __$FetchAddressCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$FetchAddressCopyWithImpl<$Res>
    implements _$FetchAddressCopyWith<$Res> {
  __$FetchAddressCopyWithImpl(this._self, this._then);

  final _FetchAddress _self;
  final $Res Function(_FetchAddress) _then;

/// Create a copy of TrackEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_FetchAddress(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _CenterOnCurrentLocation implements TrackEvent {
  const _CenterOnCurrentLocation();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CenterOnCurrentLocation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.centerOnCurrentLocation()';
}


}




/// @nodoc


class _LocationError implements TrackEvent {
  const _LocationError({required this.message});
  

 final  String message;

/// Create a copy of TrackEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationErrorCopyWith<_LocationError> get copyWith => __$LocationErrorCopyWithImpl<_LocationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocationError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TrackEvent.locationError(message: $message)';
}


}

/// @nodoc
abstract mixin class _$LocationErrorCopyWith<$Res> implements $TrackEventCopyWith<$Res> {
  factory _$LocationErrorCopyWith(_LocationError value, $Res Function(_LocationError) _then) = __$LocationErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$LocationErrorCopyWithImpl<$Res>
    implements _$LocationErrorCopyWith<$Res> {
  __$LocationErrorCopyWithImpl(this._self, this._then);

  final _LocationError _self;
  final $Res Function(_LocationError) _then;

/// Create a copy of TrackEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_LocationError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Retry implements TrackEvent {
  const _Retry();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Retry);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TrackEvent.retry()';
}


}




// dart format on
