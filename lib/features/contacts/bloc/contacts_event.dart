part of 'contacts_bloc.dart';

abstract class ContactsEvent {
  const ContactsEvent();
}

class LoadContactsEvent extends ContactsEvent {
  const LoadContactsEvent();
}

class AddContactEvent extends ContactsEvent {
  final Contact contact;
  const AddContactEvent(this.contact);
}

class UpdateContactEvent extends ContactsEvent {
  final Contact contact;
  const UpdateContactEvent(this.contact);
}

class DeleteContactEvent extends ContactsEvent {
  final String contactId;
  const DeleteContactEvent(this.contactId);
}

class SearchContactsEvent extends ContactsEvent {
  final String query;
  const SearchContactsEvent(this.query);
}

class WatchContactsEvent extends ContactsEvent {
  const WatchContactsEvent();
}
