import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/session/session_repository.dart' show AccountRole;
import 'models/auth_failure.dart';

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  Future<void> signIn({required String email, required String password}) =>
      _guard(
        () => _client.auth.signInWithPassword(email: email, password: password),
      );

  /// Creates the account. With "Confirm email" on, no session is created
  /// until [verifySignupOtp] succeeds.
  Future<void> signUp({
    required String email,
    required String password,
    required AccountRole role,
    required String name,
    required String phone,
  }) => _guard(() async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'role': role.name, 'name': name, 'phone': phone},
    );
    // For an already-registered email, Supabase returns a user with no
    // identities instead of an error.
    if (res.user?.identities?.isEmpty ?? false) {
      throw const AuthFailure(AuthFailureType.emailTaken);
    }
  });

  Future<void> verifySignupOtp({
    required String email,
    required String token,
  }) => _guard(
    () => _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.signup,
    ),
  );

  Future<void> resendSignupOtp(String email) =>
      _guard(() => _client.auth.resend(type: OtpType.signup, email: email));

  Future<void> sendRecoveryOtp(String email) =>
      _guard(() => _client.auth.resetPasswordForEmail(email));

  /// Note: this signs the user in (creates a session).
  Future<void> verifyRecoveryOtp({
    required String email,
    required String token,
  }) => _guard(
    () => _client.auth.verifyOTP(
      email: email,
      token: token,
      type: OtpType.recovery,
    ),
  );

  Future<void> updatePassword(String newPassword) => _guard(
    () => _client.auth.updateUser(UserAttributes(password: newPassword)),
  );

  /// Verifies the current password first, then sets the new one.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _guard(() async {
    final email = _client.auth.currentUser?.email;
    if (email == null) {
      throw const AuthFailure(AuthFailureType.unknown);
    }
    await _client.auth.signInWithPassword(
      email: email,
      password: currentPassword,
    );
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthFailure {
      rethrow;
    } on AuthRetryableFetchException {
      throw const AuthFailure(AuthFailureType.network);
    } on AuthException catch (e) {
      throw AuthFailure(_map(e));
    } catch (_) {
      throw const AuthFailure(AuthFailureType.unknown);
    }
  }

  AuthFailureType _map(AuthException e) => switch (e.code) {
    'invalid_credentials' => AuthFailureType.invalidCredentials,
    'email_not_confirmed' => AuthFailureType.emailNotConfirmed,
    'user_already_exists' || 'email_exists' => AuthFailureType.emailTaken,
    'otp_expired' || 'otp_disabled' => AuthFailureType.invalidOtp,
    'over_email_send_rate_limit' ||
    'over_request_rate_limit' => AuthFailureType.rateLimited,
    'weak_password' => AuthFailureType.weakPassword,
    'same_password' => AuthFailureType.samePassword,
    _ => AuthFailureType.unknown,
  };
}
