/// Validation utilities for form inputs
class Validators {
  // Phone number validation (Indian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove any non-digit characters
    final cleanedNumber = value.replaceAll(RegExp(r'\D'), '');
    
    // Check if it's a valid Indian phone number (10 digits)
    if (cleanedNumber.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    // Check if it starts with a valid Indian mobile prefix (6-9)
    if (!RegExp(r'^[6-9]').hasMatch(cleanedNumber)) {
      return 'Please enter a valid Indian mobile number';
    }
    
    return null;
  }

  // OTP validation
  static String? validateOTP(String? value, {int otpLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != otpLength) {
      return 'Please enter a $otpLength-digit OTP';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }

  // Email validation (optional field)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  // Emergency contact name validation
  static String? validateContactName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }

  // Relationship validation
  static String? validateRelationship(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a relationship';
    }
    
    final validRelationships = [
      'Parent',
      'Spouse',
      'Sibling',
      'Friend',
      'Relative',
      'Guardian',
      'Other'
    ];
    
    if (!validRelationships.contains(value)) {
      return 'Please select a valid relationship';
    }
    
    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }
    
    if (value.length < 10) {
      return 'Please enter a complete address';
    }
    
    if (value.length > 200) {
      return 'Address is too long';
    }
    
    return null;
  }

  // Feedback message validation
  static String? validateFeedback(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your feedback';
    }
    
    if (value.length < 10) {
      return 'Feedback must be at least 10 characters';
    }
    
    if (value.length > 1000) {
      return 'Feedback must be less than 1000 characters';
    }
    
    return null;
  }

  // Generic required field validation
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Password validation (for future use)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }
}
