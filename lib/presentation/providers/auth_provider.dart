import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Authentication state
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Auth Provider for managing authentication state and operations
class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  AuthState _state = AuthState.initial;
  String? _currentUser;
  String? _errorMessage;
  bool _isBiometricEnabled = false;

  AuthProvider({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _localAuth = localAuth ?? LocalAuthentication();

  // Getters
  AuthState get state => _state;
  String? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;

  /// Initialize auth state (check if user is already logged in)
  Future<void> initializeAuth() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      final user = await _storage.read(key: 'current_user');
      final biometricEnabled = await _storage.read(key: 'biometric_enabled');

      if (user != null) {
        _currentUser = user;
        _isBiometricEnabled = biometricEnabled == 'true';
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }

    notifyListeners();
  }

  /// Create new account
  Future<void> createAccount(String username, String pin) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _storage.write(key: 'username', value: username);
      await _storage.write(key: 'user_pin', value: pin);
      _currentUser = username;
      _state = AuthState.unauthenticated;
    } catch (e) {
      _errorMessage = 'Failed to create account: $e';
      _state = AuthState.error;
    }

    notifyListeners();
  }

  /// Validate credentials
  Future<bool> validateCredentials(String username, String pin) async {
    try {
      final savedUsername = await _storage.read(key: 'username');
      final savedPin = await _storage.read(key: 'user_pin');
      return savedUsername == username && savedPin == pin;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  /// Setup biometric
  Future<void> setupBiometric(String username, String pin) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate credentials
      final isValid = await validateCredentials(username, pin);
      if (!isValid) {
        throw Exception('Invalid username or PIN');
      }

      // Check biometric support
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!isAvailable || !isDeviceSupported) {
        throw Exception('Biometric not supported on this device');
      }

      // Authenticate with biometric
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometric login',
        biometricOnly: true,
      );

      if (authenticated) {
        await _storage.write(key: 'biometric_enabled', value: 'true');
        await _storage.write(key: 'current_user', value: username);
        _isBiometricEnabled = true;
        _currentUser = username;
        _state = AuthState.authenticated;
      } else {
        throw Exception('Biometric authentication failed');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }

    notifyListeners();
  }

  /// Authenticate with biometric
  Future<bool> authenticateWithBiometric() async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (!_isBiometricEnabled) {
        throw Exception('Biometric not enabled');
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access BioSecure',
        biometricOnly: true,
      );

      if (authenticated) {
        _state = AuthState.authenticated;
        return true;
      } else {
        _errorMessage = 'Authentication failed';
        _state = AuthState.unauthenticated;
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Login
  Future<void> login(String username, String pin) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final isValid = await validateCredentials(username, pin);
      if (!isValid) {
        throw Exception('Invalid credentials');
      }

      await _storage.write(key: 'current_user', value: username);
      _currentUser = username;
      _state = AuthState.authenticated;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }

    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _storage.deleteAll();
      _currentUser = null;
      _isBiometricEnabled = false;
      _state = AuthState.unauthenticated;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
    }

    notifyListeners();
  }

  /// Disable biometric
  Future<void> disableBiometric() async {
    try {
      await _storage.write(key: 'biometric_enabled', value: 'false');
      _isBiometricEnabled = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
