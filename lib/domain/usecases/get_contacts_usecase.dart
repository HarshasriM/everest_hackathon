import '../entities/contact.dart';
import '../repositories/contacts_repository.dart';

class GetContactsUseCase {
  final ContactsRepository _repository;

  GetContactsUseCase(this._repository);

  Future<List<Contact>> call() async {
    final contacts = await _repository.getContacts();
    
    // Sort contacts: primary first, then by name
    contacts.sort((a, b) {
      if (a.isPrimary && !b.isPrimary) return -1;
      if (!a.isPrimary && b.isPrimary) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    return contacts;
  }

  Stream<List<Contact>> watchContacts() {
    return _repository.watchContacts().map((contacts) {
      // Sort contacts: primary first, then by name
      contacts.sort((a, b) {
        if (a.isPrimary && !b.isPrimary) return -1;
        if (!a.isPrimary && b.isPrimary) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      return contacts;
    });
  }
}
