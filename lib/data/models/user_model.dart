import '../../domain/entities/user_entity.dart';

/// User data model
class UserModel {
  final String id;
  final String phoneNumber;
  final String name;
  final String? email;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final String? address;
  final List<EmergencyContactModel> emergencyContacts;
  final bool isProfileComplete;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserSettingsModel settings;

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle the API response format
    return UserModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      bloodGroup: json['bloodGroup'] as String?,
      address: json['address'] as String?,
      emergencyContacts: (json['emergencyContacts'] as List<dynamic>?)
              ?.map((e) => EmergencyContactModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? const [],
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      settings: json['settings'] != null
          ? UserSettingsModel.fromJson(json['settings'] as Map<String, dynamic>)
          : UserSettingsModel.defaults(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodGroup': bloodGroup,
      'address': address,
      'emergencyContacts': emergencyContacts.map((e) => e.toJson()).toList(),
      'isProfileComplete': isProfileComplete,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'settings': settings.toJson(),
    };
  }

  // Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phoneNumber: phoneNumber,
      name: name,
      email: email,
      profileImageUrl: profileImageUrl,
      dateOfBirth: dateOfBirth,
      bloodGroup: bloodGroup,
      address: address,
      emergencyContacts: emergencyContacts
          .map((contact) => contact.toEntity())
          .toList(),
      isProfileComplete: isProfileComplete,
      isVerified: isVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      settings: settings.toEntity(),
    );
  }

  // Create from entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      email: entity.email,
      profileImageUrl: entity.profileImageUrl,
      dateOfBirth: entity.dateOfBirth,
      bloodGroup: entity.bloodGroup,
      address: entity.address,
      emergencyContacts: entity.emergencyContacts
          .map((contact) => EmergencyContactModel.fromEntity(contact))
          .toList(),
      isProfileComplete: entity.isProfileComplete,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
      settings: UserSettingsModel.fromEntity(entity.settings),
    );
  }
}

/// Emergency contact data model
class EmergencyContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final bool isPrimary;
  final bool canReceiveSosAlerts;
  final bool canTrackLocation;
  final String? email;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.isPrimary = false,
    this.canReceiveSosAlerts = true,
    this.canTrackLocation = false,
    this.email,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
      canReceiveSosAlerts: json['canReceiveSosAlerts'] as bool? ?? true,
      canTrackLocation: json['canTrackLocation'] as bool? ?? false,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'isPrimary': isPrimary,
      'canReceiveSosAlerts': canReceiveSosAlerts,
      'canTrackLocation': canTrackLocation,
      'email': email,
    };
  }

  // Convert to entity
  EmergencyContactEntity toEntity() {
    return EmergencyContactEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      relationship: relationship,
      isPrimary: isPrimary,
      canReceiveSosAlerts: canReceiveSosAlerts,
      canTrackLocation: canTrackLocation,
      email: email,
    );
  }

  // Create from entity
  factory EmergencyContactModel.fromEntity(EmergencyContactEntity entity) {
    return EmergencyContactModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      relationship: entity.relationship,
      isPrimary: entity.isPrimary,
      canReceiveSosAlerts: entity.canReceiveSosAlerts,
      canTrackLocation: entity.canTrackLocation,
      email: entity.email,
    );
  }
}

/// User settings data model
class UserSettingsModel {
  final String languageCode;
  final bool sosButtonEnabled;
  final bool shakeToSos;
  final bool voiceActivation;
  final bool autoSendLocation;
  final bool discreteMode;
  final int sosCountdown;
  final bool biometricLock;
  final bool notificationsEnabled;
  final String emergencyMessage;

  const UserSettingsModel({
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

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      languageCode: json['languageCode'] as String? ?? 'en',
      sosButtonEnabled: json['sosButtonEnabled'] as bool? ?? true,
      shakeToSos: json['shakeToSos'] as bool? ?? false,
      voiceActivation: json['voiceActivation'] as bool? ?? false,
      autoSendLocation: json['autoSendLocation'] as bool? ?? true,
      discreteMode: json['discreteMode'] as bool? ?? false,
      sosCountdown: json['sosCountdown'] as int? ?? 5,
      biometricLock: json['biometricLock'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emergencyMessage: json['emergencyMessage'] as String? ?? 'I am in an emergency situation and need help!',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'sosButtonEnabled': sosButtonEnabled,
      'shakeToSos': shakeToSos,
      'voiceActivation': voiceActivation,
      'autoSendLocation': autoSendLocation,
      'discreteMode': discreteMode,
      'sosCountdown': sosCountdown,
      'biometricLock': biometricLock,
      'notificationsEnabled': notificationsEnabled,
      'emergencyMessage': emergencyMessage,
    };
  }

  // Convert to entity
  UserSettings toEntity() {
    return UserSettings(
      languageCode: languageCode,
      sosButtonEnabled: sosButtonEnabled,
      shakeToSos: shakeToSos,
      voiceActivation: voiceActivation,
      autoSendLocation: autoSendLocation,
      discreteMode: discreteMode,
      sosCountdown: sosCountdown,
      biometricLock: biometricLock,
      notificationsEnabled: notificationsEnabled,
      emergencyMessage: emergencyMessage,
    );
  }

  // Create from entity
  factory UserSettingsModel.fromEntity(UserSettings entity) {
    return UserSettingsModel(
      languageCode: entity.languageCode,
      sosButtonEnabled: entity.sosButtonEnabled,
      shakeToSos: entity.shakeToSos,
      voiceActivation: entity.voiceActivation,
      autoSendLocation: entity.autoSendLocation,
      discreteMode: entity.discreteMode,
      sosCountdown: entity.sosCountdown,
      biometricLock: entity.biometricLock,
      notificationsEnabled: entity.notificationsEnabled,
      emergencyMessage: entity.emergencyMessage,
    );
  }

  factory UserSettingsModel.defaults() {
    return UserSettingsModel.fromEntity(UserSettings.defaults());
  }
}
