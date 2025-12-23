import 'package:local_auth/local_auth.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final LocalDataSource localDataSource;
  final LocalAuthentication localAuth;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.localAuth,
  });

  @override
  Future<void> createAccount(String username, String pin) async {
    // Check if user already exists
    final existingUser = await localDataSource.getUser();
    if (existingUser != null) {
      throw Exception('Account already exists');
    }

    // Create new user
    final user = UserModel(
      username: username,
      pin: pin,
      biometricEnabled: false,
    );

    // Save to secure storage
    await localDataSource.saveUser(user);
  }

  @override
  Future<User> login(String username, String pin) async {
    // Get saved user
    final savedUser = await localDataSource.getUser();

    if (savedUser == null) {
      throw Exception('User not found');
    }

    // Validate credentials
    if (savedUser.username != username || savedUser.pin != pin) {
      throw Exception('Invalid username or PIN');
    }

    // Set as current user
    await localDataSource.setCurrentUser(savedUser);

    return savedUser;
  }

  @override
  Future<void> enableBiometric(String username, String pin) async {
    // Validate credentials first
    final isValid = await validateCredentials(username, pin);
    if (!isValid) {
      throw Exception('Invalid credentials');
    }

    // Check device biometric capability
    try {
      final isDeviceSupported = await localAuth.canCheckBiometrics;
      if (!isDeviceSupported) {
        throw Exception('Device does not support biometric authentication');
      }

      // Enable biometric in storage
      await localDataSource.enableBiometric();
    } on LocalAuthException catch (e) {
      throw Exception('Biometric setup failed: $e');
    } catch (e) {
      throw Exception('Failed to enable biometric: $e');
    }
  }

  @override
  Future<void> disableBiometric() async {
    await localDataSource.disableBiometric();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getCurrentUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearAll();
  }

  @override
  Future<bool> validateCredentials(String username, String pin) async {
    final savedUser = await localDataSource.getUser();
    if (savedUser == null) return false;
    return savedUser.username == username && savedUser.pin == pin;
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return await localDataSource.isBiometricEnabled();
  }

  @override
  Future<User> authenticateWithBiometric() async {
    try {
      // Check if biometric is enabled
      final enabled = await isBiometricEnabled();
      if (!enabled) {
        throw Exception('Biometric authentication is not enabled');
      }

      // Check device support
      final isDeviceSupported = await localAuth.canCheckBiometrics;
      if (!isDeviceSupported) {
        throw Exception('Device does not support biometric');
      }

      // Get available biometrics
      final availableBiometrics = await localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        throw Exception('No biometric data available on device');
      }

      // Authenticate
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access BioSecure',
      );

      if (!authenticated) {
        throw Exception('Biometric authentication failed');
      }

      // Get current user
      final user = await getCurrentUser();
      if (user == null) {
        throw Exception('User not found');
      }

      return user;
    } on LocalAuthException catch (e) {
      throw Exception('Authentication error: $e');
    } catch (e) {
      throw Exception('Biometric authentication failed: $e');
    }
  }
}
