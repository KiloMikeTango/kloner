import 'package:equatable/equatable.dart';

/// Base Failure class for error handling
abstract class Failure extends Equatable {
  const Failure();
  
  @override
  List<Object> get props => [];
}

/// App-specific failures
class AppFailure extends Failure {
  final String? message;
  const AppFailure([this.message]);
  
  @override
  List<Object> get props => [if (message != null) message!];
}

/// Security-related failures
class SecurityFailure extends Failure {
  final String? message;
  const SecurityFailure([this.message = 'Security check failed']);
  
  @override
  List<Object> get props => [message!];
}

/// Cache failures
class CacheFailure extends Failure {
  final String? message;
  const CacheFailure([this.message = 'Cache operation failed']);
  
  @override
  List<Object> get props => [message!];
}

/// Server/Network failures
class ServerFailure extends Failure {
  final String? message;
  const ServerFailure([this.message = 'Server error occurred']);
  
  @override
  List<Object> get props => [message!];
}
