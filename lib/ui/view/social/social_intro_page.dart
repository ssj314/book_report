import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/controller/user_controller.dart';
import 'package:book_report/ui/widget/custom_appbar.dart';
import 'package:book_report/ui/widget/custom_long_button.dart';
import 'package:book_report/ui/widget/custom_user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/string.dart';
import '../../../constant/values.dart';
import '../../../data/model/user_model.dart';
import '../../widget/custom_clickable_image.dart';


class SocialIntroPage extends StatelessWidget {
  SocialIntroPage({super.key});
  final userController = Get.find<UserController>();
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CupertinoNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          border: null,
          middle: Text(aboutText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.0,
                  fontSize: CustomFont.caption.size,
                  color: Theme.of(context).colorScheme.onBackground
              )
          )
        ),
        body: Padding(
            padding: EdgeInsets.all(Spacing.small.size),
            child: Column(children: [
              TextField(
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: userController.getIntro(),
                    border: const OutlineInputBorder()
                ),
                maxLength: 30,
                controller: textController
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                      child: const Text("저장"),
                      onPressed: () async {
                        await userController.setIntro(textController.text);
                        if(context.mounted) Navigator.of(context).pop();
                      })
              )
            ]
          )
        )
    );
  }

}

class SettingProfile extends StatelessWidget {
  SettingProfile({super.key, required this.user});
  final controller = Get.find<UserController>();
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant),
            bottom: BorderSide(width: 1, color: Theme.of(context).colorScheme.outlineVariant)
        )
      ),
      padding: EdgeInsets.all(Spacing.medium.size),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getImage(),
            VerticalDivider(color: Colors.transparent, width: Spacing.small.size),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.getUsername(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: CustomFont.caption.size,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                          height: 1
                      )
                  ),
                  Text("@${user.getKey()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: CustomFont.small.size,
                          color: Theme.of(context).colorScheme.primary,
                          height: 1
                      )
                  )
                ]
            )
          ]
      )
    );
  }


  getImage() {
    const double imageSize = 48;
    if(user.hasImage()) {
      return Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CustomRadius.circle.radius)
          ),
          child: ClickableImage(
            width: imageSize,
            height: imageSize,
            src: user.getImage()!,
          )
      );
    } else {
      final br = Get.mediaQuery.platformBrightness;
      return Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
              color: Colors.white,
              border: (br == Brightness.light)?
              Border.all(color: Get.theme.colorScheme.outline, width: 0.5):null,
              borderRadius: BorderRadius.circular(CustomRadius.circle.radius)
          ),
          child: SvgPicture.asset(
              "images/profile_default.svg",
              width: imageSize,
              height: imageSize
          )
      );
    }
  }
}

