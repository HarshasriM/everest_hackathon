/// SOS Alert entity
class SosEntity {
  final String id;
  final String userId;
  final DateTime triggeredAt;
  final LocationEntity location;
  final SosType type;
  final SosStatus status;
  final String? message;
  final List<String> notifiedContacts;
  final List<String> mediaUrls; // Photos/videos/audio
  final DateTime? resolvedAt;
  final String? resolutionNotes;

  const SosEntity({
    required this.id,
    required this.userId,
    required this.triggeredAt,
    required this.location,
    required this.type,
    required this.status,
    this.message,
    this.notifiedContacts = const [],
    this.mediaUrls = const [],
    this.resolvedAt,
    this.resolutionNotes,
  });

  Duration get activeDuration {
    final endTime = resolvedAt ?? DateTime.now();
    return endTime.difference(triggeredAt);
  }
}

/// Location entity
class LocationEntity {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final String? address;
  final String? landmark;
  final DateTime timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.address,
    this.landmark,
    required this.timestamp,
  });

  String get coordinates => '$latitude, $longitude';
  
  String get googleMapsUrl => 
    'https://maps.google.com/?q=$latitude,$longitude';
}

/// SOS Type
enum SosType {
  manual, // User pressed SOS button
  shake, // Shake detection triggered
  voice, // Voice command triggered
  scheduled, // Pre-scheduled check-in failed
  automatic, // AI detected emergency
}

/// SOS Status
enum SosStatus {
  triggered,
  alertsSent,
  acknowledged,
  helpOnWay,
  resolved,
  cancelled,
  failed,
}
