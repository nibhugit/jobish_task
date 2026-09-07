import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobish_task/routes/navigation_routes.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.shouldShowBackButton = true,
    this.bottom,
    this.isPrefixIcon,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.prefixIcon,
    this.leadingColor,
    this.prefixIconName,
    this.titleWidget,
    this.titleColor,
    this.toolbarHeight,
    this.onTapPrefix,
    this.onPressBack,
    this.automaticallyImplyLeading = false,
    this.leading,
    this.flexibleSpace,
    this.statusBarColor,
    this.prefixWidget,
    this.backgroundColor,
    this.onTapAction,
    this.isCenterTitle = true,
  });

  final String? title;
  final String? subtitle;
  final String? prefixIconName, prefixIcon;
  final bool? shouldShowBackButton;
  final PreferredSizeWidget? bottom;
  final bool? isPrefixIcon;
  final Color? leadingColor;
  final Widget? leading;
  final Widget? prefixWidget;
  final Widget? titleWidget;
  final Widget? flexibleSpace;
  final bool automaticallyImplyLeading;
  final GestureTapCallback? onTapPrefix;
  final GestureTapCallback? onPressBack;
  final Color? statusBarColor, backgroundColor, titleColor;
  final GestureTapCallback? onTapAction;
  final double? toolbarHeight;
  final bool isCenterTitle; // NEW
  final Brightness? statusBarIconBrightness;
  final Brightness? statusBarBrightness;

  double get _resolvedToolbarHeight {
    if (toolbarHeight != null) return toolbarHeight!;
    return subtitle != null ? 60.r : 50.r;
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaultBg =
        backgroundColor ??
        theme.appBarTheme.backgroundColor ??
        theme.scaffoldBackgroundColor;
    final defaultTitleColor = titleColor ?? theme.colorScheme.onSurface;
    final defaultLeadingColor = leadingColor ?? theme.colorScheme.onSurface;

    return AppBar(
      flexibleSpace: flexibleSpace,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: defaultBg,
        statusBarIconBrightness:
            statusBarIconBrightness ??
            (isDark ? Brightness.light : Brightness.dark),
        systemNavigationBarColor: defaultBg,
        statusBarBrightness:
            statusBarBrightness ??
            (isDark ? Brightness.dark : Brightness.light),
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      backgroundColor: defaultBg,
      elevation: 0.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: isCenterTitle,
      title: Padding(
        padding: EdgeInsets.only(bottom: 3.r),
        child:
            titleWidget ??
            (subtitle != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: isCenterTitle
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: title,
                        color: defaultTitleColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.r,
                      ),
                      TextWidget(
                        text: subtitle,
                        color: defaultTitleColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.r,
                      ),
                    ],
                  )
                : TextWidget(
                    text: title,
                    color: defaultTitleColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.r,
                  )),
      ),
      leading: shouldShowBackButton ?? true
          ? leading ??
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      onPressBack ??
                      () {
                        if (Navigator.canPop(context)) {
                          navigate(navigationType: NavigationType.goBack);
                        }
                      },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.r, right: 8.r),
                    child: Icon(Icons.arrow_back, color: defaultLeadingColor),
                  ),
                )
          : null,
      leadingWidth: 50.w,
      actions: [
        prefixIconName != null
            ? Container(
                margin: EdgeInsets.only(right: 15.r),
                padding: const EdgeInsets.only(right: 5, left: 5, top: 25),
                child: TextWidget(
                  text: prefixIconName,
                  fontSize: 14.r,
                  onTap: onTapAction,
                ),
              )
            : prefixIcon != null
            ? GestureDetector(
                onTap: onTapAction,
                child: Container(
                  margin: const EdgeInsets.only(right: 22),
                  child: SvgPicture.asset(prefixIcon!),
                ),
              )
            : prefixWidget ?? const SizedBox.shrink(),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_resolvedToolbarHeight);
}
