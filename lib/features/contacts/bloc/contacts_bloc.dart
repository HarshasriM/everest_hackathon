import 'dart:async';
import 'package:everest_hackathon/data/repositories_impl/contacts_api_repository_impl.dart';
import 'package:everest_hackathon/domain/entities/contact.dart';
import 'package:everest_hackathon/domain/repositories/contacts_repository.dart';
import 'package:everest_hackathon/domain/usecases/add_contact_usecase.dart';
import 'package:everest_hackathon/domain/usecases/get_contacts_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;

import '../../../core/utils/logger.dart';
import '../services/phone_contacts_service.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  final AddContactUseCase _addContactUseCase;
  final ContactsRepository _repository;
  final PhoneContactsService _phoneContactsService;

  StreamSubscription<List<Contact>>? _contactsSubscription;

  ContactsBloc({
    required GetContactsUseCase getContactsUseCase,
    required AddContactUseCase addContactUseCase,
    required ContactsRepository repository,
    PhoneContactsService? phoneContactsService,
  }) : _getContactsUseCase = getContactsUseCase,
       _addContactUseCase = addContactUseCase,
       _repository = repository,
       _phoneContactsService =
           phoneContactsService ?? PhoneContactsService.instance,
       super(const ContactsInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<SearchContactsEvent>(_onSearchContacts);
    on<WatchContactsEvent>(_onWatchContacts);
    on<LoadPhoneContactsEvent>(_onLoadPhoneContacts);
    on<SearchPhoneContactsEvent>(_onSearchPhoneContacts);
    on<AddContactFromPhoneEvent>(_onAddContactFromPhone);
  }

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    print('[ContactsBloc] Loading contacts...');
    emit(const ContactsLoading());
    try {
      final contacts = await _getContactsUseCase();
      print('[ContactsBloc] Loaded ${contacts.length} contacts');
      emit(ContactsLoaded(contacts));
    } catch (e) {
      print('[ContactsBloc] Error loading contacts: $e');
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      Logger.info('Adding contact in BLoC: ${event.contact.name}');

      // Add the contact via use case (repository will update cache and notify)
      final addedContact = await _addContactUseCase(event.contact);

      // Repository has updated cache, so get cached contacts without API call
      final contacts = (_repository as ContactsApiRepositoryImpl)
          .getCachedContacts();
      emit(ContactsLoaded(contacts));

      Logger.info('Contact added successfully in BLoC: ${addedContact.name}');
    } catch (e) {
      Logger.error('Failed to add contact in BLoC', error: e);
      emit(ContactsError('Failed to add contact: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateContact(
    UpdateContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      Logger.info(
        'Update contact event - contactId: "${event.contact.id}", name: "${event.contact.name}"',
      );
      if (event.contact.id.isEmpty) {
        throw Exception(
          'Cannot update contact: Contact ID is empty or invalid',
        );
      }
      emit(const ContactsLoading());
      await _repository.updateContact(event.contact);
      final contacts = await _getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      Logger.error('Failed to update contact', error: e);
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _onDeleteContact(
    DeleteContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      Logger.info('Delete contact event - contactId: ${event.contactId}');
      if (event.contactId.isEmpty) {
        throw Exception(
          'Cannot delete contact: Contact ID is empty or invalid',
        );
      }
      emit(const ContactsLoading());
      await _repository.deleteContact(event.contactId);
      final contacts = await _getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      Logger.error('Failed to delete contact', error: e);
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _onSearchContacts(
    SearchContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      emit(const ContactsLoading());
      final contacts = await _repository.searchContacts(event.query);
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _onWatchContacts(
    WatchContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    await _contactsSubscription?.cancel();
    _contactsSubscription = _repository.watchContacts().listen(
      (contacts) => emit(ContactsLoaded(contacts)),
      onError: (error) => emit(ContactsError(error.toString())),
    );
  }

  Future<void> _onLoadPhoneContacts(
    LoadPhoneContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const PhoneContactsLoading());
    try {
      final phoneContacts = await _phoneContactsService.getPhoneContacts();
      emit(PhoneContactsLoaded(phoneContacts));
    } catch (e) {
      emit(PhoneContactsError(e.toString()));
    }
  }

  Future<void> _onSearchPhoneContacts(
    SearchPhoneContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const PhoneContactsLoading());
    try {
      final phoneContacts = await _phoneContactsService.searchPhoneContacts(
        event.query,
      );
      emit(PhoneContactsLoaded(phoneContacts));
    } catch (e) {
      emit(PhoneContactsError(e.toString()));
    }
  }

  Future<void> _onAddContactFromPhone(
    AddContactFromPhoneEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      final contact = Contact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        phone: event.phone,
        relationship: event.relationship,
        isPrimary: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _addContactUseCase(contact);
      // Reload contacts to show the new one
      add(const LoadContactsEvent());
    } catch (e) {
      emit(ContactsError('Failed to add contact: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}
