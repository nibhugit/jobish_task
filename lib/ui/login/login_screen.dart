import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/routes/navigation_routes.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/style.dart';
import 'package:jobish_task/ui/bottom_screen/main_screen.dart';
import 'package:jobish_task/ui/login/cubit/login_cubit.dart';
import 'package:jobish_task/ui/login/states/login_state.dart';
import 'package:jobish_task/widgets/base_stateful_widget_state.dart';
import 'package:jobish_task/widgets/button_widget.dart';
import 'package:jobish_task/widgets/common_widget.dart';
import 'package:jobish_task/widgets/text_field_widget.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStatefulWidgetState<LoginScreen> {
  late final LoginCubit _loginCubit = LoginCubit.get(context);

  @override
  bool useSafeArea = true, extendBodyBehindAppBar = false;

  @override
  void initialize() {
    super.initialize();

    _loginCubit.clearControllers();
  }

  @override
  Widget buildBody(final BuildContext context) =>
      BlocConsumer<LoginCubit, LoginState>(
        listener: (final context, final state) {
          if (state is LoginNavigateState) {
            navigate(enterPage: const MainScreen());
          }
        },
        builder: (final context, final state) => Container(
          width: screenSize.width,
          padding: EdgeInsets.symmetric(horizontal: 20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              40.verticalSpace,

              TextWidget(
                text: 'Please enter your information',
                textStyle: AppStyles.text700.copyWith(
                  fontSize: 20.r,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              24.verticalSpace,

              TextFieldWidget(
                hint: 'Email Address',
                maxLength: 40,
                controller: _loginCubit.emailController,
                textInputType: TextInputType.emailAddress,
              ),

              16.verticalSpace,

              buildPasswordTextField(
                context: context,
                hint: 'Password',
                controller: _loginCubit.passwordController,
                toggleVisibility: _loginCubit.togglePasswordVisibility,
                isVisible: _loginCubit.passwordVisible,
                icon: _loginCubit.passwordIcon,
                textInputAction: TextInputAction.done,
              ),

              12.verticalSpace,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: 1.25,
                        child: Checkbox(
                          value: _loginCubit.rememberMe,
                          activeColor: AppColors.primary,
                          checkColor: AppColors.white,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          side: const BorderSide(color: AppColors.primary),
                          onChanged: (final value) => setState(
                            () => _loginCubit.rememberMe = value ?? false,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      2.horizontalSpace,
                      TextWidget(
                        text: 'Remember Me',
                        textStyle: AppStyles.text400.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14.r,
                        ),
                      ),
                    ],
                  ),
                  TextWidget(
                    text: 'Forgot Password?',
                    textStyle: AppStyles.text700.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14.r,
                    ),
                  ),
                ],
              ),

              24.verticalSpace,

              ButtonWidget(
                text: 'Login',
                onTap: () {
                  _loginCubit.onTapLoginButton();
                },
              ),

              24.verticalSpace,

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(
                      text: "Don't have an account? ",
                      textStyle: AppStyles.text500.copyWith(
                        fontSize: 13.r,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextWidget(
                      text: 'Sign Up',
                      textStyle: AppStyles.text700.copyWith(
                        fontSize: 13.r,
                        color: AppColors.primary,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
