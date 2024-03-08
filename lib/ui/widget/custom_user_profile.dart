
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constant/values.dart';
import '../../data/model/user_model.dart';
import '../controller/user_controller.dart';
import 'custom_clickable_image.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
    required this.user,
    required this.widget
  });
  final FollowUser user;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _UserProfile(user: user)),
      widget
    ]);
  }
}

class _UserProfile extends StatelessWidget {
  _UserProfile({required this.user});
  final controller = Get.find<UserController>();
  final FollowUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getImage(),
          VerticalDivider(color: Colors.transparent, width: Spacing.small.size),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text("  @${user.getKey()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: CustomFont.small.size,
                              color: Theme.of(context).colorScheme.primary,
                              height: 1
                          )
                      )
                    ]
                ),
                Divider(color: Colors.transparent, height: Spacing.tiny.size),
                Text(user.hasIntro()?user.getIntro()!:"#",
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        fontSize: CustomFont.small.size,
                        color: Theme.of(context).colorScheme.outline,
                        height: 1
                    )
                )
              ]
          )
        ]
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
            src: user.getImage()!
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
