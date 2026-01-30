// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../security/security_manager.dart';
import '../services/application_manager.dart';
import '../services/real_cloner.dart'; // 🔥 NEW
import '../../features/app_cloner/data/repositories/app_repository_impl.dart';
import '../../features/app_cloner/domain/repositories/app_repository.dart';
import '../../features/app_cloner/domain/usecases/get_installed_apps.dart';
import '../../features/app_cloner/domain/usecases/clone_app.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 🔥 Core Services
  sl.registerLazySingleton<ApplicationManager>(() => ApplicationManager());
  sl.registerLazySingleton<SecurityManager>(() => SecurityManager());
  sl.registerLazySingleton<RealCloner>(() => RealCloner()); // 🔥 REAL CLONING

  // ✅ Repository - NOW with RealCloner!
  sl.registerLazySingleton<AppRepository>(
    () => AppRepositoryImpl(
      sl<ApplicationManager>(),
      sl<RealCloner>(), // 🔥 Pass RealCloner
    ),
  );

  // ✅ UseCases
  sl.registerLazySingleton(() => GetInstalledApps(sl<AppRepository>()));
  sl.registerLazySingleton(() => CloneApp(sl<AppRepository>()));
}
