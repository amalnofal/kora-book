import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../session_repository.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repo) : super(const SessionLoading()) {
    _sub = _repo.authChanges.listen((_) => refresh());
    refresh();
  }

  final SessionRepository _repo;
  late final StreamSubscription<dynamic> _sub;

  Future<void> refresh() async {
    if (!_repo.isSignedIn) {
      emit(const SessionSignedOut());
      return;
    }
    try {
      final info = await _repo.loadSessionInfo();
      emit(info == null ? const SessionError() : SessionSignedIn(info));
    } catch (_) {
      emit(const SessionError());
    }
  }

  Future<void> signOut() => _repo.signOut();

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
