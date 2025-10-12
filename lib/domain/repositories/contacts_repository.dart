import '../entities/contact.dart';

abstract class ContactsRepository {
  Future<List<Contact>> getContacts();
  Future<Contact> addContact(Contact contact);
  Future<Contact> updateContact(Contact contact);
  Future<void> deleteContact(String contactId);
  Future<List<Contact>> searchContacts(String query);
  Future<List<Contact>> getPrimaryContacts();
  Future<void> setPrimaryContact(String contactId, bool isPrimary);
  Stream<List<Contact>> watchContacts();
}
