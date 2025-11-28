class ProfileUpdateRequest {
  final String name;
  final String? email;

  const ProfileUpdateRequest({
    required this.name,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
    };
    
    if (email != null && email!.isNotEmpty) {
      json['email'] = email;
    }
    
    return json;
  }

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateRequest(
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
    );
  }

  bool get isValid => name.trim().isNotEmpty;
  
  String? get nameError {
    if (name.trim().isEmpty) {
      return 'Name is required';
    }
    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  
  String? get emailError {
    if (email != null && email!.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email!)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileUpdateRequest &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(name, email);

  @override
  String toString() => 'ProfileUpdateRequest(name: $name, email: $email)';
}
