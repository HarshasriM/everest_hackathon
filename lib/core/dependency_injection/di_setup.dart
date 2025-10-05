
import '../../core/network/api_client.dart';
import '../../core/services/app_preferences_service.dart';
import '../../data/datasources/remote/auth_remote_source.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../features/auth/bloc/auth_bloc.dart';
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
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );
  
  // App Preferences
  final appPreferences = AppPreferencesService();
  await appPreferences.init();
  sl.registerLazySingleton<AppPreferencesService>(
    () => appPreferences,
  );
}

/// Register data sources
void _registerDataSources() {
  // Auth Remote Data Source
  sl.registerLazySingleton<AuthRemoteSource>(
    () => AuthRemoteSourceImpl(sl()),
  );
}

/// Register repositories
void _registerRepositories() {
  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteSource: sl(),
      preferencesService: sl(),
    ),
  );
  
  // TODO: Add SOS Repository when implemented
  // sl.registerLazySingleton<SosRepository>(
  //   () => SosRepositoryImpl(
  //     remoteSource: sl(),
  //     localSource: sl(),
  //   ),
  // );
}

/// Register use cases
void _registerUseCases() {
  // Auth Use Cases
  sl.registerLazySingleton<SendOtpUseCase>(
    () => SendOtpUseCase(sl()),
  );
  
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl()),
  );
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
}
