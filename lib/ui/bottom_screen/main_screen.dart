import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/ui/favorite/favorite_screen.dart';
import 'package:jobish_task/ui/home/home_screen.dart';
import 'package:jobish_task/ui/profile/profile_screen.dart';
import 'package:jobish_task/ui/search/search_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.selectedIndex});

  final int? selectedIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  AnimationController? animationController;

  final List<Widget> _widgetOptions = const [
    HomeScreen(),

    SearchScreen(),

    FavoriteScreen(),

    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.selectedIndex ?? 0;

    animationController = BottomSheet.createAnimationController(this);
    animationController?.duration = const Duration(milliseconds: 500);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: _widgetOptions[_selectedIndex],
    bottomNavigationBar: _createBottomNavigationBar(context),
  );

  Widget _createBottomNavigationBar(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBgColor = theme.cardColor;

    return Container(
      height: Platform.isIOS ? 90.h : 70.h,
      decoration: BoxDecoration(
        color: navBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: StylishBottomBar(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        backgroundColor: navBgColor,
        items: [
          buildBottomBarItem(context, Icons.home_outlined, Icons.home),
          buildBottomBarItem(context, Icons.search_outlined, Icons.search),
          buildBottomBarItem(context, Icons.favorite_border, Icons.favorite),
          buildBottomBarItem(context, Icons.person_outline, Icons.person),
        ],
        option: AnimatedBarOptions(),
        currentIndex: _selectedIndex,
        onTap: (final index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  BottomBarItem buildBottomBarItem(
    final BuildContext context,
    final IconData icon,
    final IconData selectedIcon,
  ) => BottomBarItem(
    icon: Icon(
      icon,
      size: 28.r,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
    ),
    selectedIcon: Icon(selectedIcon, size: 28.r, color: AppColors.primary),
    title: const Offstage(),
  );
}
