import 'package:get_it/get_it.dart';
import '../../../data/datasources/remote/auth_remote_source.dart';
import '../../../data/repositories_impl/profile_repository_impl.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../domain/usecases/update_profile_usecase.dart';
import '../bloc/bloc/profile_bloc.dart';

/// Setup profile-related dependencies
class ProfileDependencies {
  static void setup() {
    final getIt = GetIt.instance;

    // Register ProfileRepository
    if (!getIt.isRegistered<ProfileRepository>()) {
      getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(getIt<AuthRemoteSource>()),
      );
    }

    // Register UpdateProfileUseCase
    if (!getIt.isRegistered<UpdateProfileUseCase>()) {
      getIt.registerLazySingleton<UpdateProfileUseCase>(
        () => UpdateProfileUseCase(getIt<ProfileRepository>()),
      );
    }

    // Register ProfileBloc as factory (new instance each time)
    if (!getIt.isRegistered<ProfileBloc>()) {
      getIt.registerFactory<ProfileBloc>(
        () => ProfileBloc(
          updateProfileUseCase: getIt<UpdateProfileUseCase>(),
          profileRepository: getIt<ProfileRepository>(),
        ),
      );
    }
  }
}
