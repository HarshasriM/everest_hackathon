import 'dart:async';
import 'package:everest_hackathon/shared/widgets/custom_app_bar.dart';
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
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
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
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        };
      });
    }
  }

  Future<void> _updateMapCamera(TrackState state) async {
    if (state.hasLocation) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(state.latitude!, state.longitude!)),
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
      appBar: CustomAppBar(
        
      ),
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
                        Colors.black.withOpacity(0.6),
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
                            color: Colors.black.withOpacity(0.5),
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
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),

              // Error overlay
              if (state.isError)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: _buildErrorWidget(context, state)),
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
            color: Colors.black.withOpacity(0.1),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                    Row(
                      children: [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () =>
                              _showLocationSharingDialog(context, state),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              Icons.share,
                              size: 16.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
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

  void _showLocationSharingDialog(BuildContext context, TrackState state) {
    if (!state.hasLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available for sharing')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<TrackBloc>(),
        child: _LocationSharingDialog(
          latitude: state.latitude!,
          longitude: state.longitude!,
          address: state.address ?? 'Unknown location',
          onStartSharing: (duration) {
            context.read<TrackBloc>().add(
              TrackEvent.startLocationSharing(duration: duration),
            );
          },
          onStopSharing: () {
            context.read<TrackBloc>().add(
              const TrackEvent.stopLocationSharing(),
            );
          },
          isCurrentlySharing: state.isLocationSharing,
          remainingTime: state.locationSharingRemainingTime,
        ),
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
          Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            state.maybeWhen(
              error: (message, _, __) => message,
              permissionDenied: (_, message) => message,
              locationServiceDisabled: (message) => message,
              noLocation: (message) => message,
              orElse: () => 'Unknown error',
            ),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          // Fix: Wrap Row in a SizedBox with a defined width to avoid infinite width constraint
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<TrackBloc>().add(const TrackEvent.retry());
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(100.w, 40.h),
                  ),
                  child: const Text('Retry'),
                ),
                if (state.maybeWhen(
                  permissionDenied: (status, _) =>
                      status == LocationPermissionStatus.denied,
                  orElse: () => false,
                ))
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrackBloc>().add(
                        const TrackEvent.requestPermission(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100.w, 40.h),
                    ),
                    child: const Text('Grant Permission'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Location sharing dialog widget
class _LocationSharingDialog extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  final Function(Duration) onStartSharing;
  final VoidCallback onStopSharing;
  final bool isCurrentlySharing;
  final Duration? remainingTime;

  const _LocationSharingDialog({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.onStartSharing,
    required this.onStopSharing,
    required this.isCurrentlySharing,
    this.remainingTime,
  });

  @override
  State<_LocationSharingDialog> createState() => _LocationSharingDialogState();
}

class _LocationSharingDialogState extends State<_LocationSharingDialog> {
  int selectedDurationIndex = 0;
  final List<Duration> durations = [
    const Duration(minutes: 15),
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
    const Duration(hours: 8),
  ];

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _formatRemainingTime(Duration? duration) {
    if (duration == null) return '';

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.share_location,
                    color: Theme.of(context).primaryColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    widget.isCurrentlySharing
                        ? 'Location Sharing Active'
                        : 'Share Live Location',
                    style: TextStyle(
                      fontSize: 17.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            if (widget.isCurrentlySharing) ...[
              // Currently sharing status
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.green, size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Sharing ends in: ${_formatRemainingTime(widget.remainingTime)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: 190.h,
                      height: 50.h,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onStopSharing();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.stop, color: Colors.white),
                        label: const Text(
                          'Stop Sharing',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Duration selection
              Text(
                'Select sharing duration:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              SizedBox(height: 18.h),

              // Duration dropdown
              Container(
                width: 190.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedDurationIndex,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12.r),
                    dropdownColor: Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).primaryColor,
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    items: durations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final duration = entry.value;

                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(_formatDuration(duration)),
                      );
                    }).toList(),
                    onChanged: (newIndex) {
                      if (newIndex != null) {
                        setState(() => selectedDurationIndex = newIndex);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90.w,
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SizedBox(
                    width: 90.w,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        widget.onStartSharing(durations[selectedDurationIndex]);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.share, color: Colors.white, size: 16.sp),
                      label: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: 16.h),

            // Location info
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      widget.address,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
