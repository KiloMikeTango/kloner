// lib/core/services/shizuku_service.dart
import 'package:flutter/foundation.dart';
import 'package:shizuku_api/shizuku_api.dart';

class ShizukuService {
  static final ShizukuApi _api = ShizukuApi();
  static bool _isInitialized = false;

  static Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      final isBinderRunning = await _api.pingBinder() ?? false;
      if (!isBinderRunning) return false;
      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Shizuku init failed: $e');
      return false;
    }
  }

  static Future<bool> checkPermission() async {
    try {
      return await _api.checkPermission() ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> requestPermission() async {
    try {
      return await _api.requestPermission() ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<String> executeCommand(String command) async {
    try {
      return await _api.runCommand(command) ?? '';
    } catch (e) {
      debugPrint('Shizuku command failed: $e');
      return '';
    }
  }

  // 🔥 REAL PACKAGE CLONING
  static Future<bool> cloneApp(String packageName) async {
    try {
      // Clone using new user ID (999 = clone user)
      final cloneCommand = 'pm install-existing --user 999 $packageName';
      final result = await executeCommand(cloneCommand);
      
      debugPrint('Shizuku clone result: $result');
      
      // Success criteria
      final success = !result.contains('Failure') && 
                     (result.contains('Success') || result.contains('Package'));
      
      return success;
    } catch (e) {
      debugPrint('Shizuku clone error: $e');
      return false;
    }
  }

  static Future<bool> isReady() async {
    return await initialize() && await checkPermission();
  }
}
