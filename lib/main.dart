import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/api/dio_helper.dart';
import 'package:jobish_task/app_config.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/string.dart';
import 'package:jobish_task/style/style.dart';
import 'package:jobish_task/ui/favorite/cubit/favorite_cubit.dart';
import 'package:jobish_task/ui/home/cubit/home_cubit.dart';
import 'package:jobish_task/ui/login/cubit/login_cubit.dart';
import 'package:jobish_task/ui/login/login_screen.dart';
import 'package:jobish_task/ui/splash/splash_screen.dart';
import 'package:jobish_task/ui/theme/cubit/theme_cubit.dart';
import 'package:jobish_task/ui/theme/states/theme_state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await DioHelper.init();
  // await SharedPreferenceUtil.getInstance();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  OverlaySupportEntry? entry;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    entry?.dismiss();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ScreenUtilInit(
    minTextAdapt: true,
    useInheritedMediaQuery: true,
    ensureScreenSize: true,
    splitScreenMode: true,
    designSize: AppConfig.kDesignSize,
    builder: (final _, final _) => ToastificationWrapper(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (final _) => ThemeCubit()),
          BlocProvider(create: (final _) => FavoriteCubit()),
          BlocProvider(create: (final _) => LoginCubit()),
          BlocProvider(create: (final _) => HomeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (final context, final themeState) {
            final isDark =
                themeState.themeMode == ThemeMode.dark ||
                (themeState.themeMode == ThemeMode.system &&
                    MediaQuery.platformBrightnessOf(context) ==
                        Brightness.dark);

            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: isDark
                    ? Brightness.dark
                    : Brightness.light,
                statusBarIconBrightness: isDark
                    ? Brightness.light
                    : Brightness.dark,
                systemNavigationBarColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.white,
                systemNavigationBarIconBrightness: isDark
                    ? Brightness.light
                    : Brightness.dark,
                systemNavigationBarDividerColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.white,
                systemStatusBarContrastEnforced: false,
              ),
            );

            return GestureDetector(
              onTap: () => primaryFocus?.unfocus(),
              child: OverlaySupport.global(
                child: MaterialApp(
                  builder: (final context, final child) => Directionality(
                    textDirection: TextDirection.ltr,
                    child: MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: child!,
                    ),
                  ),
                  navigatorKey: kRootNavigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: kAppName,
                  theme: AppStyles.lightTheme,
                  darkTheme: AppStyles.darkTheme,
                  themeMode: themeState.themeMode,
                  home: const SplashScreen(),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
