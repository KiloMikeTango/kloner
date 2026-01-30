import 'package:dartz/dartz.dart';
import 'package:kloner/core/errors/failures.dart';
import 'package:kloner/features/app_cloner/domain/usecases/usecase.dart';
import '../repositories/app_repository.dart';

class CloneApp implements UseCase<bool, String> {
  final AppRepository repository;

  CloneApp(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.cloneApp(params);
  }
}
