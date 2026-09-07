import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/images.dart';
import 'package:jobish_task/widgets/bounce_button.dart';
import 'package:jobish_task/widgets/common_widget.dart';
import 'package:jobish_task/widgets/text_widget.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    this.width,
    this.borderRadius,
    this.height,
    this.text,
    this.onTap,
    this.showLoading = false,
    this.textColor,
    this.verticalPadding,
    this.stringAssetName,
    this.isIcon = false,
    this.isTrue = false,
    this.assetWidth,
    this.assetHeight,
    this.fontSize,
    this.horizontalPadding,
    this.borderColor,
    this.backgroundColor,
    this.borderWidth = 1.0,
    this.iconWidget,
    this.buttonMargin,
    this.isTrailingIcon = false,
    this.isLeadingIcon = false,
    this.isTablet = false,
  });

  final double? width, height;
  final double? borderRadius;
  final String? text;
  final String? stringAssetName;
  final GestureTapCallback? onTap;
  final bool showLoading;
  final bool isIcon;
  final bool isTrue;
  final bool isTrailingIcon;
  final bool isLeadingIcon;
  final bool isTablet;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? fontSize;
  final double? assetWidth;
  final double? assetHeight;
  final double borderWidth;
  final Widget? iconWidget;
  final EdgeInsets? buttonMargin;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(final BuildContext context) => BounceButton(
    onTap: widget.onTap,
    widget: Center(
      child: Container(
        width: widget.isTablet ? 0.5.sw : double.infinity,
        height: 52.h,
        margin: widget.buttonMargin,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? (widget.isTablet ? 10.r : 50.r),
          ),
          border: widget.isTrue
              ? Border.all(
                  color:
                      widget.borderColor ??
                      AppColors.primary.withValues(alpha: 0.10),
                )
              : null,
          boxShadow: widget.isTrue
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(4, 6),
                  ),
                ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding ?? (widget.isTablet ? 8.r : 12.r),
            horizontal:
                widget.horizontalPadding ?? (widget.isTablet ? 10.r : 12.r),
          ),
          child: Center(
            child: widget.showLoading
                ? commonButtonLoader()
                : widget.isIcon
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: widget.isTablet ? 8.r : 10.r,
                        ),
                        child: SvgPicture.asset(
                          widget.stringAssetName!,
                          height:
                              widget.assetHeight ??
                              (widget.isTablet ? 14.r : 20.r),
                          width:
                              widget.assetWidth ??
                              (widget.isTablet ? 14.r : 20.r),
                        ),
                      ),
                      TextWidget(
                        text: widget.text ?? '',
                        fontSize: widget.fontSize ?? 16.r,
                        fontWeight: FontWeight.w700,
                        color: widget.textColor ?? Colors.white,
                      ),
                    ],
                  )
                : widget.isTrailingIcon
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: widget.text ?? '',
                        fontSize: widget.fontSize ?? 16.r,
                        fontWeight: FontWeight.w700,
                        color: widget.textColor ?? Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: widget.isTablet ? 10.r : 14.r,
                        ),
                        child: widget.iconWidget,
                      ),
                    ],
                  )
                : widget.isLeadingIcon
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: widget.isTablet ? 4.r : 5.r),
                          SvgPicture.asset(
                            SVGImages.icBackArrow,
                            width: widget.isTablet ? 14.r : 20.r,
                            height: widget.isTablet ? 14.r : 20.r,
                          ),
                          SizedBox(width: widget.isTablet ? 8.r : 10.r),
                          TextWidget(
                            text: widget.text ?? '',
                            fontSize: widget.fontSize ?? 16.r,
                            fontWeight: FontWeight.w700,
                            color: widget.textColor ?? Colors.white,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: widget.isTablet ? 10.r : 14.r,
                        ),
                        child: SvgPicture.asset(
                          SVGImages.icBackArrow,
                          width: widget.isTablet ? 14.r : 20.r,
                          height: widget.isTablet ? 14.r : 20.r,
                        ),
                      ),
                    ],
                  )
                : TextWidget(
                    text: widget.text ?? '',
                    fontSize: widget.fontSize ?? 16.r,
                    fontWeight: FontWeight.w700,
                    color: widget.textColor ?? Colors.white,
                  ),
          ),
        ),
      ),
    ),
  );
}
