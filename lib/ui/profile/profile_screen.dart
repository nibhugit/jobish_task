import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/routes/navigation_routes.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/ui/login/login_screen.dart';
import 'package:jobish_task/ui/theme/cubit/theme_cubit.dart';
import 'package:jobish_task/ui/theme/states/theme_state.dart';
import 'package:jobish_task/widgets/base_stateful_widget_state.dart';
import 'package:jobish_task/widgets/common_appbar.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseStatefulWidgetState<ProfileScreen> {
  @override
  bool useSafeArea = true, extendBodyBehindAppBar = false;

  @override
  PreferredSizeWidget? buildAppBar(final BuildContext context) =>
      const CommonAppBar(title: 'Profile', shouldShowBackButton: false);

  @override
  Widget buildBody(final BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textPrimaryColor = theme.colorScheme.onSurface;
    final textSecondaryColor = textPrimaryColor.withValues(alpha: 0.6);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 45.r,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50.r,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: cardColor, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 14.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                TextWidget(
                  text: 'Nirbhay Thakkar',
                  fontSize: 18.r,
                  fontWeight: FontWeight.w700,
                  color: textPrimaryColor,
                ),
                4.verticalSpace,
                TextWidget(
                  text: 'nirbhay@example.com',
                  fontSize: 13.r,
                  color: textSecondaryColor,
                ),
              ],
            ),
          ),

          24.verticalSpace,

          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (final context, final themeState) {
                    final isDarkMode =
                        themeState.themeMode == ThemeMode.dark ||
                        (themeState.themeMode == ThemeMode.system &&
                            MediaQuery.platformBrightnessOf(context) ==
                                Brightness.dark);

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 4.r,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: AppColors.primary,
                          size: 22.r,
                        ),
                      ),
                      title: TextWidget(
                        text: 'Dark Mode',
                        fontSize: 15.r,
                        fontWeight: FontWeight.w600,
                        color: textPrimaryColor,
                      ),
                      subtitle: TextWidget(
                        text: isDarkMode ? 'Active' : 'Disabled',
                        fontSize: 12.r,
                        color: textSecondaryColor,
                      ),
                      trailing: Switch.adaptive(
                        value: isDarkMode,
                        activeColor: AppColors.primary,
                        onChanged: (final value) {
                          ThemeCubit.get(context).setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          16.verticalSpace,

          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  textPrimaryColor: textPrimaryColor,
                  onTap: () {},
                ),
                Divider(height: 1, color: theme.dividerColor),
                _buildMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  textPrimaryColor: textPrimaryColor,
                  onTap: () {},
                ),
                Divider(height: 1, color: theme.dividerColor),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Security',
                  textPrimaryColor: textPrimaryColor,
                  onTap: () {},
                ),
                Divider(height: 1, color: theme.dividerColor),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  textPrimaryColor: textPrimaryColor,
                  onTap: () {},
                ),
              ],
            ),
          ),

          24.verticalSpace,

          // Logout Button
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                navigate(
                  enterPage: const LoginScreen(),
                  navigationType: NavigationType.pushReplacement,
                );
              },
              leading: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 22.r,
                ),
              ),
              title: TextWidget(
                text: 'Logout',
                fontSize: 15.r,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required final IconData icon,
    required final String title,
    required final Color textPrimaryColor,
    required final VoidCallback onTap,
  }) => ListTile(
    onTap: onTap,
    leading: Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 22.r),
    ),
    title: TextWidget(
      text: title,
      fontSize: 15.r,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    ),
    trailing: Icon(
      Icons.chevron_right_rounded,
      color: textPrimaryColor.withValues(alpha: 0.4),
    ),
  );
}
