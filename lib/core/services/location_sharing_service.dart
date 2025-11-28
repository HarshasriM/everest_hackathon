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
  DateTime? _sharingStartTime;
  Duration? _sharingDuration;
  bool _isSharing = false;


  // Stream controller for sharing status updates
  final StreamController<LocationSharingStatus> _statusController =
      StreamController<LocationSharingStatus>.broadcast();


  /// Stream to listen to location sharing status changes
  Stream<LocationSharingStatus> get statusStream => _statusController.stream;


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

    // Generate location message
    final message = _generateLocationMessage(
      latitude: latitude,
      longitude: longitude,
      address: address,
      duration: duration,
    );

    // Share the  location
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



    // Emit initial status
    _statusController.add(
      LocationSharingStatus(
        isSharing: true,
        remainingTime: duration,
        totalDuration: duration,
      ),
    );
  }

 
  /// Stop location sharing
  Future<void> stopLocationSharing() async {
    _sharingTimer?.cancel();
    _sharingTimer = null;
    _isSharing = false;
    _sharingStartTime = null;
    _sharingDuration = null;

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
  }) {
    final googleMapsLink = generateGoogleMapsLink(latitude, longitude);
    final timestamp = DateTime.now();

    String message = '''📍 Live Location Update - SHE App

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
    _statusController.close();
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


