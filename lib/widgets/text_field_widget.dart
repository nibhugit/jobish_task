import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/string.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.hint,
    this.suffixText,
    this.initialValue,
    this.fontFamilyText,
    this.suffixFontFamilyText,
    this.fontFamilyHint,
    this.suffixIconName,
    this.counterText,
    this.fontWeightText,
    this.suffixFontWeightText,
    this.fontWeightHint,
    this.color,
    this.hintColor,
    this.fieldBorderClr,
    this.focusedBorderColor,
    this.borderColor,
    this.controller,
    this.focusNode,
    this.readOnly = false,
    this.isDense = true,
    this.passwordVisible = false,
    this.autoFocus = false,
    this.expands = false,
    this.textAlign,
    this.textInputType,
    this.maxLines = 1,
    this.maxLength,
    this.onTap,
    this.suffixOnTap,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.textAlignVertical = TextAlignVertical.center,
    this.textCapitalization = TextCapitalization.none,
    this.cursorColor,
    this.prefixIconWidget,
    this.suffixIconWidget,
    this.validator,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.margin,
    this.border,
    this.fontSize,
    this.hintFontSize,
    this.contentPadding,
    this.isTablet = false,
  });

  final String? hint,
      suffixText,
      initialValue,
      fontFamilyText,
      suffixFontFamilyText,
      fontFamilyHint,
      suffixIconName,
      counterText;
  final FontWeight? fontWeightText, suffixFontWeightText, fontWeightHint;
  final Color? color,
      hintColor,
      fieldBorderClr,
      focusedBorderColor,
      borderColor,
      cursorColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly, isDense, passwordVisible, autoFocus, expands, isTablet;
  final TextAlign? textAlign;
  final TextInputType? textInputType;
  final int? maxLines, maxLength;
  final GestureTapCallback? onTap, suffixOnTap;
  final Function(String)? onChanged, onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization? textCapitalization;
  final EdgeInsets? margin, contentPadding;
  final Border? border;
  final Widget? prefixIconWidget, suffixIconWidget;
  final String? Function(String?)? validator;
  final double? fontSize, hintFontSize;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final defaultBgColor = color ?? theme.cardColor;
    final defaultBorderColor = borderColor ?? theme.dividerColor;
    final defaultTextColor = theme.colorScheme.onSurface;
    final defaultHintColor =
        hintColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return Container(
          margin: margin ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: defaultBgColor,
            borderRadius: BorderRadius.circular(10.r),
            border: border ?? Border.all(color: defaultBorderColor),
          ),
          child: TextFormField(
            textAlignVertical: textAlignVertical,
            autofocus: autoFocus,
            inputFormatters:
                inputFormatters ??
                [FilteringTextInputFormatter.deny(RegExp(r'^ +'))],
            textInputAction: textInputAction,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            validator: validator,
            onTap: onTap,
            obscureText: passwordVisible,
            maxLength: maxLength,
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            initialValue: initialValue,
            readOnly: readOnly,
            maxLines: maxLines,
            textAlign: textAlign ?? TextAlign.left,
            keyboardType: textInputType,
            expands: expands,
            style: TextStyle(
              color: defaultTextColor,
              fontSize: 15.sp,
              fontFamily: fontFamilyText ?? kDefaultFontName,
              fontWeight: fontWeightText ?? FontWeight.w500,
            ),
            cursorColor: cursorColor ?? defaultTextColor,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              counterText: counterText ?? '',
              isDense: isDense,
              prefixIcon: (prefixIconWidget != null)
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.r),
                      child: prefixIconWidget,
                    )
                  : null,
              suffixText: suffixText,
              hintText: hint ?? '',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: focusedBorderColor ?? AppColors.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: defaultBorderColor),
              ),
              hintStyle: TextStyle(
                color: defaultHintColor,
                fontSize: 15.sp,
                fontFamily: fontFamilyHint ?? kDefaultFontName,
                fontWeight: fontWeightHint ?? FontWeight.w400,
              ),
              suffixIcon:
                  suffixIconWidget ??
                  (suffixIconName != null
                      ? GestureDetector(
                          onTap: suffixOnTap,
                          child: Padding(
                            padding: EdgeInsets.all(12.r),
                            child: SvgPicture.asset(
                              suffixIconName!,
                              width: 24.r,
                              height: 24.r,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        )
                      : null),
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(horizontal: 15.r, vertical: 14.r),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 0.9.seconds, curve: Curves.easeInOut)
        .moveY(
          begin: 30,
          end: 0,
          duration: 0.7.seconds,
          curve: Curves.easeOutCubic,
        );
  }
}
