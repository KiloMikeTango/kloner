// lib/features/app_cloner/presentation/bloc/app_cloner_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kloner/features/app_cloner/domain/usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/usecases/clone_app.dart';
import '../../domain/usecases/get_installed_apps.dart';

part 'app_cloner_event.dart';
part 'app_cloner_state.dart';

class AppClonerBloc extends Bloc<AppClonerEvent, AppClonerState> {
 
  final GetInstalledApps getInstalledApps;
  final CloneApp cloneApp;

  AppClonerBloc({
    required this.getInstalledApps, 
    required this.cloneApp,
  }) : super(const AppClonerInitial()) {
    on<LoadApps>(_onLoadApps);
    on<CloneAppEvent>(_onCloneApp);
  }

  Future<void> _onLoadApps(LoadApps event, Emitter<AppClonerState> emit) async {
    emit(const AppClonerLoading());
    final result = await getInstalledApps(NoParams());
    
    result.fold(
      (failure) => emit(AppClonerError(_mapFailureToMessage(failure))),
      (apps) => emit(AppClonerLoaded(apps: apps)),
    );
  }

  Future<void> _onCloneApp(CloneAppEvent event, Emitter<AppClonerState> emit) async {
    final currentState = state;
    if (currentState is AppClonerLoaded) {
      emit(currentState.copyWith(isCloning: true));
      
      final result = await cloneApp(event.packageName);
      result.fold(
        (failure) => emit(currentState.copyWith(
          isCloning: false,
          error: _mapFailureToMessage(failure),
        )),
        (_) => emit(currentState.copyWith(
          isCloning: false,
          clonedApps: [...currentState.clonedApps, event.packageName],
        )),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    return failure is SecurityFailure 
        ? 'Security check failed'
        : 'Operation failed';
  }
}
