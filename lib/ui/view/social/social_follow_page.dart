import 'package:book_report/data/model/user_model.dart';
import 'package:book_report/ui/controller/social/social_friend_controller.dart';
import 'package:book_report/ui/view/social/social_paper_view.dart';
import 'package:book_report/ui/widget/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../widget/custom_clickable_image.dart';

class SocialFollowPage extends StatelessWidget {
  SocialFollowPage({super.key, required this.user});
  final FollowUser user;
  final friendController = Get.put(FriendController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
            child: CustomAppBar(
                scrollable: false,
                middle: "${user.getUsername()}님의 보관함",
                spare: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(Icons.home_filled),
                  onPressed: () => Get.back(),
                ),
                child: FutureBuilder(
                    future: friendController.init(uid: user.getUid(), key: user.getKey()),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CupertinoActivityIndicator());
                      } else if(friendController.hasData()) {
                        return ListView(
                            shrinkWrap: true,
                            children: [
                              FriendBookListView(),
                              Divider(color: Colors.transparent, height: Spacing.large.size),
                              FriendBookContent()
                            ]
                        );
                      } else {
                        return const BookNotFound();
                      }
                    }
                )
            )
        )
    );
  }
}

class BookNotFound extends StatelessWidget {
  const BookNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("images/empty_library.svg",
                  width: 180,
                  height: 180
              ),
              Divider(height: Spacing.medium.size, color: Colors.transparent),
              Text("보관함이 비어있음",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: CustomFont.body.size
                )
              )
            ]
        )
    );
  }
}

class FriendBookContent extends StatelessWidget {
  FriendBookContent({super.key});
  final friendController = Get.find<FriendController>();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          _bookInfo(),
          Divider(color: Colors.transparent, height: Spacing.large.size),
          Obx(() => SocialPaperView(
            itemWidth: 160,
            itemHeight: 200,
            papers: friendController.getPapers(),
          ))
        ]
    );
  }

  _bookInfo() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(CustomRadius.corner.radius)
        ),
        padding: EdgeInsets.all(Spacing.medium.size),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  width: Get.width * 0.5,
                  child: Obx(() => Text(
                      friendController.getTitle(friendController.getIndex()),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 2,
                        fontSize: CustomFont.body.size,
                      )
                  ))
              ),
              Obx(() => Text(
                friendController.getDescription(friendController.getIndex()),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.titleSmall,
              ))
            ]
        )
    );
  }
}

class FriendBookListView extends StatelessWidget {
  final friendController = Get.find<FriendController>();
  final double width = 140;
  FriendBookListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: width * 1.5 + 2 * Spacing.small.size,
        child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.all(Spacing.small.size),
            itemCount: friendController.getLength(),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => VerticalDivider(
              width: Spacing.medium.size,
              color: Colors.transparent,
            ),
            itemBuilder: (context, index) => _friendBookWidget(index)
        )
    );
  }

  _friendBookWidget(index) {
    return Obx(() => AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: friendController.isCurrentIndex(index)?1:0.5,
        child: ClickableImage(
            width: width,
            height: width * 1.5,
            src: friendController.getImage(index),
            onClick: () {
              friendController.setIndex(index);
            }

        )
    ));
  }
}


class PageIndicator extends StatelessWidget {
  PageIndicator({super.key});
  final friendController = Get.find<FriendController>();

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(friendController.getLength(), (index) {
              return Obx(() => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(left: 6, right: 6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: (friendController.isCurrentIndex(index))?
                    Get.theme.colorScheme.primary:
                    Get.theme.colorScheme.outline
                ),
              ));
            }))
        )
    );
  }
}

