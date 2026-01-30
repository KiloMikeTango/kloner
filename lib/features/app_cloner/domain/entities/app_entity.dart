// lib/features/app_cloner/domain/entities/app_entity.dart
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class AppEntity extends Equatable {
  final String packageName;
  final String appName;
  final Uint8List? icon;          
  final String version;
  final bool isSystemApp;

  const AppEntity({
    required this.packageName,
    required this.appName,
    this.icon,                   
    required this.version,
    required this.isSystemApp,
  });

  @override
  List<Object?> get props => [packageName, appName, icon, version, isSystemApp];
}
