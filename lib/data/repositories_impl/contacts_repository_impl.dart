import 'dart:async';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../../core/services/contact_storage_service.dart';
import '../../core/utils/logger.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  // Local storage service for persistence
  final ContactStorageService _storageService = ContactStorageService();

  // In-memory cache for quick access
  List<Contact> _contacts = [];
  final StreamController<List<Contact>> _contactsController =
      StreamController<List<Contact>>.broadcast();

  bool _initialized = false;

  ContactsRepositoryImpl() {
    _initializeRepository();
  }

  /// Initialize the repository by loading contacts from storage
  Future<void> _initializeRepository() async {
    if (_initialized) return;

    try {
      await _storageService.init();
      _contacts = await _storageService.loadContacts();
      _initialized = true;
      _notifyListeners();
      Logger.info(
        'ContactsRepository initialized with ${_contacts.length} contacts',
      );
    } catch (e) {
      Logger.error('Failed to initialize ContactsRepository', error: e);
      _contacts = [];
      _initialized = true;
      _notifyListeners();
    }
  }

  /// Ensure the repository is initialized
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _initializeRepository();
    }
  }

  void _notifyListeners() {
    _contactsController.add(List.from(_contacts));
  }

  @override
  Future<List<Contact>> getContacts() async {
    await _ensureInitialized();
    // Simulate network delay for consistency
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_contacts);
  }

  @override
  Future<Contact> addContact(Contact contact) async {
    await _ensureInitialized();

    final newContact = contact.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add to storage first
    await _storageService.addContact(newContact);

    // Update in-memory cache
    _contacts.add(newContact);
    _notifyListeners();

    return newContact;
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    await _ensureInitialized();

    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index == -1) {
      throw Exception('Contact not found');
    }

    final updatedContact = contact.copyWith(updatedAt: DateTime.now());

    // Update in storage first
    await _storageService.updateContact(updatedContact);

    // Update in-memory cache
    _contacts[index] = updatedContact;
    _notifyListeners();

    return updatedContact;
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await _ensureInitialized();

    // Remove from storage first
    await _storageService.removeContact(contactId);

    // Remove from in-memory cache
    _contacts.removeWhere((c) => c.id == contactId);
    _notifyListeners();
  }

  @override
  Future<List<Contact>> searchContacts(String query) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 200));

    if (query.isEmpty) return List.from(_contacts);

    final lowercaseQuery = query.toLowerCase();
    return _contacts.where((contact) {
      return contact.name.toLowerCase().contains(lowercaseQuery) ||
          contact.phone.contains(query) ||
          contact.relationship.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<Contact>> getPrimaryContacts() async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 200));
    return _contacts.where((c) => c.isPrimary).toList();
  }

  @override
  Future<void> setPrimaryContact(String contactId, bool isPrimary) async {
    await _ensureInitialized();

    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index == -1) {
      throw Exception('Contact not found');
    }

    final updatedContact = _contacts[index].copyWith(
      isPrimary: isPrimary,
      updatedAt: DateTime.now(),
    );

    // Update in storage first
    await _storageService.updateContact(updatedContact);

    // Update in-memory cache
    _contacts[index] = updatedContact;
    _notifyListeners();
  }

  @override
  Stream<List<Contact>> watchContacts() {
    // Ensure initialization and emit current data immediately when someone subscribes
    _ensureInitialized().then((_) => _notifyListeners());
    return _contactsController.stream;
  }

  void dispose() {
    _contactsController.close();
  }
}
