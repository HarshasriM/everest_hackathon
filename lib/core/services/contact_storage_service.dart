import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/contact.dart';
import '../utils/logger.dart';

/// Service for managing emergency contacts persistence
/// Uses flutter_secure_storage to store contacts locally
class ContactStorageService {
  static final ContactStorageService _instance = ContactStorageService._internal();
  factory ContactStorageService() => _instance;
  ContactStorageService._internal();

  // Storage instance
  late FlutterSecureStorage _secureStorage;
  bool _initialized = false;

  // Storage key for emergency contacts
  static const String _keyEmergencyContacts = 'emergency_contacts';

  /// Initialize the storage service
  Future<void> init() async {
    if (_initialized) return;

    try {
      _secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

      // Test storage functionality
      try {
        await _secureStorage.write(key: 'test_contact_storage', value: 'test');
        final testValue = await _secureStorage.read(key: 'test_contact_storage');
        await _secureStorage.delete(key: 'test_contact_storage');

        if (testValue != 'test') {
          throw Exception('Contact storage validation failed');
        }
      } catch (e) {
        Logger.error('Contact storage validation failed', error: e);
        throw e;
      }

      _initialized = true;
      Logger.info('ContactStorageService initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize ContactStorageService', error: e);
      // Fallback to basic secure storage
      try {
        _secureStorage = const FlutterSecureStorage();
        _initialized = true;
        Logger.info('ContactStorageService initialized with fallback storage');
      } catch (e) {
        Logger.error('Failed to initialize fallback contact storage', error: e);
        rethrow;
      }
    }
  }

  /// Ensure the service is initialized
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  /// Save emergency contacts to local storage
  Future<void> saveContacts(List<Contact> contacts) async {
    try {
      await _ensureInitialized();
      
      // Convert contacts to JSON
      final contactsJson = contacts.map((contact) => contact.toJson()).toList();
      final jsonString = jsonEncode(contactsJson);
      
      // Save to secure storage
      await _secureStorage.write(key: _keyEmergencyContacts, value: jsonString);
      
      Logger.info('Successfully saved ${contacts.length} emergency contacts');
    } catch (e) {
      Logger.error('Failed to save emergency contacts', error: e);
      rethrow;
    }
  }

  /// Load emergency contacts from local storage
  Future<List<Contact>> loadContacts() async {
    try {
      await _ensureInitialized();
      
      // Read from secure storage
      final jsonString = await _secureStorage.read(key: _keyEmergencyContacts);
      
      if (jsonString == null || jsonString.isEmpty) {
        Logger.info('No emergency contacts found in storage');
        return [];
      }
      
      // Parse JSON and convert to Contact objects
      final List<dynamic> contactsJson = jsonDecode(jsonString);
      final contacts = contactsJson
          .map((json) => Contact.fromJson(json as Map<String, dynamic>))
          .toList();
      
      Logger.info('Successfully loaded ${contacts.length} emergency contacts');
      return contacts;
    } catch (e) {
      Logger.error('Failed to load emergency contacts', error: e);
      // If data is corrupted, clear it and return empty list
      await clearContacts();
      return [];
    }
  }

  /// Add a single contact to storage
  Future<void> addContact(Contact contact) async {
    try {
      final existingContacts = await loadContacts();
      
      // Check for duplicates by phone number
      final cleanPhone = contact.phone.replaceAll(RegExp(r'[^\d]'), '');
      final isDuplicate = existingContacts.any((c) => 
          c.phone.replaceAll(RegExp(r'[^\d]'), '') == cleanPhone);
      
      if (isDuplicate) {
        throw Exception('Contact with this phone number already exists');
      }
      
      existingContacts.add(contact);
      await saveContacts(existingContacts);
      
      Logger.info('Successfully added contact: ${contact.name}');
    } catch (e) {
      Logger.error('Failed to add contact', error: e);
      rethrow;
    }
  }

  /// Update an existing contact in storage
  Future<void> updateContact(Contact contact) async {
    try {
      final existingContacts = await loadContacts();
      final index = existingContacts.indexWhere((c) => c.id == contact.id);
      
      if (index == -1) {
        throw Exception('Contact not found');
      }
      
      existingContacts[index] = contact;
      await saveContacts(existingContacts);
      
      Logger.info('Successfully updated contact: ${contact.name}');
    } catch (e) {
      Logger.error('Failed to update contact', error: e);
      rethrow;
    }
  }

  /// Remove a contact from storage
  Future<void> removeContact(String contactId) async {
    try {
      final existingContacts = await loadContacts();
      final initialLength = existingContacts.length;
      
      existingContacts.removeWhere((c) => c.id == contactId);
      
      if (existingContacts.length == initialLength) {
        throw Exception('Contact not found');
      }
      
      await saveContacts(existingContacts);
      
      Logger.info('Successfully removed contact with ID: $contactId');
    } catch (e) {
      Logger.error('Failed to remove contact', error: e);
      rethrow;
    }
  }

  /// Clear all emergency contacts from storage
  Future<void> clearContacts() async {
    try {
      await _ensureInitialized();
      await _secureStorage.delete(key: _keyEmergencyContacts);
      Logger.info('Successfully cleared all emergency contacts');
    } catch (e) {
      Logger.error('Failed to clear emergency contacts', error: e);
      rethrow;
    }
  }

  /// Get the count of stored contacts
  Future<int> getContactCount() async {
    try {
      final contacts = await loadContacts();
      return contacts.length;
    } catch (e) {
      Logger.error('Failed to get contact count', error: e);
      return 0;
    }
  }

  /// Check if a contact with the given phone number exists
  Future<bool> contactExists(String phoneNumber) async {
    try {
      final contacts = await loadContacts();
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      return contacts.any((c) => 
          c.phone.replaceAll(RegExp(r'[^\d]'), '') == cleanPhone);
    } catch (e) {
      Logger.error('Failed to check if contact exists', error: e);
      return false;
    }
  }
}
