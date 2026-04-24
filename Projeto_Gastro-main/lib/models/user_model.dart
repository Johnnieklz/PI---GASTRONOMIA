class UserModel {
  final int id;
  final String email;
  final String username;
  final String? fullName;
  final bool isActive;
  final bool isSuperuser;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.fullName,
    this.isActive = true,
    this.isSuperuser = false,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['full_name'],
      isActive: json['is_active'] ?? true,
      isSuperuser: json['is_superuser'] ?? false,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'is_active': isActive,
      'is_superuser': isSuperuser,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final UserModel? user;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResponse(
      accessToken: data['access_token'],
      tokenType: data['token_type'],
      expiresIn: data['expires_in'],
      user: data.containsKey('user') ? UserModel.fromJson(data['user']) : null,
    );
  }
}
