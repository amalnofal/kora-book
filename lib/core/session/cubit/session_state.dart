part of 'session_cubit.dart';

sealed class SessionState {
  const SessionState();
}

/// Checking the stored session at app start.
class SessionLoading extends SessionState {
  const SessionLoading();
}

class SessionSignedOut extends SessionState {
  const SessionSignedOut();
}

class SessionSignedIn extends SessionState {
  const SessionSignedIn(this.info);
  final SessionInfo info;
}

/// Signed in but role could not be loaded (network/profile issue).
class SessionError extends SessionState {
  const SessionError();
}
