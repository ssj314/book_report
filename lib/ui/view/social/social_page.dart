import 'package:book_report/constant/string.dart';
import 'package:book_report/data/model/user_model.dart';
import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/controller/user_controller.dart';
import 'package:book_report/ui/view/social/social_follow_page.dart';
import 'package:book_report/ui/view/social/social_setting_page.dart';
import 'package:book_report/ui/widget/custom_appbar.dart';
import 'package:book_report/ui/widget/custom_dialog.dart';
import 'package:book_report/ui/widget/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../controller/universal_controller.dart';
import '../../widget/custom_clickable_image.dart';
import '../../widget/custom_user_profile.dart';

enum SocialSegment {
  follower, following;
}

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<StatefulWidget> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final controller = Get.find<DataController>();
  final userController = Get.find<UserController>();
  var page = SocialSegment.follower;

  getWidget() {
    switch(page) {
      case SocialSegment.follower:
        if(userController.hasFollower()) {
          return SocialFollowListView(segment: SocialSegment.follower);
        } else {
          return const SocialNotFound(title: "팔로워 목록이 비어있습니다");
        }
      case SocialSegment.following:
        if(userController.hasFollowing()) {
          return SocialFollowListView(segment: SocialSegment.following);
        } else {
          return const SocialNotFound(title: "팔로잉 목록이 비어있습니다");
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: CustomAppBar(
        middle: socialText,
        scrollable: false,
        showDivider: false,
        spare: GestureDetector(
          child: getImage(),
          onTap: () => Get.to(()=> SocialSettingPage()),
        ),
        child: Column(
            children: [
              CupertinoSlidingSegmentedControl<SocialSegment>(
                  groupValue: page,
                  onValueChanged: (SocialSegment? value) => setState(() {
                    page = value ?? SocialSegment.follower;
                  }),
                  children: {
                    SocialSegment.follower: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("팔로워", style: TextStyle(fontSize: CustomFont.small.size)),
                    ),
                    SocialSegment.following: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("팔로잉", style: TextStyle(fontSize: CustomFont.small.size)),
                    )
                  }
              ),
              Expanded(child: Obx(() => getWidget()))
            ]
        )
    ));
  }

  getImage() {
    const double imageSize = 36;
    final user = userController.getUser();
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
              profileImagePath,
              width: imageSize,
              height: imageSize
          )
      );
    }
  }
}

class SocialFollowListView extends StatelessWidget {
  SocialFollowListView({super.key, required this.segment});
  final SocialSegment segment;
  final userController = Get.find<UserController>();
  final List<FollowUser> items = [];

  @override
  Widget build(BuildContext context) {
    if(segment == SocialSegment.follower) {
      items.addAll(userController.getFollower());
    } else {
      items.addAll(userController.getFollowing());
    }
    return ListView.separated(
        itemCount: items.length,
        padding: EdgeInsets.only(
            right: Spacing.small.size,
            left: Spacing.small.size,
            top: Spacing.medium.size,
            bottom: Spacing.medium.size
        ),
        separatorBuilder: (context, index) => Divider(
            color: Colors.transparent, height: Spacing.medium.size
        ),
        itemBuilder: (context, index) => CupertinoButton(
            padding: EdgeInsets.zero,
            child: UserProfile(user: items[index], widget: const SizedBox()),
            onPressed: () => showCupertinoModalPopup(
                context: context,
                builder: (mContext) {
                  if(segment == SocialSegment.follower) {
                    return _followerAction(mContext, index);
                  } else {
                    return _followingAction(mContext, index);
                  }
                }
            )
        )
    );
  }

  _modalContainer({required context, required title, required actions}) {
    return Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: getBottomSpacing()),
        child: CupertinoActionSheet(
            title: Text(title),
            actions: actions,
            cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(dismissText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: CustomFont.caption.size,
                        height: 1
                    )
                )
            )
        )
    );
  }

  _followingAction(BuildContext context, int index)  {
    return _modalContainer(
        context: context,
        title: items[index].getUsername(),
        actions: [
          CupertinoActionSheetAction(
              child: Text(visitLibraryText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: CustomFont.caption.size,
                      color: Colors.blueAccent,
                      height: 1
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => SocialFollowPage(user: items[index]));
              }
          ),
          CupertinoActionSheetAction(
              child: Text(removeFollowText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: CustomFont.caption.size,
                      color: Colors.redAccent,
                      height: 1
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop();
                CustomDialog.showDialog(
                    title: removeFriendConfirmText,
                    context: context,
                    confirmAction: () => userController.removeFollow(index)
                );
              }
          )
        ]
    );
  }

  _followerAction(BuildContext context, int index)  {
    return _modalContainer(
        context: context,
        title: items[index].getUsername(),
        actions: [
          CupertinoActionSheetAction(
              child: Text(visitLibraryText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: CustomFont.caption.size,
                      color: Colors.blueAccent,
                      height: 1
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => SocialFollowPage(user: items[index]));
              }
          ),
          CupertinoActionSheetAction(
              child: Text(followText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: CustomFont.caption.size,
                      color: Colors.blueAccent,
                      height: 1
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
          CupertinoActionSheetAction(
              child: Text(removeFollowText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: CustomFont.caption.size,
                      color: Colors.redAccent,
                      height: 1
                  )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }
          )
        ]
    );
  }
}

class SocialNotFound extends StatelessWidget {
  const SocialNotFound({Key? key, required this.title}) : super(key: key);
  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("images/search_not_found.svg",
                  width: 180,
                  height: 180
              ),
              Divider(height: Spacing.huge.size, color: Colors.transparent),
              Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: CustomFont.body.size
                )
              ),
              Text("새로운 친구를 찾아 추가해보세요",
                  style: TextStyle(
                      fontSize: CustomFont.caption.size
                  )
              )
            ]
        )
    );
  }
}