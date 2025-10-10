import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for handling live location sharing functionality
class LocationSharingService {
  static final LocationSharingService _instance =
      LocationSharingService._internal();
  factory LocationSharingService() => _instance;
  LocationSharingService._internal();

  Timer? _sharingTimer;
  Timer? _locationUpdateTimer;
  DateTime? _sharingStartTime;
  Duration? _sharingDuration;
  bool _isSharing = false;

  // Current location data
  double? _currentLatitude;
  double? _currentLongitude;
  String? _currentAddress;

  // Location update callback
  Function(double lat, double lng, String address)? _onLocationUpdate;

  // Stream controller for sharing status updates
  final StreamController<LocationSharingStatus> _statusController =
      StreamController<LocationSharingStatus>.broadcast();

  // Stream controller for live location updates
  final StreamController<LiveLocationUpdate> _locationUpdateController =
      StreamController<LiveLocationUpdate>.broadcast();

  /// Stream to listen to location sharing status changes
  Stream<LocationSharingStatus> get statusStream => _statusController.stream;

  /// Stream to listen to live location updates
  Stream<LiveLocationUpdate> get locationUpdateStream =>
      _locationUpdateController.stream;

  /// Check if currently sharing location
  bool get isSharing => _isSharing;

  /// Get remaining sharing time
  Duration? get remainingTime {
    if (!_isSharing || _sharingStartTime == null || _sharingDuration == null) {
      return null;
    }

    final elapsed = DateTime.now().difference(_sharingStartTime!);
    final remaining = _sharingDuration! - elapsed;

    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Set location update callback for live tracking
  void setLocationUpdateCallback(
    Function(double lat, double lng, String address) callback,
  ) {
    _onLocationUpdate = callback;
  }

  /// Start sharing live location with specified duration
  Future<void> startLocationSharing({
    required double latitude,
    required double longitude,
    required String address,
    required Duration duration,
  }) async {
    // Stop any existing sharing
    await stopLocationSharing();

    _isSharing = true;
    _sharingStartTime = DateTime.now();
    _sharingDuration = duration;
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _currentAddress = address;

    // Generate initial location message
    final message = _generateLocationMessage(
      latitude: latitude,
      longitude: longitude,
      address: address,
      duration: duration,
    );

    // Share the initial location
    await Share.share(message, subject: '📍 Live Location Sharing - SHE App');

    // Start timer for status updates (every second)
    _sharingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = remainingTime;

      if (remaining == null || remaining <= Duration.zero) {
        stopLocationSharing();
      } else {
        _statusController.add(
          LocationSharingStatus(
            isSharing: true,
            remainingTime: remaining,
            totalDuration: _sharingDuration!,
          ),
        );
      }
    });

    // Start timer for live location updates (every 30 seconds)
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isSharing && _onLocationUpdate != null) {
        // Request location update from the callback
        _onLocationUpdate!(
          _currentLatitude!,
          _currentLongitude!,
          _currentAddress!,
        );
      }
    });

    // Emit initial status
    _statusController.add(
      LocationSharingStatus(
        isSharing: true,
        remainingTime: duration,
        totalDuration: duration,
      ),
    );
  }

  /// Update current location during live sharing
  Future<void> updateCurrentLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    if (!_isSharing) return;

    // Update current location
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _currentAddress = address;

    // Generate updated location message
    final message = _generateLocationMessage(
      latitude: latitude,
      longitude: longitude,
      address: address,
      duration: remainingTime,
      isUpdate: true,
    );

    // Share the updated location
    await Share.share(message, subject: '📍 Live Location Update - SHE App');

    // Emit location update
    _locationUpdateController.add(
      LiveLocationUpdate(
        latitude: latitude,
        longitude: longitude,
        address: address,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Stop location sharing
  Future<void> stopLocationSharing() async {
    _sharingTimer?.cancel();
    _locationUpdateTimer?.cancel();
    _sharingTimer = null;
    _locationUpdateTimer = null;
    _isSharing = false;
    _sharingStartTime = null;
    _sharingDuration = null;
    _currentLatitude = null;
    _currentLongitude = null;
    _currentAddress = null;

    _statusController.add(
      const LocationSharingStatus(
        isSharing: false,
        remainingTime: null,
        totalDuration: null,
      ),
    );
  }

  /// Share location via SMS to specific contact
  Future<bool> shareLocationViaSMS({
    required String phoneNumber,
    required double latitude,
    required double longitude,
    required String address,
    Duration? duration,
  }) async {
    try {
      final message = _generateLocationMessage(
        latitude: latitude,
        longitude: longitude,
        address: address,
        duration: duration,
      );

      final uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Share location via WhatsApp
  Future<bool> shareLocationViaWhatsApp({
    required double latitude,
    required double longitude,
    required String address,
    Duration? duration,
  }) async {
    try {
      final message = _generateLocationMessage(
        latitude: latitude,
        longitude: longitude,
        address: address,
        duration: duration,
      );

      final encodedMessage = Uri.encodeComponent(message);
      final uri = Uri.parse('https://wa.me/?text=$encodedMessage');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Generate Google Maps link for location
  String generateGoogleMapsLink(double latitude, double longitude) {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  /// Generate location sharing message
  String _generateLocationMessage({
    required double latitude,
    required double longitude,
    required String address,
    Duration? duration,
    bool isUpdate = false,
  }) {
    final googleMapsLink = generateGoogleMapsLink(latitude, longitude);
    final timestamp = DateTime.now();

    String message = isUpdate
        ? '''📍 Live Location Update - SHE App

📍 Updated Location:
$address

🗺️ View on Map: $googleMapsLink

📅 Updated at: ${timestamp.toString().substring(0, 19)}'''
        : '''📍 Live Location Sharing - SHE App

📍 Current Location:
$address

🗺️ View on Map: $googleMapsLink

📅 Shared at: ${timestamp.toString().substring(0, 19)}''';

    if (duration != null) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;

      String durationText;
      if (hours > 0) {
        durationText = '${hours}h ${minutes}m';
      } else {
        durationText = '${minutes}m';
      }

      message += '\n⏰ Sharing Duration: $durationText';
      message +=
          '\n\n⚠️ This location will be shared for $durationText. You will receive an update when sharing stops.';
    }

    message += '\n\n🛡️ Shared via SHE - Women Safety App';

    return message;
  }

  /// Dispose resources
  void dispose() {
    _sharingTimer?.cancel();
    _locationUpdateTimer?.cancel();
    _statusController.close();
    _locationUpdateController.close();
  }
}

/// Location sharing status model
class LocationSharingStatus {
  final bool isSharing;
  final Duration? remainingTime;
  final Duration? totalDuration;

  const LocationSharingStatus({
    required this.isSharing,
    this.remainingTime,
    this.totalDuration,
  });

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    if (!isSharing || remainingTime == null || totalDuration == null) {
      return 0.0;
    }

    final elapsed = totalDuration! - remainingTime!;
    return elapsed.inSeconds / totalDuration!.inSeconds;
  }

  /// Get formatted remaining time string
  String get formattedRemainingTime {
    if (remainingTime == null) return '';

    final hours = remainingTime!.inHours;
    final minutes = remainingTime!.inMinutes % 60;
    final seconds = remainingTime!.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

/// Live location update model
class LiveLocationUpdate {
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;

  const LiveLocationUpdate({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
  });

  /// Generate Google Maps link for this location
  String get googleMapsLink {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  /// Get formatted timestamp
  String get formattedTimestamp {
    return timestamp.toString().substring(0, 19);
  }
}
