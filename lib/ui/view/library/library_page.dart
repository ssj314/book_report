import 'package:book_report/constant/values.dart';
import 'package:book_report/ui/controller/library/library_page_controller.dart';
import 'package:book_report/ui/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import 'library_search_page.dart';

class LibraryPage extends StatelessWidget {
  LibraryPage({super.key});
  final controller = Get.put(LibraryPageController());
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Obx(() => CustomAppBar(
            middle: "보관함",
            showDivider: true,
            spare: Obx(() => Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    color: controller.toggleButtonColor(),
                    borderRadius: BorderRadius.circular(CustomRadius.small.radius)
                ),
                child: GestureDetector(
                  child: const Center(child: Icon(
                      Icons.format_list_bulleted_rounded, size: 20)),
                  onTap: () {
                    controller.toggle();
                  },
                )
            )),
            scrollable: dataController.hasData(),
            child: Obx(() => getBody())
        )),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CustomRadius.circle.radius)
            ),
            child: const Icon(Icons.add_rounded),
            onPressed: () => Get.to(() => LibrarySearchPage())
        )
    ));
  }

  getBody() {
    if(dataController.hasData()) {
      return Obx(()=> controller.getView());
    } else {
      return const BookNotFound();
    }
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
                ),
              ),
              Text("새로운 책을 등록하여 시작하세요!",
                  style: TextStyle(fontSize: CustomFont.caption.size)
              )
            ]
        )
    );
  }
}