// lib/features/app_cloner/data/models/app_model.dart
import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:installed_apps/app_info.dart';
import '../../domain/entities/app_entity.dart';

class AppModel extends Equatable implements AppEntity {
  @override
  final String packageName;
  @override
  final String appName;
  @override
  final Uint8List? icon;
  @override
  final String version;
  @override
  final bool isSystemApp;

  const AppModel({
    required this.packageName,
    required this.appName,
    this.icon,
    required this.version,
    required this.isSystemApp,
  });

  factory AppModel.fromAppInfo(AppInfo appInfo) {
    return AppModel(
      packageName: appInfo.packageName ,
      appName: appInfo.name ,
      icon: appInfo.icon,
      version: appInfo.versionName ,
      isSystemApp: appInfo.isSystemApp ,
    );
  }

  @override
  List<Object?> get props => [packageName, appName, icon, version, isSystemApp];
}
