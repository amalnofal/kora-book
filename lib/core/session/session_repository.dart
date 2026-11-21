import 'package:supabase_flutter/supabase_flutter.dart';

enum AccountRole { customer, venue }

class SessionInfo {
  const SessionInfo({required this.role, required this.setupCompleted});

  final AccountRole role;

  /// Only meaningful for venue accounts.
  final bool setupCompleted;
}

class SessionRepository {
  SessionRepository(this._client);

  final SupabaseClient _client;

  bool get isSignedIn => _client.auth.currentSession != null;

  Stream<AuthState> get authChanges => _client.auth.onAuthStateChange;

  /// Loads role (+ venue setup status) for the signed-in user.
  /// Returns null if signed out or the profile row is missing.
  Future<SessionInfo?> loadSessionInfo() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final profile = await _client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();
    if (profile == null) return null;

    final role = profile['role'] == 'venue'
        ? AccountRole.venue
        : AccountRole.customer;

    if (role == AccountRole.customer) {
      return const SessionInfo(
        role: AccountRole.customer,
        setupCompleted: true,
      );
    }

    final venue = await _client
        .from('venues')
        .select('setup_completed_at')
        .eq('account_id', user.id)
        .maybeSingle();

    return SessionInfo(
      role: AccountRole.venue,
      setupCompleted: venue?['setup_completed_at'] != null,
    );
  }

  Future<void> signOut() => _client.auth.signOut();
}
