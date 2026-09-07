import 'package:flutter/material.dart';

class ThemeState {
  const ThemeState({this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({final ThemeMode? themeMode}) =>
      ThemeState(themeMode: themeMode ?? this.themeMode);
}
