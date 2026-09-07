import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobish_task/style/images.dart';
import 'package:jobish_task/ui/login/states/login_state.dart';
import 'package:jobish_task/utils/validation_utils.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(final BuildContext context) => BlocProvider.of(context);

  bool rememberMe = false;

  late final emailController = TextEditingController(text: '');
  late final passwordController = TextEditingController(text: '');

  bool passwordVisible = false;
  String passwordIcon = SVGImages.icHidePassword;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    passwordIcon = passwordVisible
        ? SVGImages.icShowPassword
        : SVGImages.icHidePassword;
    emit(SetPasswordVisibilityState());
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    emit(SetRememberMeState());
  }

  Future<void> onTapLoginButton() async {
    if (ValidationUtils.isEmailValid(emailController.text) &&
        ValidationUtils.isPasswordValid(passwordController.text)) {
      emit(LoginNavigateState());
    }
  }
}
