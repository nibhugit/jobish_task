import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder<void> {
  SlideRoute({required this.page})
    : super(
        pageBuilder: (final context, final animation, final secondaryAnimation) => page,
        opaque: false,
        transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
      );

  final Widget page;
}
