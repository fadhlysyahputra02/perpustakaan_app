class AuthModel {
  final String username;
  final String token;
  final String refreshToken;

  AuthModel({
    required this.username,
    required this.token,
    required this.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      username: json['username'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}
