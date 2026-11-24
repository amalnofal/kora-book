import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kora_book/features/auth/data/auth_repository.dart';
import 'package:kora_book/features/auth/data/models/auth_failure.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(const LoginInitial());

  final AuthRepository _repo;

  Future<void> submit({required String email, required String password}) async {
    if (state is LoginLoading) return;
    emit(const LoginLoading());
    try {
      await _repo.signIn(email: email.trim(), password: password);
      // On success the session change makes the router leave this screen,
      // so the cubit may already be closed here.
      if (!isClosed) emit(const LoginInitial());
    } on AuthFailure catch (failure) {
      if (!isClosed) emit(LoginError(failure));
    }
  }

  void clearError() {
    if (state is LoginError) emit(const LoginInitial());
  }
}
