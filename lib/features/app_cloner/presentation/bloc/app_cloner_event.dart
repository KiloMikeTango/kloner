part of 'app_cloner_bloc.dart';

abstract class AppClonerEvent extends Equatable {
  const AppClonerEvent();
  @override
  List<Object> get props => [];
}

class LoadApps extends AppClonerEvent {}

class CloneAppEvent extends AppClonerEvent {
  final String packageName;
  const CloneAppEvent(this.packageName);
  @override
  List<Object> get props => [packageName];
}
