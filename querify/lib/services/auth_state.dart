/// Simple singleton that holds auth state for the duration of the app session.
/// No external packages needed — just import and use anywhere.
class AuthState {
  AuthState._();
  static final AuthState instance = AuthState._();

  String? token;
  String? role;
  String? username;

  bool get isLoggedIn => token != null;

  void setFromAuth({
    required String token,
    required String role,
    required String username,
  }) {
    this.token = token;
    this.role = role;
    this.username = username;
  }

  void clear() {
    token = null;
    role = null;
    username = null;
  }
}