import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';

/// Service locator for dependency injection
/// This class manages all dependencies and their initialization
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  late LocalDataSource _localDataSource;
  late AuthRepository _authRepository;

  // Use cases
  late CreateAccountUseCase _createAccountUseCase;
  late LoginUseCase _loginUseCase;
  late BiometricSetupUseCase _biometricSetupUseCase;
  late BiometricAuthUseCase _biometricAuthUseCase;
  late LogoutUseCase _logoutUseCase;
  late DisableBiometricUseCase _disableBiometricUseCase;

  /// Initialize all dependencies
  Future<void> init() async {
    // Initialize local auth and secure storage
    final localAuth = LocalAuthentication();
    const secureStorage = FlutterSecureStorage();

    // Initialize data sources
    _localDataSource = LocalDataSource(secureStorage);

    // Initialize repositories
    _authRepository = AuthRepositoryImpl(
      localDataSource: _localDataSource,
      localAuth: localAuth,
    );

    // Initialize use cases
    _createAccountUseCase = CreateAccountUseCase(_authRepository);
    _loginUseCase = LoginUseCase(_authRepository);
    _biometricSetupUseCase = BiometricSetupUseCase(_authRepository);
    _biometricAuthUseCase = BiometricAuthUseCase(_authRepository);
    _logoutUseCase = LogoutUseCase(_authRepository);
    _disableBiometricUseCase = DisableBiometricUseCase(_authRepository);
  }

  // Getters
  LocalDataSource get localDataSource => _localDataSource;
  AuthRepository get authRepository => _authRepository;

  CreateAccountUseCase get createAccountUseCase => _createAccountUseCase;
  LoginUseCase get loginUseCase => _loginUseCase;
  BiometricSetupUseCase get biometricSetupUseCase => _biometricSetupUseCase;
  BiometricAuthUseCase get biometricAuthUseCase => _biometricAuthUseCase;
  LogoutUseCase get logoutUseCase => _logoutUseCase;
  DisableBiometricUseCase get disableBiometricUseCase => _disableBiometricUseCase;
}
