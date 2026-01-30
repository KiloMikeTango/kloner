// lib/features/app_cloner/presentation/bloc/app_cloner_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kloner/core/utils/usecase.dart';
import '../../../../core/errors/failures.dart';  // ✅ FIXED import path
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
  if (state is AppClonerLoaded) {
    final currentState = state as AppClonerLoaded;
    final packageName = event.packageName;
    
    // ✅ PREVENT DUPLICATES
    if (currentState.clonedApps.contains(packageName)) {
      emit(currentState.copyWith(error: 'Already cloned!'));
      return;
    }

    // ✅ Set PER-APP cloning state
    final newCloningApps = Map<String, bool>.from(currentState.cloningApps);
    newCloningApps[packageName] = true;
    
    emit(currentState.copyWith(cloningApps: newCloningApps));

    try {
      // ✅ 3 second simulation (replace with real cloneApp later)
      await Future.delayed(const Duration(seconds: 3));
      
      // ✅ SUCCESS - Add to cloned list
      final newClonedApps = [...currentState.clonedApps, packageName];
      newCloningApps[packageName] = false;
      
      emit(currentState.copyWith(
        clonedApps: newClonedApps,
        cloningApps: newCloningApps,
      ));
    } catch (e) {
      // ✅ ERROR - Reset only this app
      newCloningApps[packageName] = false;
      emit(currentState.copyWith(
        cloningApps: newCloningApps,
        error: 'Clone failed: $e',
      ));
    }
  }
}



  String _mapFailureToMessage(Failure failure) {
    return failure is SecurityFailure 
        ? 'Security check failed'
        : 'Operation failed';
  }
}
