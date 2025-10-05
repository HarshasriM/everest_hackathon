/// User entity representing the core user data
class UserEntity {
  final String id;
  final String phoneNumber;
  final String name;
  final String? email;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final String? address;
  final List<EmergencyContactEntity> emergencyContacts;
  final bool isProfileComplete;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserSettings settings;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.email,
    this.profileImageUrl,
    this.dateOfBirth,
    this.bloodGroup,
    this.address,
    this.emergencyContacts = const [],
    this.isProfileComplete = false,
    this.isVerified = false,
    required this.createdAt,
    this.lastLoginAt,
    required this.settings,
  });

  // Check if profile has the minimum required information
  bool get hasRequiredInfo => name.isNotEmpty;

  // Create an empty user
  static UserEntity empty() {
    return UserEntity(
      id: '',
      phoneNumber: '',
      name: '',
      createdAt: DateTime.now(),
      settings: UserSettings.defaults(),
    );
  }
}

/// Emergency contact entity
class EmergencyContactEntity {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final bool isPrimary;
  final bool canReceiveSosAlerts;
  final bool canTrackLocation;
  final String? email;

  const EmergencyContactEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.isPrimary = false,
    this.canReceiveSosAlerts = true,
    this.canTrackLocation = false,
    this.email,
  });
}

/// User settings entity
class UserSettings {
  final String languageCode;
  final bool sosButtonEnabled;
  final bool shakeToSos;
  final bool voiceActivation;
  final bool autoSendLocation;
  final bool discreteMode;
  final int sosCountdown; // seconds before SOS is sent
  final bool biometricLock;
  final bool notificationsEnabled;
  final String emergencyMessage;

  const UserSettings({
    required this.languageCode,
    required this.sosButtonEnabled,
    required this.shakeToSos,
    required this.voiceActivation,
    required this.autoSendLocation,
    required this.discreteMode,
    required this.sosCountdown,
    required this.biometricLock,
    required this.notificationsEnabled,
    required this.emergencyMessage,
  });

  factory UserSettings.defaults() {
    return const UserSettings(
      languageCode: 'en',
      sosButtonEnabled: true,
      shakeToSos: true,
      voiceActivation: false,
      autoSendLocation: true,
      discreteMode: false,
      sosCountdown: 5,
      biometricLock: false,
      notificationsEnabled: true,
      emergencyMessage: 'I need help! This is an emergency.',
    );
  }
}
