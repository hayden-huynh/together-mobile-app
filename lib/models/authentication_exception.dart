class AuthenticationException implements Exception {
  final List<String> message;

  AuthenticationException(this.message);
}