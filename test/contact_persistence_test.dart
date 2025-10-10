import 'package:flutter_test/flutter_test.dart';
import 'package:everest_hackathon/core/services/contact_storage_service.dart';
import 'package:everest_hackathon/domain/entities/contact.dart';

void main() {
  // Initialize Flutter bindings for testing
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Contact Persistence Tests', () {
    late ContactStorageService storageService;

    setUp(() async {
      storageService = ContactStorageService();
      try {
        // Clear any existing data before each test
        await storageService.clearContacts();
      } catch (e) {
        // Ignore errors during setup cleanup
      }
    });

    tearDown(() async {
      try {
        // Clean up after each test
        await storageService.clearContacts();
      } catch (e) {
        // Ignore errors during cleanup
      }
    });

    test('should save and load contacts correctly', () async {
      // Arrange
      final testContact = Contact(
        id: '1',
        name: 'Test Contact',
        phone: '1234567890',
        relationship: 'Family',
        isPrimary: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act - Save contact
      await storageService.addContact(testContact);

      // Act - Load contacts
      final loadedContacts = await storageService.loadContacts();

      // Assert
      expect(loadedContacts.length, 1);
      expect(loadedContacts.first.name, testContact.name);
      expect(loadedContacts.first.phone, testContact.phone);
      expect(loadedContacts.first.relationship, testContact.relationship);
      expect(loadedContacts.first.isPrimary, testContact.isPrimary);
    });

    test('should handle multiple contacts', () async {
      // Arrange
      final contacts = [
        Contact(
          id: '1',
          name: 'Contact 1',
          phone: '1111111111',
          relationship: 'Family',
          isPrimary: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Contact(
          id: '2',
          name: 'Contact 2',
          phone: '2222222222',
          relationship: 'Friend',
          isPrimary: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // Act - Save contacts
      for (final contact in contacts) {
        await storageService.addContact(contact);
      }

      // Act - Load contacts
      final loadedContacts = await storageService.loadContacts();

      // Assert
      expect(loadedContacts.length, 2);
      expect(loadedContacts.map((c) => c.name).toList(), [
        'Contact 1',
        'Contact 2',
      ]);
    });

    test('should update contact correctly', () async {
      // Arrange
      final originalContact = Contact(
        id: '1',
        name: 'Original Name',
        phone: '1234567890',
        relationship: 'Family',
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await storageService.addContact(originalContact);

      // Act - Update contact
      final updatedContact = originalContact.copyWith(
        name: 'Updated Name',
        isPrimary: true,
        updatedAt: DateTime.now(),
      );

      await storageService.updateContact(updatedContact);

      // Act - Load contacts
      final loadedContacts = await storageService.loadContacts();

      // Assert
      expect(loadedContacts.length, 1);
      expect(loadedContacts.first.name, 'Updated Name');
      expect(loadedContacts.first.isPrimary, true);
    });

    test('should remove contact correctly', () async {
      // Arrange
      final contact = Contact(
        id: '1',
        name: 'Test Contact',
        phone: '1234567890',
        relationship: 'Family',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await storageService.addContact(contact);

      // Verify contact was added
      var loadedContacts = await storageService.loadContacts();
      expect(loadedContacts.length, 1);

      // Act - Remove contact
      await storageService.removeContact(contact.id);

      // Act - Load contacts
      loadedContacts = await storageService.loadContacts();

      // Assert
      expect(loadedContacts.length, 0);
    });

    test('should prevent duplicate phone numbers', () async {
      // Arrange
      final contact1 = Contact(
        id: '1',
        name: 'Contact 1',
        phone: '1234567890',
        relationship: 'Family',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final contact2 = Contact(
        id: '2',
        name: 'Contact 2',
        phone: '1234567890', // Same phone number
        relationship: 'Friend',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act & Assert
      await storageService.addContact(contact1);

      expect(
        () async => await storageService.addContact(contact2),
        throwsA(isA<Exception>()),
      );
    });

    test('should return empty list when no contacts exist', () async {
      // Act
      final loadedContacts = await storageService.loadContacts();

      // Assert
      expect(loadedContacts, isEmpty);
    });

    test('should get correct contact count', () async {
      // Arrange
      final contact = Contact(
        id: '1',
        name: 'Test Contact',
        phone: '1234567890',
        relationship: 'Family',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act & Assert - Initially empty
      expect(await storageService.getContactCount(), 0);

      // Act & Assert - After adding contact
      await storageService.addContact(contact);
      expect(await storageService.getContactCount(), 1);
    });

    test('should check if contact exists by phone number', () async {
      // Arrange
      final contact = Contact(
        id: '1',
        name: 'Test Contact',
        phone: '1234567890',
        relationship: 'Family',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act & Assert - Initially doesn't exist
      expect(await storageService.contactExists('1234567890'), false);

      // Act & Assert - After adding contact
      await storageService.addContact(contact);
      expect(await storageService.contactExists('1234567890'), true);
      expect(await storageService.contactExists('0987654321'), false);
    });
  });
}
