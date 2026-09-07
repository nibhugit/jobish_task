import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/widgets/text_field_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget commonLoader({final double? size, final Color? color}) => Center(
  child: LoadingAnimationWidget.hexagonDots(
    color: color ?? AppColors.white,
    size: size ?? 35.r,
  ),
);

Widget commonButtonLoader({final double? size, final Color? color}) => Center(
  child: LoadingAnimationWidget.staggeredDotsWave(
    color: color ?? AppColors.white,
    size: size ?? 25.r,
  ),
);

Widget buildPasswordTextField({
  required final BuildContext context,
  required final String hint,
  required final TextEditingController controller,
  required final Function() toggleVisibility,
  required final bool isVisible,
  required final String icon,
  required final TextInputAction textInputAction,
  final bool isTablet = false,
}) => TextFieldWidget(
  hint: hint,
  maxLength: 20,
  controller: controller,
  textInputType: TextInputType.text,
  textInputAction: textInputAction,
  passwordVisible: !isVisible,
  isTablet: isTablet,
  suffixIconWidget: GestureDetector(
    onTap: toggleVisibility,
    child: Padding(
      padding: EdgeInsets.all(12.r),
      child: SvgPicture.asset(
        icon,
        width: 24.r,
        height: 24.r,
        colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
      ),
    ),
  ),
);
