import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// Local data source for secure storage operations
class LocalDataSource {
  static const String _userKey = 'bio_secure_user';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _currentUserKey = 'current_user';

  final FlutterSecureStorage _secureStorage;

  LocalDataSource(this._secureStorage);

  /// Save user credentials
  Future<void> saveUser(UserModel user) async {
    try {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  /// Get user credentials
  Future<UserModel?> getUser() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);
      if (userJson == null) return null;
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw Exception('Failed to retrieve user: $e');
    }
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      throw Exception('Failed to check biometric status: $e');
    }
  }

  /// Enable biometric
  Future<void> enableBiometric() async {
    try {
      await _secureStorage.write(
        key: _biometricEnabledKey,
        value: 'true',
      );
    } catch (e) {
      throw Exception('Failed to enable biometric: $e');
    }
  }

  /// Disable biometric
  Future<void> disableBiometric() async {
    try {
      await _secureStorage.write(
        key: _biometricEnabledKey,
        value: 'false',
      );
    } catch (e) {
      throw Exception('Failed to disable biometric: $e');
    }
  }

  /// Save current logged-in user
  Future<void> setCurrentUser(UserModel user) async {
    try {
      await _secureStorage.write(
        key: _currentUserKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw Exception('Failed to set current user: $e');
    }
  }

  /// Get current logged-in user
  Future<UserModel?> getCurrentUser() async {
    try {
      final userJson = await _secureStorage.read(key: _currentUserKey);
      if (userJson == null) return null;
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Clear all data (logout)
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw Exception('Failed to clear storage: $e');
    }
  }

  /// Delete specific key
  Future<void> deleteKey(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw Exception('Failed to delete key: $e');
    }
  }
}
