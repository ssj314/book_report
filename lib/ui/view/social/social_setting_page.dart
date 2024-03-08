import 'package:book_report/main.dart';
import 'package:book_report/ui/controller/user_controller.dart';
import 'package:book_report/ui/view/social/social_intro_page.dart';
import 'package:book_report/ui/widget/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/string.dart';
import '../../../constant/values.dart';
import '../../../data/model/user_model.dart';
import '../../widget/custom_clickable_image.dart';


class SocialSettingPage extends StatelessWidget {
  SocialSettingPage({super.key});
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: Theme.of(context).colorScheme.background,
          middle: Text(settingText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.0,
                  fontSize: CustomFont.caption.size,
                  color: Theme.of(context).colorScheme.onBackground
              )
          )
        ),
        body: ListView(
            children: [
              SettingProfile(user: userController.getUser()),
              CupertinoButton(child: const Text(aboutText),
                  onPressed: () => Get.to(() => SocialIntroPage())
              ),
              const Divider(),
              CupertinoButton(
                  child: const Text("로그아웃", style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    try {
                      userController.logout();
                      Get.offAll(() => MainPage());
                    } catch(e) {
                      CustomSnackBar.show(title: "실패", message: "다시 시도해보세요");
                    }
                  }
              ),
              CupertinoButton(
                  child: const Text("회원 탈퇴", style: TextStyle(color: Colors.red)),
                  onPressed: () {

                  }
              )
            ]
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

