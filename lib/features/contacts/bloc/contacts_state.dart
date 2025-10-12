part of 'contacts_bloc.dart';

abstract class ContactsState {
  const ContactsState();
}

class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

class ContactsLoaded extends ContactsState {
  final List<Contact> contacts;
  const ContactsLoaded(this.contacts);
}

class ContactsError extends ContactsState {
  final String message;
  const ContactsError(this.message);
}

class PhoneContactsLoading extends ContactsState {
  const PhoneContactsLoading();
}

class PhoneContactsLoaded extends ContactsState {
  final List<flutter_contacts.Contact> phoneContacts;
  const PhoneContactsLoaded(this.phoneContacts);
}

class PhoneContactsError extends ContactsState {
  final String message;
  const PhoneContactsError(this.message);
}
