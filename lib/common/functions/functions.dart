import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/misc.dart';
import '../../features/auth/screens/web_login.dart';
import '../../features/landing/screens/screen_splash.dart';

SnackbarController showCustomSnackBar({
  required String message,
  bool isDismissible = true,
  Color backgroundColor = const Color(0xFF303030),
  EdgeInsets margin = const EdgeInsets.only(bottom: 20, left: 4, right: 4),
  EdgeInsets padding = const EdgeInsets.all(16),
  double borderRadius = 2 * messageBorderRadius,
  Color? borderColor,
  double? borderWidth = 1.0,
  String? title,
  Widget? titleText,
  Widget? messageText,
}) {
  return Get.showSnackbar(GetSnackBar(
      title: title,
      titleText: titleText,
      messageText: messageText,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderColor: borderColor,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      duration: snackbarDuration,
      message: message,
      isDismissible: isDismissible));
}

Widget platformHandler() {
  if (kIsWeb) {
    return const WebLoginScreen();
  } else {
    return const ScreenSplash();
  }
}
