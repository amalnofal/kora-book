part of 'login_cubit.dart';

sealed class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginError extends LoginState {
  const LoginError(this.failure);

  final AuthFailure failure;
}
