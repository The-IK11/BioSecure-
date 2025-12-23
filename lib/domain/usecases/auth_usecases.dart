import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for creating a new account
class CreateAccountUseCase {
  final AuthRepository repository;

  CreateAccountUseCase(this.repository);

  Future<void> call(String username, String pin) async {
    if (username.isEmpty) {
      throw Exception('Username cannot be empty');
    }
    if (pin.isEmpty || pin.length < 4) {
      throw Exception('PIN must be at least 4 characters');
    }
    return await repository.createAccount(username, pin);
  }
}

/// Use case for logging in with credentials
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String username, String pin) async {
    if (username.isEmpty || pin.isEmpty) {
      throw Exception('Username and PIN are required');
    }
    return await repository.login(username, pin);
  }
}

/// Use case for setting up biometric authentication
class BiometricSetupUseCase {
  final AuthRepository repository;

  BiometricSetupUseCase(this.repository);

  Future<void> call(String username, String pin) async {
    // First validate credentials
    final isValid = await repository.validateCredentials(username, pin);
    if (!isValid) {
      throw Exception('Invalid username or PIN');
    }
    // Then enable biometric
    return await repository.enableBiometric(username, pin);
  }
}

/// Use case for authenticating with biometric
class BiometricAuthUseCase {
  final AuthRepository repository;

  BiometricAuthUseCase(this.repository);

  Future<User> call() async {
    return await repository.authenticateWithBiometric();
  }
}

/// Use case for logging out
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}

/// Use case for disabling biometric
class DisableBiometricUseCase {
  final AuthRepository repository;

  DisableBiometricUseCase(this.repository);

  Future<void> call() async {
    return await repository.disableBiometric();
  }
}
