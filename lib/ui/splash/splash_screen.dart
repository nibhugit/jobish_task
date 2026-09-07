import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/routes/navigation_routes.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/style.dart';
import 'package:jobish_task/ui/bottom_screen/main_screen.dart';
import 'package:jobish_task/widgets/base_stateful_widget_state.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseStatefulWidgetState<SplashScreen> {
  Timer? _timer;

  @override
  bool useSafeArea = false, extendBodyBehindAppBar = true;

  @override
  void initialize() {
    super.initialize();

    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        navigate(
          enterPage: const MainScreen(),
          navigationType: NavigationType.pushAndClearStack,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget buildBody(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary = textPrimary.withValues(alpha: 0.65);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(22.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                size: 64.r,
                color: AppColors.primary,
              ),
            ),

            24.verticalSpace,

            TextWidget(
              text: 'Jobish Store',
              textStyle: AppStyles.text700.copyWith(
                fontSize: 28.r,
                color: textPrimary,
                letterSpacing: 0.5,
              ),
            ),

            8.verticalSpace,

            TextWidget(
              text: 'Discover Your Favorite Products',
              fontSize: 14.r,
              color: textSecondary,
            ),

            48.verticalSpace,

            SizedBox(
              height: 24.r,
              width: 24.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
