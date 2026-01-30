// lib/features/app_cloner/data/repositories/app_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:kloner/core/errors/failures.dart';
import 'package:kloner/core/services/application_manager.dart';
import 'package:kloner/features/app_cloner/domain/entities/app_entity.dart';
import 'package:kloner/features/app_cloner/domain/repositories/app_repository.dart';

class AppRepositoryImpl implements AppRepository {
  final ApplicationManager _appManager;
  
  AppRepositoryImpl(this._appManager);

  @override
  Future<Either<Failure, List<AppEntity>>> getInstalledApps() async {
    try {
      // ✅ Get apps from ApplicationManager
      final apps = await _appManager.getInstalledApplications();
      
      // ✅ Filter valid apps only
      final appEntities = apps
          .where((app) => app.packageName.isNotEmpty && app.appName.isNotEmpty)
          .map((app) => AppEntity(
            packageName: app.packageName,
            appName: app.appName,
            icon: app.icon,
            version: app.version ?? '1.0.0',        // ✅ REQUIRED: Provide fallback
            isSystemApp: app.isSystemApp ?? false,  // ✅ REQUIRED: Provide fallback
          ))
          .where((app) => !app.packageName.contains('kloner'))
          .toList();
      
      return Right(appEntities);
    } catch (e) {
      return Left(AppFailure('Failed to load apps: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> cloneApp(String targetPackageName) async {
    try {
      final clonePackageName = '${targetPackageName}_kloner_${DateTime.now().millisecondsSinceEpoch}';
      
      if (await _isAppInstalled(clonePackageName)) {
        return const Right(true);
      }
      
      final result = await _attemptClone(targetPackageName, clonePackageName);
      
      if (result) {
        await _saveClonedApp(clonePackageName);
        return const Right(true);
      }
      
      return Left(AppFailure());
    } catch (e) {
      return Left(AppFailure());
    }
  }

  // ✅ Keep all your existing helper methods
  Future<bool> _attemptClone(String original, String cloneName) async {
    if (await _hasShizuku()) return await _shizukuClone(original, cloneName);
    if (await _hasRoot()) return await _rootClone(original, cloneName);
    return await _workProfileClone(original, cloneName);
  }

  Future<bool> _shizukuClone(String original, String cloneName) async {
    await Future.delayed(const Duration(seconds: 3)); return true;
  }
  Future<bool> _rootClone(String original, String cloneName) async {
    await Future.delayed(const Duration(seconds: 5)); return true;
  }
  Future<bool> _workProfileClone(String original, String cloneName) async {
    await Future.delayed(const Duration(seconds: 4)); return true;
  }
  Future<bool> _hasShizuku() async => false;
  Future<bool> _hasRoot() async => false;   
  Future<bool> _isAppInstalled(String package) async => false;
  Future<void> _saveClonedApp(String package) async {}
}
