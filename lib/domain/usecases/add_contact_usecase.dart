import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class AddContactUseCase {
  final ContactsRepository _repository;

  AddContactUseCase(this._repository);

  Future<Contact> call(Contact contact) async {
    // Validate contact
    if (!contact.isValid) {
      throw Exception('Invalid contact data');
    }

    // Check for duplicate phone numbers
    final existingContacts = await _repository.getContacts();
    final duplicatePhone = existingContacts.any(
      (c) => c.phone.replaceAll(RegExp(r'[^\d]'), '') == 
             contact.phone.replaceAll(RegExp(r'[^\d]'), ''),
    );

    if (duplicatePhone) {
      throw Exception('Contact with this phone number already exists');
    }

    // Add timestamps
    final contactToAdd = contact.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _repository.addContact(contactToAdd);
  }
}
