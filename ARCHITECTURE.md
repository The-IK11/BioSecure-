# BioSecure - Clean Architecture Setup

## Project Structure

The project has been reorganized following Clean Architecture principles with three main layers:

### 1. **Domain Layer** (`lib/domain/`)
Contains business logic and entity definitions, independent of any external framework.

```
domain/
├── entities/
│   └── user.dart                    # User entity (username, pin, biometricEnabled)
├── repositories/
│   └── auth_repository.dart         # Abstract AuthRepository interface
└── usecases/
    └── auth_usecases.dart           # All authentication use cases
        - CreateAccountUseCase
        - LoginUseCase
        - BiometricSetupUseCase
        - BiometricAuthUseCase
        - LogoutUseCase
        - DisableBiometricUseCase
```

### 2. **Data Layer** (`lib/data/`)
Handles data operations, storage, and external services (APIs, local storage, etc).

```
data/
├── datasources/
│   └── local_data_source.dart       # Flutter Secure Storage operations
├── models/
│   └── user_model.dart              # UserModel extends User with JSON serialization
└── repositories/
    └── auth_repository_impl.dart    # Implementation of AuthRepository interface
```

### 3. **Presentation Layer** (`lib/presentation/`)
UI components and screens that interact with use cases.

```
presentation/
├── pages/                           # Screen/Page widgets
│   ├── login_screen.dart
│   ├── splash_screen.dart
│   ├── create_new_account_screen.dart
│   ├── biometric_setup_screen.dart
│   └── bottom_navigation_screen.dart
├── widgets/                         # Reusable UI components
├── providers/                       # State management (if using Riverpod/Provider)
```

### 4. **Core Layer** (`lib/core/`)
Shared utilities, constants, and theme used across the app.

```
core/
├── constants/
│   └── app_constants.dart           # App-wide constants
├── utils/
│   └── service_locator.dart         # Dependency injection container
└── theme/                           # App theme definitions
```

## Data Flow

### Account Creation Flow
```
CreateNewAccountScreen
    ↓
User enters Username & PIN
    ↓
CreateAccountUseCase.call(username, pin)
    ↓
AuthRepositoryImpl.createAccount()
    ↓
LocalDataSource.saveUser()
    ↓
FlutterSecureStorage (encrypted)
    ↓
Navigate to BiometricSetupScreen
```

### Biometric Setup Flow
```
BiometricSetupScreen
    ↓
User enters saved Username & PIN
    ↓
BiometricSetupUseCase.call(username, pin)
    ↓
AuthRepositoryImpl.enableBiometric()
    ↓
LocalDataSource.enableBiometric()
    ↓
LocalAuthentication (device capability check)
    ↓
Navigate to BottomNavigationScreen
```

### Login Flow
```
LoginScreen
    ↓
User clicks "Enable Biometric Login"
    ↓
BiometricAuthUseCase.call()
    ↓
AuthRepositoryImpl.authenticateWithBiometric()
    ↓
LocalAuthentication.authenticate()
    ↓
User Biometric Scan
    ↓
Success → Navigate to BottomNavigationScreen
```

## Key Classes

### User Entity
- `username`: String
- `pin`: String
- `biometricEnabled`: bool

### AuthRepository Interface
Defines operations:
- `createAccount(username, pin)`
- `login(username, pin)`
- `enableBiometric(username, pin)`
- `disableBiometric()`
- `authenticateWithBiometric()`
- `isBiometricEnabled()`
- `logout()`

### LocalDataSource
Handles encrypted storage using `FlutterSecureStorage`:
- Save/retrieve user credentials
- Manage biometric status
- Handle current user session

### ServiceLocator (Dependency Injection)
Initializes and provides access to:
- All use cases
- Repositories
- Data sources
- External services (LocalAuth, SecureStorage)

## Dependencies

```yaml
flutter_secure_storage: ^latest
local_auth: ^latest
```

## Next Steps

1. **Update Presentation Files** - Migrate all screens to use ServiceLocator for dependency injection
2. **Remove Direct Storage Calls** - Replace direct FlutterSecureStorage calls with use cases
3. **Add Error Handling** - Implement proper error handling with custom exceptions
4. **Add State Management** - Consider adding Riverpod or Provider for state management
5. **Create UI Widgets** - Move common UI patterns to `presentation/widgets/`
6. **Add Unit Tests** - Test use cases and repositories
7. **Add Widget Tests** - Test presentation layer screens

## Benefits of This Architecture

✅ **Separation of Concerns** - Each layer has a single responsibility
✅ **Testability** - Easy to mock dependencies and test in isolation
✅ **Scalability** - Easy to add new features without affecting existing code
✅ **Maintainability** - Clear structure and dependencies
✅ **Reusability** - Business logic is independent of UI framework
✅ **Flexibility** - Easy to switch implementations (e.g., API calls instead of local storage)
