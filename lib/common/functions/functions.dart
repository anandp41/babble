import 'package:babble/features/landing/screens/screen_splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/misc.dart';
import '../../features/auth/screens/web_login.dart';

SnackbarController showCustomSnackBar({required String message}) {
  return Get.showSnackbar(GetSnackBar(
    duration: snackbarDuration,
    message: message,
  ));
}

Widget platformHandler() {
  if (kIsWeb) {
    return const WebLoginScreen();
  } else {
    return const ScreenSplash();
  }
}
