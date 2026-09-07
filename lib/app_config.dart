/* == Constant Variables =============== */

import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> kRootNavigatorKey = GlobalKey<NavigatorState>();

class AppConfig {
  /* == Application Details === */

  static String supportEmail = 'support@memelab.in';
  static String supportContactNumber = '+0 1234567890';
  static String supportShop = 'no';

  /* == Environment Configuration ====== */

  static const String appType = 'dev'; // (e.g., ui, dev, prod)

  /* == Localization & Font  ====== */

  static String defaultLanguage = 'en';
  static const int maxPaginationLimit = 100;
  static const int maxPaginationLimit20 = 20;
  static String fcmToken = 'temp_fcm_token';

  static const animationDuration = 100;

  static Locale kDefaultLocale = Locale(AppConfig.defaultLanguage);
  static const kDesignSize = Size(375, 812);
  static const kTabDesignSize = Size(834, 1194);
}

class ApiConfig {
  static const String domain = 'https://dummyjson.com/';
  static const String baseUrl = domain;

  static const String products = 'products';
}
