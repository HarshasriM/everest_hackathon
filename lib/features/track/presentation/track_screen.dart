import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/dependency_injection/di_container.dart';
import '../bloc/track_bloc.dart';
import '../bloc/track_event.dart';
import '../bloc/track_state.dart';

/// Track screen with Google Maps showing current location
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TrackBloc>()..add(const TrackEvent.initialize()),
      child: const _TrackScreenContent(),
    );
  }
}

class _TrackScreenContent extends StatefulWidget {
  const _TrackScreenContent();

  @override
  State<_TrackScreenContent> createState() => _TrackScreenContentState();
}

class _TrackScreenContentState extends State<_TrackScreenContent>
    with TickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController = Completer();

  // Map settings
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090), // Default to Delhi
    zoom: 15,
  );

  Set<Marker> _markers = {};
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
  }

  
  Future<void> _centerOnCurrentLocation() async {
    final state = context.read<TrackBloc>().state;
    if (state.hasLocation) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(state.latitude!, state.longitude!),
            zoom: 18,
          ),
        ),
      );
      context.read<TrackBloc>().add(const TrackEvent.centerOnCurrentLocation());
    }
  }

  void _updateMarkers(TrackState state) {
    if (state.hasLocation) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(state.latitude!, state.longitude!),
            infoWindow: const InfoWindow(
              title: 'Your Location',
              snippet: 'Current position',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        };
      });
    }
  }

  Future<void> _updateMapCamera(TrackState state) async {
    if (state.hasLocation) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(state.latitude!, state.longitude!),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrackBloc, TrackState>(
        listener: (context, state) {
          // Update markers when location changes
          if (state.hasLocation) {
            _updateMarkers(state);
            _updateMapCamera(state);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Google Map
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _initialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                },
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

              // Top gradient overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 120.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // App Bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 10.h,
                left: 16.w,
                right: 16.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Track Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),

              // Center location button
              Positioned(
                right: 16.w,
                bottom: 200.h,
                child: FloatingActionButton(
                  onPressed: _centerOnCurrentLocation,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ),

              // Bottom address panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildAddressPanel(context, state),
              ),

              // Loading overlay
              if (state.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              // Error overlay
              if (state.isError)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: _buildErrorWidget(context, state),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressPanel(BuildContext context, TrackState state) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).primaryColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Location',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      state.address ?? 'Getting location...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildErrorWidget(BuildContext context, TrackState state) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            state.maybeWhen(
              error: (message, _, __) => message,
              permissionDenied: (_, message) => message,
              locationServiceDisabled: (message) => message,
              noLocation: (message) => message,
              orElse: () => 'Unknown error',
            ),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<TrackBloc>().add(const TrackEvent.retry());
                },
                child: const Text('Retry'),
              ),
              if (state.maybeWhen(
                permissionDenied: (status, _) => status == LocationPermissionStatus.denied,
                orElse: () => false,
              ))
                ElevatedButton(
                  onPressed: () {
                    context.read<TrackBloc>().add(const TrackEvent.requestPermission());
                  },
                  child: const Text('Grant Permission'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
