import 'package:dartz/dartz.dart';
import 'package:kloner/core/errors/failures.dart';
import '../entities/app_entity.dart';

abstract class AppRepository {
  Future<Either<Failure, List<AppEntity>>> getInstalledApps();
  Future<Either<Failure, bool>> cloneApp(String packageName);
}
