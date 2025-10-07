import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/get_contacts_usecase.dart';
import '../../domain/repositories/contacts_repository.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetContactsUseCase _getContactsUseCase;
  final AddContactUseCase _addContactUseCase;
  final ContactsRepository _repository;

  StreamSubscription<List<Contact>>? _contactsSubscription;

  ContactsBloc({
    required GetContactsUseCase getContactsUseCase,
    required AddContactUseCase addContactUseCase,
    required ContactsRepository repository,
  }) : _getContactsUseCase = getContactsUseCase,
       _addContactUseCase = addContactUseCase,
       _repository = repository,
       super(const ContactsInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<UpdateContactEvent>(_onUpdateContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<SearchContactsEvent>(_onSearchContacts);
    on<WatchContactsEvent>(_onWatchContacts);
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
      emit(const ContactsLoading());
      await _addContactUseCase(event.contact);
      final contacts = await _getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _onUpdateContact(
    UpdateContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      emit(const ContactsLoading());
      await _repository.updateContact(event.contact);
      final contacts = await _getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  Future<void> _onDeleteContact(
    DeleteContactEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      emit(const ContactsLoading());
      await _repository.deleteContact(event.contactId);
      final contacts = await _getContactsUseCase();
      emit(ContactsLoaded(contacts));
    } catch (e) {
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

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}
