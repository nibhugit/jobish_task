import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobish_task/app_config.dart' show kRootNavigatorKey;
import 'package:jobish_task/routes/slide_route.dart';

enum NavigationType {
  pushAndClearStack,
  pushReplacement,
  push,
  pushForResult,
  goBack,
}

void navigate({
  final Widget? enterPage,
  final bool shouldUseRootNavigator = false,
  final NavigationType navigationType = NavigationType.push,
  final ValueChanged<Object?>? onResult,
  final Object? popData,
}) {
  final context = kRootNavigatorKey.currentContext!;
  final navigator = Navigator.of(
    context,
    rootNavigator: shouldUseRootNavigator,
  );

  // Hide any snack bars and dismiss keyboard
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  FocusScope.of(context).requestFocus(FocusNode());

  switch (navigationType) {
    case NavigationType.pushAndClearStack:
      navigator.pushAndRemoveUntil(
        SlideRoute(page: enterPage!),
        (final _) => false,
      );
    case NavigationType.pushReplacement:
      navigator.pushReplacement(SlideRoute(page: enterPage!));
    case NavigationType.pushForResult:
      unawaited(
        navigator.push<Object?>(SlideRoute(page: enterPage!)).then((
          final value,
        ) {
          if (onResult != null) onResult(value);
        }),
      );
    case NavigationType.push:
      navigator.push<Object?>(SlideRoute(page: enterPage!)).then((final value) {
        if (onResult != null) onResult(value);
      });
    case NavigationType.goBack:
      FocusScope.of(context).unfocus();
      Navigator.pop(context, popData);
  }
}
