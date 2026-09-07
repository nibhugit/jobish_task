import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/string.dart';
import 'package:jobish_task/style/style.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({
    super.key,
    this.text,
    this.color,
    this.fontSize = 14,
    this.fontFamily = kDefaultFontName,
    this.letterSpacing,
    this.textAlign,
    this.onTap,
    this.fontWeight = FontWeight.normal,
    this.textOverflow,
    this.maxLines,
    this.textHeight,
    this.textStyle,
    this.decoration,
  });

  final String? text, fontFamily;
  final Color? color;
  final double? fontSize, letterSpacing, textHeight;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextDecoration? decoration;

  @override
  TextWidgetState createState() => TextWidgetState();
}

class TextWidgetState extends State<TextWidget> {
  @override
  Widget build(final BuildContext context) {
    final effectiveColor =
        widget.color ?? Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: Text(
        widget.text ?? '',
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        softWrap: true,
        overflow: widget.textOverflow,
        style:
            widget.textStyle ??
            AppStyles.text500.copyWith(
              color: effectiveColor,
              height: widget.textHeight,
              fontSize: widget.fontSize ?? 14.r,
              letterSpacing: widget.letterSpacing,
              decoration: widget.decoration,
              fontFamily: widget.fontFamily ?? kDefaultFontName,
              fontWeight: widget.fontWeight,
            ),
      ),
    );
  }
}
