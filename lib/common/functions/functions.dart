import 'package:get/get.dart';

import '../../core/misc.dart';

SnackbarController showCustomSnackBar({required String message}) {
  return Get.showSnackbar(GetSnackBar(
    duration: snackbarDuration,
    message: message,
  ));
}
