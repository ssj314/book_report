import 'package:book_report/ui/widget/custom_appbar.dart';
import 'package:book_report/ui/widget/custom_indicator.dart';
import 'package:book_report/ui/widget/custom_searchbar.dart';
import 'package:book_report/ui/widget/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../controller/search/search_page_controller.dart';
import '../../controller/user_controller.dart';
import '../../widget/custom_user_profile.dart';


class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final userController = Get.find<UserController>();
  final controller = Get.put(SearchPageController());

  @override
  Widget build(BuildContext context) {
    controller.init(userController.getUid());
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: CustomAppBar(
                middle: "검색",
                scrollable: false,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomSearchBar(onSubmitted: (value) async {
                        Get.dialog(const CustomIndicator(simple: true));
                        await controller.search(value);
                        var open = Get.isDialogOpen;
                        if(open != null && open) Get.back();
                      }),
                      Expanded(child: Obx(() => getWidget()))
                    ]
                )
            )
        )
    );
  }

  getWidget() {
    if(controller.hasData()) {
      return Obx(() => ListView.separated(
          shrinkWrap: true,
          itemCount: controller.getLength(),
          padding: EdgeInsets.only(
              top: Spacing.medium.size,
              bottom: Spacing.medium.size,
              right: Spacing.small.size,
              left: Spacing.small.size
          ),
          separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
              height: 12
          ),
          itemBuilder: (context, index) => UserProfile(
            user: controller.getData(index).simplify(null),
            widget: CupertinoButton(
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () async {
                  var uid = controller.getUid(controller.getData(index).getKey());
                  if(uid != null) {
                    Get.dialog(const CustomIndicator(simple: true));
                    final result = await userController.addFollowing(uid);
                    var open = Get.isDialogOpen;
                    if(open != null && open) Get.back();
                    switch(result) {
                      case UserResult.success:
                        CustomSnackBar.show(
                            title: "성공",
                            message: "친구 요청을 보냈습니다."
                        );
                        break;
                      case UserResult.notFound:
                        CustomSnackBar.show(
                            title: "실패",
                            message: "해당 계정을 찾지 못했습니다."
                        );
                        break;
                      case UserResult.exist:
                        CustomSnackBar.show(
                            title: "실패",
                            message: "이미 팔로우한 계정입니다."
                        );
                        break;
                      case UserResult.sent:
                        CustomSnackBar.show(
                            title: "실패",
                            message: "이미 팔로우 요청을 보냈습니다."
                        );
                        break;
                    }
                  }
                }
            )
          )
      ));
    } else {
      return const SearchNotFound();
    }
  }
}

class SearchNotFound extends StatelessWidget {
  const SearchNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("images/social_not_found.svg",
              width: 180,
              height: 180
          ),
          Divider(height: Spacing.huge.size, color: Colors.transparent),
          Text("검색 결과가 없습니다",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: CustomFont.body.size
            ),
          ),
          Text("태그를 입력하여 새로운 친구를 찾아보세요",
              style: TextStyle(fontSize: CustomFont.caption.size)
          )
        ]
    );
  }
}