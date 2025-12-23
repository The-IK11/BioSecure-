import '../../domain/entities/user.dart';

/// User model for data layer with JSON serialization
class UserModel extends User {
  UserModel({
    required String username,
    required String pin,
    bool biometricEnabled = false,
  }) : super(
    username: username,
    pin: pin,
    biometricEnabled: biometricEnabled,
  );

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String,
      pin: json['pin'] as String,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'pin': pin,
      'biometricEnabled': biometricEnabled,
    };
  }

  /// Convert to entity
  User toEntity() {
    return User(
      username: username,
      pin: pin,
      biometricEnabled: biometricEnabled,
    );
  }
}
