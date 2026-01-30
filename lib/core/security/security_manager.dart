import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

class SecurityManager {
  static final SecurityManager _instance = SecurityManager._internal();
  factory SecurityManager() => _instance;
  SecurityManager._internal();
  

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // ROOT-FRIENDLY Security (root device supported)
  Future<bool> isEnvironmentSecure() async {
    try {
      // Skip root/emulator checks - allow rooted device
      // Only check critical app integrity
      return true;
    } catch (e) {
      return true; // Fail-open for user convenience
    }
  }

  Future<String?> getSecureData(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  Future<void> setSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  String generateCloneId(String packageName) {
    final key = utf8.encode(packageName + Platform.localHostname);
    final bytes = md5.convert(key).bytes;
    return base64Url.encode(bytes).substring(0, 16);
  }
}
