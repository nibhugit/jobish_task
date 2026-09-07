import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobish_task/style/colors.dart';
import 'package:jobish_task/style/string.dart';
import 'package:jobish_task/style/style.dart';
import 'package:jobish_task/widgets/text_widget.dart';
import 'package:toastification/toastification.dart';

String? getErrorMessage(final Object? error) => error is DioException
    ? error.type == DioExceptionType.connectionTimeout
          ? strCouldNotConnectToTheServer
          : error.error is SocketException
          ? strCheckInternetConnection
          : error.response != null && error.response!.data != null
          ? error.response!.data!['message'] as String?
          : strUnKnowError
    : strUnKnowError;

final toastification = Toastification();

void showMessage({required final String message, final String? type}) {
  toastification.dismissAll();
  toastification.show(
    title: TextWidget(
      text: message,
      textStyle: AppStyles.text600.copyWith(fontSize: 12.r),
      maxLines: 2,
    ),
    type: type == 'success'
        ? ToastificationType.success
        : ToastificationType.error,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 2),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    borderSide: const BorderSide(width: 0),
    animationDuration: const Duration(milliseconds: 400),
    primaryColor: AppColors.black,
    backgroundColor: type == 'success' ? AppColors.success : AppColors.error,
    foregroundColor: AppColors.black,
    showProgressBar: false,
    closeButton: ToastCloseButton(
      showType: CloseButtonShowType.onHover,
      buttonBuilder: (final context, final onClose) => OutlinedButton.icon(
        onPressed: onClose,
        icon: const Icon(Icons.close, size: 20),
        label: const Offstage(),
      ),
    ),
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
  );
}

/* == System UI ================================================ */

void setCustomSystemUIOverlayStyle({
  final Color? statusBarColor, // Background color of the status bar
  final Brightness?
  statusBarBrightness, // Controls status bar text brightness (iOS)
  final Brightness?
  statusBarIconBrightness, // Controls status bar icons brightness (Android)
  final Color?
  systemNavigationBarColor, // Background color of the navigation bar
  final Brightness?
  systemNavigationBarIconBrightness, // Icons color of the navigation bar
  final Color?
  systemNavigationBarDividerColor, // Color of the divider line on the navigation bar
  final bool?
  systemStatusBarContrastEnforced, // Whether to enforce contrast for the status bar
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent,
      statusBarBrightness: statusBarBrightness ?? Brightness.light,
      statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
      systemNavigationBarColor: systemNavigationBarColor ?? Colors.white,
      systemNavigationBarIconBrightness:
          systemNavigationBarIconBrightness ?? Brightness.dark,
      systemNavigationBarDividerColor:
          systemNavigationBarDividerColor ?? Colors.white,
      systemStatusBarContrastEnforced: systemStatusBarContrastEnforced ?? false,
    ),
  );
}

/* == Log Generator ================================================ */
void logError(final Object error, final StackTrace? stackTrace) {
  final errorMessage = _formatErrorMessage(error, stackTrace);
  debugPrint(errorMessage);
}

String _formatErrorMessage(final Object error, final StackTrace? stackTrace) {
  final stackTraceMessage = stackTrace != null
      ? stackTrace.toString()
      : 'No stack trace available';
  return '''
    ========================= ERROR =========================
    Error: $error
    StackTrace: 
    $stackTraceMessage
    ==========================================================
    ''';
}
