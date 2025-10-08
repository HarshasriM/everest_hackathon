import '../../domain/entities/user_entity.dart';

/// User data model
class UserModel {
  final String id;
  final String phoneNumber;
  final String name;
  final String? email;
  final bool isProfileComplete;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.name,
    this.email,
    this.isProfileComplete = false,
    this.isVerified = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  /// Creates a UserModel from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  /// Converts UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'isProfileComplete': isProfileComplete,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Converts UserModel to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phoneNumber: phoneNumber,
      name: name,
      email: email,
      isProfileComplete: isProfileComplete,
      isVerified: isVerified,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }

  /// Creates a UserModel from UserEntity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      email: entity.email,
      isProfileComplete: entity.isProfileComplete,
      isVerified: entity.isVerified,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }

  /// Creates a default UserModel
  factory UserModel.empty() {
    return UserModel(
      id: '',
      phoneNumber: '',
      name: '',
      createdAt: DateTime.now(),
    );
  }
}
