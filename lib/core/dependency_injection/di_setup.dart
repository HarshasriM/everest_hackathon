import 'package:everest_hackathon/data/repositories_impl/contacts_repository_impl.dart';
import 'package:everest_hackathon/domain/repositories/contacts_repository.dart';
import 'package:everest_hackathon/domain/usecases/add_contact_usecase.dart';
import 'package:everest_hackathon/domain/usecases/get_contacts_usecase.dart';
import 'package:everest_hackathon/features/contacts/bloc/contacts_bloc.dart';
import 'package:everest_hackathon/features/track/bloc/track_bloc.dart';

// SOS imports
import '../../data/datasources/remote/sos_remote_source.dart';
import '../../data/repositories_impl/sos_repository_impl.dart';
import '../../domain/usecases/sos/send_sos_alert_usecase.dart';
import '../../features/sos/bloc/sos_bloc.dart';

import '../../core/network/api_client.dart';
import '../../core/services/app_preferences_service.dart';
import '../../core/services/contact_storage_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/location_sharing_service.dart';
import '../../data/datasources/remote/auth_remote_source.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../features/auth/bloc/auth_bloc.dart';

import '../../features/fake_call/bloc/fake_call_bloc.dart';

import 'di_container.dart';

/// Setup dependency injection
Future<void> setupDependencyInjection() async {
  // Core
  await _registerCore();

  // Data Sources
  _registerDataSources();

  // Repositories
  _registerRepositories();

  // Use Cases
  _registerUseCases();

  // BLoCs
  _registerBlocs();
}

/// Register core dependencies
Future<void> _registerCore() async {
  // API Client
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // App Preferences
  final appPreferences = AppPreferencesService();
  await appPreferences.init();
  sl.registerLazySingleton<AppPreferencesService>(() => appPreferences);

  // Contact Storage Service
  final contactStorage = ContactStorageService();
  await contactStorage.init();
  sl.registerLazySingleton<ContactStorageService>(() => contactStorage);

  // Location Service
  sl.registerLazySingleton<LocationService>(() => LocationService());

  // Location Sharing Service
  sl.registerLazySingleton<LocationSharingService>(
    () => LocationSharingService(),
  );
}

/// Register data sources
void _registerDataSources() {
  // Auth Remote Data Source
  sl.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()));
  
  // SOS Remote Data Source
  sl.registerLazySingleton<SosRemoteSource>(() => SosRemoteSourceImpl(sl()));
}

/// Register repositories
void _registerRepositories() {
  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteSource: sl(), preferencesService: sl()),
  );

  // Contacts Repository
  sl.registerLazySingleton<ContactsRepository>(() => ContactsRepositoryImpl());

  // SOS Repository
  sl.registerLazySingleton<SosRepositoryImpl>(() => SosRepositoryImpl(sl()));
}

/// Register use cases
void _registerUseCases() {
  // Auth Use Cases
  sl.registerLazySingleton<SendOtpUseCase>(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));

  // Contacts Use Cases
  sl.registerLazySingleton<GetContactsUseCase>(() => GetContactsUseCase(sl()));
  sl.registerLazySingleton<AddContactUseCase>(() => AddContactUseCase(sl()));
  
  // SOS Use Cases
  sl.registerLazySingleton<SendSosAlertUseCase>(() => SendSosAlertUseCase(sl()));
}

/// Register BLoCs
void _registerBlocs() {
  // Auth BLoC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: sl(),
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
    ),
  );

  // Track BLoC
  sl.registerFactory<TrackBloc>(
    () => TrackBloc(locationService: sl(), locationSharingService: sl()),
  );

  // Contacts BLoC
  sl.registerFactory<ContactsBloc>(
    () => ContactsBloc(
      getContactsUseCase: sl(),
      addContactUseCase: sl(),
      repository: sl(),
    ),
  );

  // FakeCall BLoC
  sl.registerFactory<FakeCallBloc>(() => FakeCallBloc());
  
  // SOS BLoC
  sl.registerFactory<SosBloc>(() => SosBloc(sl(), sl(), sl(), sl()));
}
