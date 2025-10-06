class Contact {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;
  final bool canReceiveSOS;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    this.isPrimary = false,
    this.canReceiveSOS = true,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? phone,
    String? relationship,
    bool? isPrimary,
    bool? canReceiveSOS,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
      canReceiveSOS: canReceiveSOS ?? this.canReceiveSOS,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName => name.trim().isEmpty ? 'Unknown Contact' : name;

  String get formattedPhone {
    // Remove any non-digit characters and format
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return phone;
  }

  bool get isValid => name.trim().isNotEmpty && phone.trim().isNotEmpty;
}

enum ContactRelationship {
  family('Family'),
  friend('Friend'),
  colleague('Colleague'),
  neighbor('Neighbor'),
  other('Other');

  const ContactRelationship(this.displayName);
  final String displayName;

  static ContactRelationship fromString(String value) {
    return ContactRelationship.values.firstWhere(
      (e) => e.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => ContactRelationship.other,
    );
  }
}
