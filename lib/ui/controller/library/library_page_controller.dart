import '/ui/view/library/library_horizontal_view.dart';
import '/ui/view/library/library_vertical_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LibraryPageController extends GetxController {
  var listMode = false.obs;

  toggle() {
    if(listMode.value) {
      listMode.value = false;
    } else {
      listMode.value = true;
    }
  }

  toggleButtonColor() {
    if(listMode.value) {
      return Get.theme.colorScheme.primaryContainer;
    } else {
      return Colors.transparent;
    }
  }

  getView() {
    if(listMode.value) {
      return VerticalBookListView();
    } else {
      return HorizontalBookListView(itemWidth: 180);
    }
  }
}

