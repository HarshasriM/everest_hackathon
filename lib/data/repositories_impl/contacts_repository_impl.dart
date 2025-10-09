import 'dart:async';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  // In-memory storage for now (can be replaced with local database later)
  final List<Contact> _contacts = [];
  final StreamController<List<Contact>> _contactsController =
      StreamController<List<Contact>>.broadcast();

  ContactsRepositoryImpl() {
    // Initialize with some sample data for testing
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Add some sample contacts for testing
    // _contacts.addAll([
      // Contact(
      //   id: '1',
      //   name: 'Emergency Contact 1',
      //   phone: '9876543210',
      //   relationship: 'Family',
      //   isPrimary: true,
      //   createdAt: DateTime.now().subtract(const Duration(days: 1)),
      //   updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      // ),
      // Contact(
      //   id: '2',
      //   name: 'Emergency Contact 2',
      //   phone: '9876543211',
      //   relationship: 'Friend',
      //   isPrimary: false,
      //   createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      //   updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      // ),
    // ]);
    _notifyListeners();
  }

  void _notifyListeners() {
    _contactsController.add(List.from(_contacts));
  }

  @override
  Future<List<Contact>> getContacts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_contacts);
  }

  @override
  Future<Contact> addContact(Contact contact) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final newContact = contact.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    _contacts.add(newContact);
    _notifyListeners();
    return newContact;
  }

  @override
  Future<Contact> updateContact(Contact contact) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index == -1) {
      throw Exception('Contact not found');
    }

    final updatedContact = contact.copyWith(updatedAt: DateTime.now());
    _contacts[index] = updatedContact;
    _notifyListeners();
    return updatedContact;
  }

  @override
  Future<void> deleteContact(String contactId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    _contacts.removeWhere((c) => c.id == contactId);
    _notifyListeners();
  }

  @override
  Future<List<Contact>> searchContacts(String query) async {
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
    await Future.delayed(const Duration(milliseconds: 200));
    return _contacts.where((c) => c.isPrimary).toList();
  }

  @override
  Future<void> setPrimaryContact(String contactId, bool isPrimary) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index == -1) {
      throw Exception('Contact not found');
    }

    _contacts[index] = _contacts[index].copyWith(
      isPrimary: isPrimary,
      updatedAt: DateTime.now(),
    );
    _notifyListeners();
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
