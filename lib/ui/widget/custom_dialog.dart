import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  CustomDialog.showDialog({
    bool only = false,
    required String title,
    String? content,
    required BuildContext context,
    required Function() confirmAction
  }) {
    final widgets = <Widget>[];
    if(only) {
      widgets.add(CupertinoDialogAction(
            child: const Text("확인",
                style: TextStyle(
                    color: Colors.blueAccent
                )
            ),
            onPressed: () {
              Navigator.of(context).pop();
              confirmAction();
            }
        )
        );
    } else {
      widgets.addAll([
        CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text("취소"),
            onPressed: () {
              Navigator.of(context).pop();

            }
        ),
        CupertinoDialogAction(
            child: const Text("확인",
                style: TextStyle(
                    color: Colors.blueAccent
                )
            ),
            onPressed: () {
              Navigator.of(context).pop();
              confirmAction();
            }
        )
      ]);
    }

    if(content == null) {
      Get.dialog(CupertinoAlertDialog(
          title: Text(title),
          actions: widgets,
      ));
    } else {
      Get.dialog(CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: widgets
      ));
    }
  }
}