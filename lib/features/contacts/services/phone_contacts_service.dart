import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle phone contacts access and operations
class PhoneContactsService {
  static PhoneContactsService? _instance;
  
  PhoneContactsService._();
  
  static PhoneContactsService get instance {
    _instance ??= PhoneContactsService._();
    return _instance!;
  }

  /// Check if contacts permission is granted
  Future<bool> hasContactsPermission() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  /// Request contacts permission
  Future<bool> requestContactsPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// Get all phone contacts with proper error handling
  Future<List<Contact>> getPhoneContacts() async {
    try {
      // Check permission first
      if (!await hasContactsPermission()) {
        final granted = await requestContactsPermission();
        if (!granted) {
          throw ContactsPermissionException('Contacts permission denied');
        }
      }

      // Fetch contacts with phone numbers only
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      // Filter contacts that have phone numbers
      final contactsWithPhones = contacts.where((contact) {
        return contact.phones.isNotEmpty && 
               contact.displayName.isNotEmpty;
      }).toList();

      // Sort by display name
      contactsWithPhones.sort((a, b) => 
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

      return contactsWithPhones;
    } catch (e) {
      if (e is ContactsPermissionException) {
        rethrow;
      }
      throw ContactsAccessException('Failed to access phone contacts: $e');
    }
  }

  /// Search phone contacts by name or phone number
  Future<List<Contact>> searchPhoneContacts(String query) async {
    if (query.trim().isEmpty) {
      return await getPhoneContacts();
    }

    try {
      final allContacts = await getPhoneContacts();
      final lowercaseQuery = query.toLowerCase();

      return allContacts.where((contact) {
        // Search in display name
        final nameMatch = contact.displayName.toLowerCase().contains(lowercaseQuery);
        
        // Search in phone numbers
        final phoneMatch = contact.phones.any((phone) => 
          phone.number.replaceAll(RegExp(r'[^\d]'), '').contains(
            query.replaceAll(RegExp(r'[^\d]'), '')
          )
        );

        return nameMatch || phoneMatch;
      }).toList();
    } catch (e) {
      throw ContactsAccessException('Failed to search phone contacts: $e');
    }
  }

  /// Convert flutter_contacts Contact to app Contact entity
  String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters except +
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it starts with +91, remove it for Indian numbers
    if (cleaned.startsWith('+91')) {
      cleaned = cleaned.substring(3);
    }
    
    // Ensure it's 10 digits for Indian numbers
    if (cleaned.length == 10) {
      return cleaned;
    }
    
    // If it's 11 digits and starts with 0, remove the 0
    if (cleaned.length == 11 && cleaned.startsWith('0')) {
      return cleaned.substring(1);
    }
    
    return cleaned;
  }

  /// Get the primary phone number from a contact
  String getPrimaryPhoneNumber(Contact contact) {
    if (contact.phones.isEmpty) return '';
    
    // Prefer mobile numbers
    final mobilePhone = contact.phones.firstWhere(
      (phone) => phone.label == PhoneLabel.mobile,
      orElse: () => contact.phones.first,
    );
    
    return formatPhoneNumber(mobilePhone.number);
  }

  /// Check if the app has contacts permission and show appropriate message
  Future<ContactsPermissionStatus> checkPermissionStatus() async {
    final status = await Permission.contacts.status;
    
    switch (status) {
      case PermissionStatus.granted:
        return ContactsPermissionStatus.granted;
      case PermissionStatus.denied:
        return ContactsPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return ContactsPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return ContactsPermissionStatus.restricted;
      default:
        return ContactsPermissionStatus.denied;
    }
  }
}

/// Permission status enum
enum ContactsPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
}

/// Custom exceptions for contacts service
class ContactsPermissionException implements Exception {
  final String message;
  ContactsPermissionException(this.message);
  
  @override
  String toString() => 'ContactsPermissionException: $message';
}

class ContactsAccessException implements Exception {
  final String message;
  ContactsAccessException(this.message);
  
  @override
  String toString() => 'ContactsAccessException: $message';
}
