// lib/core/services/application_manager.dart
import 'package:flutter/foundation.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import '../../features/app_cloner/domain/entities/app_entity.dart';

class ApplicationManager {
  static final ApplicationManager _instance = ApplicationManager._internal();
  factory ApplicationManager() => _instance;
  ApplicationManager._internal();

  Future<List<AppEntity>> getInstalledApplications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      final List<AppInfo>? apps = await InstalledApps.getInstalledApps(
        excludeSystemApps: false,
        withIcon: true,
      );
      
      if (apps != null && apps.isNotEmpty) {
        return apps
            .where((appInfo) => appInfo.packageName != null)
            .take(30)
            .map((appInfo) => AppEntity(
                  packageName: appInfo.packageName ?? 'unknown',
                  appName: appInfo.name ?? 'Unknown App',
                  icon: appInfo.icon,
                  version: appInfo.versionName ?? '1.0.0',     // ✅ NULL-SAFE
                  isSystemApp: appInfo.isSystemApp ?? false,   // ✅ NULL-SAFE
                ))
            .where((app) => !app.packageName.contains('kloner'))
            .toList();
      }
    } catch (e) {
      debugPrint('📱 AppManager: Using demo apps ($e)');
    }
    
    return _getDemoApps();
  }

  static List<AppEntity> _getDemoApps() {
    return [
      AppEntity(
        packageName: 'com.whatsapp',
        appName: 'WhatsApp',
        icon: null,
        version: '2.24.1',
        isSystemApp: false,
      ),
      AppEntity(
        packageName: 'org.telegram.messenger',
        appName: 'Telegram',
        icon: null,
        version: '10.5.0',
        isSystemApp: false,
      ),
      AppEntity(
        packageName: 'com.google.android.youtube',
        appName: 'YouTube',
        icon: null,
        version: '19.25.39',
        isSystemApp: false,
      ),
    ];
  }
}
