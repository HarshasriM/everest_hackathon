import '../../domain/entities/contact.dart';

/// API response model for emergency contacts list
class EmergencyContactsResponse {
  final bool success;
  final List<EmergencyContactApiModel> data;
  final String? message;

  EmergencyContactsResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory EmergencyContactsResponse.fromJson(Map<String, dynamic> json) {
    return EmergencyContactsResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => EmergencyContactApiModel.fromJson(item))
              .toList() ??
          [],
      message: json['message'],
    );
  }
}

/// API response model for single emergency contact operations
class EmergencyContactResponse {
  final bool success;
  final String message;
  final EmergencyContactApiModel? data;

  EmergencyContactResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory EmergencyContactResponse.fromJson(Map<String, dynamic> json) {
    return EmergencyContactResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? EmergencyContactApiModel.fromJson(json['data'])
          : null,
    );
  }
}

/// API model for emergency contact data
class EmergencyContactApiModel {
  final String id;
  final String user;
  final String name;
  final String phoneNumber;
  final String? relationship;

  EmergencyContactApiModel({
    required this.id,
    required this.user,
    required this.name,
    required this.phoneNumber,
    this.relationship,
  });

  factory EmergencyContactApiModel.fromJson(Map<String, dynamic> json) {
    // Handle multiple ID field names from API responses
    final id = json['_id'] ?? json['id'] ?? json['contact_id'] ?? '';
    return EmergencyContactApiModel(
      id: id,
      user: json['user'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      relationship: json['relationship'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'name': name,
      'phoneNumber': phoneNumber,
      if (relationship != null) 'relationship': relationship,
    };
  }

  /// Convert API model to domain entity
  Contact toEntity() {
    return Contact(
      id: id,
      name: name,
      phone: phoneNumber,
      relationship: relationship ?? 'Other',
      isPrimary: false,
      canReceiveSOS: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

/// Request model for adding emergency contact
class AddEmergencyContactRequest {
  final String userId;
  final String name;
  final String phoneNumber;
  final String relationship;

  AddEmergencyContactRequest({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
    };
  }
}

/// Request model for updating emergency contact
class UpdateEmergencyContactRequest {
  final String name;
  final String phoneNumber;
  final String relationship;

  UpdateEmergencyContactRequest({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
    };
  }
}
