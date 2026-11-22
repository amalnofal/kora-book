enum AuthFailureType {
  invalidCredentials,
  emailNotConfirmed,
  emailTaken,
  invalidOtp,
  rateLimited,
  weakPassword,
  samePassword,
  network,
  unknown,
}

/// Thrown by AuthRepository. The UI maps [type] to a localized message.
class AuthFailure implements Exception {
  const AuthFailure(this.type);

  final AuthFailureType type;
}
