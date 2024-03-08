import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../constant/values.dart';

class CustomSnackBar {
  CustomSnackBar.show({
    required String title,
    required String message,
    int millisecond = 2000,
    SnackPosition snackPosition = SnackPosition.TOP
  }) {
    if(!Get.isSnackbarOpen) {
      Get.snackbar(
        title,
        message,
        duration: Duration(milliseconds: millisecond),
        snackPosition: snackPosition,
        margin: EdgeInsets.all(Spacing.small.size)
      );
    }
  }
}