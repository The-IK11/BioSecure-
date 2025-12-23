import '../entities/user.dart';

/// Abstract repository for authentication operations
/// This defines the contract that data layer must implement
abstract class AuthRepository {
  /// Create a new account with username and PIN
  Future<void> createAccount(String username, String pin);

  /// Login with username and PIN
  Future<User> login(String username, String pin);

  /// Enable biometric authentication for current user
  Future<void> enableBiometric(String username, String pin);

  /// Disable biometric authentication for current user
  Future<void> disableBiometric();

  /// Get current logged-in user
  Future<User?> getCurrentUser();

  /// Logout current user
  Future<void> logout();

  /// Check if user credentials are valid
  Future<bool> validateCredentials(String username, String pin);

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled();

  /// Authenticate using biometric
  Future<User> authenticateWithBiometric();
}
