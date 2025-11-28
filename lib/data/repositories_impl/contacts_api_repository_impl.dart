import 'dart:async';
import '../../core/services/app_preferences_service.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/remote/emergency_contacts_api_service.dart';

/// API-based implementation of ContactsRepository
class ContactsApiRepositoryImpl implements ContactsRepository {
  final EmergencyContactsApiService _apiService;
  final AppPreferencesService _preferencesService;

  // In-memory cache for quick access
  List<Contact> _contacts = [];
  final StreamController<List<Contact>> _contactsController =
      StreamController<List<Contact>>.broadcast();

  ContactsApiRepositoryImpl({
    required EmergencyContactsApiService apiService,
    required AppPreferencesService preferencesService,
  }) : _apiService = apiService,
       _preferencesService = preferencesService;

  void _notifyListeners() {
    _contactsController.add(List.from(_contacts));
  }

  /// Get current user ID from preferences
  Future<String> _getCurrentUserId() async {
    final userId = await _preferencesService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  @override
  Future<List<Contact>> getContacts() async {
    try {
      Logger.info('Fetching emergency contacts from API');
      final userId = await _getCurrentUserId();

      final apiContacts = await _apiService.getEmergencyContacts(userId);
      _contacts = apiContacts
          .map((apiContact) => apiContact.toEntity())
          .toList();

      Logger.info('Successfully fetched ${_contacts.length} contacts from API');
      _notifyListeners();
      return List.from(_contacts);
    } catch (e) {
      Logger.error('Failed to fetch contacts from API', error: e);
      rethrow;
    }
  }

  /// Get cached contacts without making API call
  List<Contact> getCachedContacts() {
    return List.from(_contacts);
  }

  @override
  Future<Contact> addContact(Contact contact) async {
    try {
      Logger.info('Adding contact via API: ${contact.name}');
      final userId = await _getCurrentUserId();

      final apiContact = await _apiService.addEmergencyContact(
        userId: userId,
        name: contact.name,
        phoneNumber: contact.phone,
        relationship: contact.relationship,
      );

      final newContact = apiContact.toEntity();

      // Add to local cache immediately for instant UI update
      _contacts.add(newContact);
      _notifyListeners();

      Logger.info('Successfully added contact: ${newContact.name}');
      return newContact;
    } catch (e) {
      Logger.error('Failed to add contact via API', error: e);
      rethrow;
    }
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    try {
      Logger.info(
        'Updating contact via API - id: "${contact.id}", name: "${contact.name}"',
      );
      if (contact.id.isEmpty) {
        throw Exception('Cannot update contact: Contact ID is empty');
      }
      final userId = await _getCurrentUserId();

      final apiContact = await _apiService.updateEmergencyContact(
        userId: userId,
        contactId: contact.id,
        name: contact.name,
        phoneNumber: contact.phone,
        relationship: contact.relationship,
      );

      final updatedContact = apiContact.toEntity().copyWith(
        id: contact.id, // Preserve the original ID
        isPrimary: contact.isPrimary,
        canReceiveSOS: contact.canReceiveSOS,
        email: contact.email,
        createdAt: contact.createdAt,
        updatedAt: DateTime.now(),
      );

      final index = _contacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _contacts[index] = updatedContact;
        _notifyListeners();
      }

      Logger.info('Successfully updated contact: ${updatedContact.name}');
      return updatedContact;
    } catch (e) {
      Logger.error('Failed to update contact via API', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteContact(String contactId) async {
    try {
      Logger.info('Deleting contact via API - contactId: "$contactId"');
      if (contactId.isEmpty) {
        throw Exception('Cannot delete contact: Contact ID is empty');
      }
      final userId = await _getCurrentUserId();

      await _apiService.deleteEmergencyContact(
        userId: userId,
        contactId: contactId,
      );

      _contacts.removeWhere((c) => c.id == contactId);
      _notifyListeners();

      Logger.info('Successfully deleted contact: $contactId');
    } catch (e) {
      Logger.error('Failed to delete contact via API', error: e);
      rethrow;
    }
  }

  @override
  Future<List<Contact>> searchContacts(String query) async {
    // For API-based search, we'll filter locally for now
    // In a production app, you might want to implement server-side search
    await Future.delayed(const Duration(milliseconds: 200));

    if (query.isEmpty) return List.from(_contacts);

    final lowercaseQuery = query.toLowerCase();
    final filteredContacts = _contacts.where((contact) {
      return contact.name.toLowerCase().contains(lowercaseQuery) ||
          contact.phone.contains(query) ||
          contact.relationship.toLowerCase().contains(lowercaseQuery);
    }).toList();

    return filteredContacts;
  }

  @override
  Future<List<Contact>> getPrimaryContacts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _contacts.where((c) => c.isPrimary).toList();
  }

  @override
  Future<void> setPrimaryContact(String contactId, bool isPrimary) async {
    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index == -1) {
      throw Exception('Contact not found');
    }

    final updatedContact = _contacts[index].copyWith(
      isPrimary: isPrimary,
      updatedAt: DateTime.now(),
    );

    // Update via API
    await updateContact(updatedContact);
  }

  @override
  Stream<List<Contact>> watchContacts() {
    // Emit current data immediately when someone subscribes
    Future.microtask(() => _notifyListeners());
    return _contactsController.stream;
  }

  void dispose() {
    _contactsController.close();
  }
}
