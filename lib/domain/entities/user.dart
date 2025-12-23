/// User entity representing a user in the domain layer
class User {
  final String username;
  final String pin;
  final bool biometricEnabled;

  User({
    required this.username,
    required this.pin,
    this.biometricEnabled = false,
  });

  /// Create a copy of this user with modified fields
  User copyWith({
    String? username,
    String? pin,
    bool? biometricEnabled,
  }) {
    return User(
      username: username ?? this.username,
      pin: pin ?? this.pin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}
