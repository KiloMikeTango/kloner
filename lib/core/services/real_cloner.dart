// lib/core/services/real_cloner.dart
import 'dart:io';

class RealCloner {
  static Future<bool> cloneAppWorkProfile(String packageName) async {
    try {
      print('🔥 REAL CLONE START: $packageName');
      
      // ✅ REAL Android Work Profile command
      final result = await Process.run('pm', [
        'install-existing', 
        '--user', '10',  // Work Profile user ID
        packageName
      ]);
      
      print('📱 PM RESULT: ${result.stdout}');
      print('📱 PM ERROR: ${result.stderr}');
      
      final success = result.exitCode == 0;
      
      if (success) {
        print('✅ REAL CLONE SUCCESS: $packageName → User 10');
      } else {
        print('❌ REAL CLONE FAILED: ${result.stderr}');
      }
      
      return success;
    } catch (e) {
      print('❌ REAL CLONE EXCEPTION: $e');
      return false;
    }
  }
  
  static Future<bool> verifyCloneExists(String packageName) async {
    try {
      final result = await Process.run('pm', [
        'list', 'users', '--user', '10', 'packages'
      ]);
      final output = result.stdout.toString();
      return output.contains(packageName);
    } catch (e) {
      return false;
    }
  }
}
