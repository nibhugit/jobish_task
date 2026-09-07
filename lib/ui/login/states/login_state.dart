abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginLoadingState extends LoginState {}

class SetPasswordVisibilityState extends LoginState {}

class SetRememberMeState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginNavigateState extends LoginState {}

class LoginErrorState extends LoginState {
  LoginErrorState(this.message);

  final String message;
}
