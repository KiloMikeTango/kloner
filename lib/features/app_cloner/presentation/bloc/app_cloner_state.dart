// lib/features/app_cloner/presentation/bloc/app_cloner_state.dart
part of 'app_cloner_bloc.dart';

abstract class AppClonerState extends Equatable {
  const AppClonerState();
  @override
  List<Object?> get props => [];
}

class AppClonerInitial extends AppClonerState {
  const AppClonerInitial();
}

class AppClonerLoading extends AppClonerState {
  const AppClonerLoading();
}

class AppClonerLoaded extends AppClonerState {
  final List<AppEntity> apps;
  final bool isCloning;
  final List<String> clonedApps;
  final String? error;

  const AppClonerLoaded({
    required this.apps,
    this.isCloning = false,
    this.clonedApps = const [],
    this.error,
  });

  AppClonerLoaded copyWith({
    List<AppEntity>? apps,
    bool? isCloning,
    List<String>? clonedApps,
    String? error,
  }) {
    return AppClonerLoaded(
      apps: apps ?? this.apps,
      isCloning: isCloning ?? this.isCloning,
      clonedApps: clonedApps ?? this.clonedApps,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [apps, isCloning, clonedApps, error];
}

class AppClonerError extends AppClonerState {
  final String message;  // ✅ FIXED: Added message field
  
  const AppClonerError(this.message);

  @override
  List<Object> get props => [message];
}
