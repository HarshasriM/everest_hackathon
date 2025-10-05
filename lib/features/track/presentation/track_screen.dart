import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';
// import '../../../core/theme/color_scheme.dart';

/// Track screen with Google Maps showing current location
class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _mapController = Completer();
  final LocationService _locationService = LocationService();
  
  Position? _currentPosition;
  String _currentAddress = 'Getting location...';
  bool _isLoading = true;
  bool _isLocationEnabled = false;
  StreamSubscription<Position>? _positionSubscription;
  
  // Map settings
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(28.6139, 77.2090), // Default to Delhi
    zoom: 15,
  );
  
  Set<Marker> _markers = {};
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeLocation();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = 'Location services disabled';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position? position = await _locationService.getCurrentPosition();
      if (position != null) {
        await _updateLocation(position);
        _startLocationUpdates();
      } else {
        setState(() {
          _currentAddress = 'Unable to get location';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Location error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    _positionSubscription = _locationService.getPositionStream().listen(
      (Position position) {
        _updateLocation(position);
      },
      onError: (error) {
        print('Location stream error: $error');
      },
    );
  }

  Future<void> _updateLocation(Position position) async {
    setState(() {
      _currentPosition = position;
      _isLocationEnabled = true;
      _isLoading = false;
    });

    // Update camera position
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );

    // Update marker
    _updateMarker(position);

    // Get address
    String address = await _locationService.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );
    
    setState(() {
      _currentAddress = address;
    });
  }

  void _updateMarker(Position position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  Future<void> _centerOnCurrentLocation() async {
    if (_currentPosition != null) {
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 18,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _positionSubscription?.cancel();
    _locationService.stopPositionStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                // AnimatedBuilder(
                //   animation: _pulseAnimation,
                //   builder: (context, child) {
                //     return Transform.scale(
                //       scale: _isLocationEnabled ? _pulseAnimation.value : 1.0,
                //       child: Container(
                //         padding: EdgeInsets.all(8.w),
                //         decoration: BoxDecoration(
                //           color: _isLocationEnabled 
                //               ? Colors.green.withOpacity(0.9)
                //               : Colors.red.withOpacity(0.9),
                //           borderRadius: BorderRadius.circular(20.r),
                //         ),
                //         child: Icon(
                //           _isLocationEnabled ? Icons.gps_fixed : Icons.gps_off,
                //           color: Colors.white,
                //           size: 20.sp,
                //         ),
                //       ),
                //     );
                //   },
                // ),
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
            child: _buildAddressPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressPanel() {
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
                    Text(
                      'Current Location',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (_isLoading)
                      Row(
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Getting location...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        _currentAddress,
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

}
