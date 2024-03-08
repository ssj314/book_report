import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/view/library/paper/paper_page.dart';
import 'package:book_report/ui/widget/custom_clickable_image.dart';
import 'package:book_report/ui/widget/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/string.dart';
import '../../../constant/values.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/custom_indicator.dart';

class HorizontalViewController extends GetxController {
  final Rx<int> width = 0.obs;
  final clicked = false.obs;

  setWidth(int value) => width.value = value;

  double getWidth() => width.value.toDouble();

  getHeight() => getWidth() * 1.5;

  setClick(value) => clicked.value = value;
  getClick() => clicked.value;

  getOpacity(isCurrent) => isCurrent?1.0:0.25;

  getPageIndicatorColor(interest, isCurrent){

    if(!isCurrent) {
      return Get.theme.colorScheme.outline;
    } else if (interest) {
      return Get.theme.colorScheme.tertiary;
    } else {
      return Get.theme.colorScheme.primary;
    }
  }

  getIndicator(interest, current) {
    if(interest) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 3, right: 3),
        child: Icon(
          Icons.star_rounded,
          color: getPageIndicatorColor(interest, current),
          size: 12
        ),
      );
    } else {
      return Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.only(left: 6, right: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: getPageIndicatorColor(interest, current)
        ),
      );
    }
  }
}

class HorizontalBookListView extends StatelessWidget {
  final int itemWidth;
  HorizontalBookListView({super.key, required this.itemWidth});

  final controller = Get.put(HorizontalViewController());
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    controller.setWidth(itemWidth);
    return Wrap(children: [
      SizedBox(
          height: itemWidth * 1.75,
          width: double.infinity,
          child: RotatedBox(
              quarterTurns: -1,
              child: Obx(() => ListWheelScrollView.useDelegate(
                  diameterRatio: itemWidth.toDouble(),
                  physics: const FixedExtentScrollPhysics(),
                  itemExtent: itemWidth + Spacing.small.size * 2,
                  controller: dataController.getController(),
                  onSelectedItemChanged: (value) => dataController.setIndex(value),
                  childDelegate: ListWheelChildBuilderDelegate(
                      childCount: dataController.getLength(),
                      builder: (context, index) => Obx(() => RotatedBox(
                          quarterTurns: 1,
                          child: AnimatedOpacity(
                              opacity: controller.getOpacity(
                                  dataController.isCurrentIndex(index)
                              ),
                              duration: const Duration(milliseconds: 250),
                              child: _dismissible(index)
                          )
                      ))
                  ))
              )
          )
      ),
      Divider(height: Spacing.tiny.size, color: Colors.transparent),
      PageIndicator(),
      Divider(height: Spacing.medium.size, color: Colors.transparent),
      Obx(() => HorizontalInfoWidget(index: dataController.getIndex())),
    ]);
  }

  _dismissible(int index) {
    if(index == dataController.getIndex()) {
      return Dismissible(
          key: Key("$index"),
          background: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: Spacing.medium.size),
              child: const Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              )
          ),
          direction: DismissDirection.up,
          child: Center(child: HorizontalViewBookWidget(index: index)),
          confirmDismiss: (_) async {
            return await showCupertinoDialog(
                context: Get.context!,
                builder: (context) => CupertinoAlertDialog(
                    title: const Text(bookDeleteText),
                    actions: [
                      CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(dismissText)
                      ),
                      CupertinoDialogAction(
                          child: const Text(confirmText,
                              style: TextStyle(color: Colors.blueAccent)
                          ),
                          onPressed: () => Navigator.of(context).pop(true)
                      )
                    ]
                )
            ).then((value) async {
              if(value) {
                await dataController.deleteBook(index);
                dataController.jumpToItem();
              }
              return false;
            });
          }
      );
    } else {
      return HorizontalViewBookWidget(index: index);
    }

  }
}

class HorizontalInfoWidget extends StatelessWidget {
  HorizontalInfoWidget({super.key, required this.index});
  final int index;
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(CustomRadius.corner.radius)
        ),
        padding: EdgeInsets.all(Spacing.medium.size),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("책 소개", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: CustomFont.body.size,
              )),
              Divider(
                height: Spacing.tiny.size,
                color: Colors.transparent,
              ),
              Obx(() => Text(
                  dataController.getDescription(index),
                  maxLines: 3,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: CustomFont.caption.size
                  )
              ))
            ]
        )
    );
  }
}

class PageIndicator extends StatelessWidget {
  PageIndicator({super.key});
  final controller = Get.find<HorizontalViewController>();
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(dataController.getLength(), (index) {
              return Obx(() => controller.getIndicator(
                  dataController.getInterest(index),
                  dataController.isCurrentIndex(index)
              ));
            }))
        )
    );
  }
}

class HorizontalViewBookWidget extends StatelessWidget {
  final int index;
  HorizontalViewBookWidget({super.key, required this.index});
  final controller = Get.find<HorizontalViewController>();
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: controller.getWidth(),
        height: controller.getHeight(),
        child: ClickableImage(
            width: controller.getWidth(),
            height: controller.getHeight(),
            src: dataController.getImage(index),
            onClick: () {
              if(dataController.getIndex() == index) {
                Get.to(() => PaperPage(book: dataController.getBook(index)));
              }
            }
        )
    );
  }
}
