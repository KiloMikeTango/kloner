part of 'app_cloner_bloc.dart';

abstract class AppClonerState extends Equatable {
  const AppClonerState();

  @override
  List<Object> get props => []; 
}

class AppClonerInitial extends AppClonerState {
  const AppClonerInitial();
  
  @override
  List<Object> get props => []; 
}

class AppClonerLoading extends AppClonerState {
  const AppClonerLoading();
  
  @override
  List<Object> get props => [];
}

class AppClonerLoaded extends AppClonerState {
  final List<AppEntity> apps;
  final bool isCloning;
  final List<String> clonedApps;
  final String? error; // Nullable field

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
      error: error,
    );
  }

  @override
  List<Object> get props => [
    apps,     
    isCloning,
    clonedApps,
    error ?? '', 
  ];
}

class AppClonerError extends AppClonerState {
  final String message;

  const AppClonerError(this.message);

  @override
  List<Object> get props => [message]; 
}
