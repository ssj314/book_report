import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/view/library/paper/paper_edit_page.dart';
import 'package:book_report/ui/widget/custom_image_gridview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constant/values.dart';
import '../../../controller/paper/image_controller.dart';

class PaperGridView extends StatelessWidget {
  PaperGridView({super.key});
  final controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: Spacing.small.size,
            right: Spacing.small.size
        ),
        child: Obx(() => MasonryGridView.count(
            mainAxisSpacing: Spacing.tiny.size,
            crossAxisSpacing: Spacing.tiny.size,
            itemCount: controller.getPaperCount(),
            crossAxisCount: getCrossItemCount(context),
            itemBuilder: (context, index) => PaperWidget(index: index)
        ))
    );
  }

  getCrossItemCount(context) {
    final width = MediaQuery.of(context).size.width;
    return (width / 512).floor() + 1;
  }
}

class PaperWidget extends StatelessWidget {
  PaperWidget({super.key, required this.index});
  final int index;
  final controller = Get.find<DataController>();
  final  imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CustomRadius.corner.radius),
                color: controller.getPaperColor(index)
            ),
            child: Container(
                padding: EdgeInsets.all(Spacing.medium.size),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getPaper(index).content.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          //color: Colors.black,
                            fontSize: CustomFont.body.size,
                            fontWeight: FontWeight.bold,
                            color: getTextColor()
                        ),
                      ),
                      Obx(() => getChapter(index)),
                      Divider(height: Spacing.small.size, color: Colors.transparent),
                      Obx(() => ImageGridView(images: imageController.getImagePile(idx: index))),
                      Divider(height: Spacing.small.size, color: Colors.transparent),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("p.${controller.getPaper(index).pageStart} - p.${controller.getPaper(index).pageEnd}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.0,
                                color: getTextColor(),
                                fontSize: CustomFont.caption.size
                            ),
                          ),
                          CustomTime(
                              lastEdit: controller.getPaper(index).lastDate,
                              textColor: getTextColor()
                          )
                        ],
                      )
                    ]
                )
            )
        ),
        onPressed: () {
          imageController.setIndex(index);
          Get.to(() => PaperEditPage(index: index));
        }
    ));
  }

  getTextColor() {
    final color = controller.getPaperColor(index);
    final brightness = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  getChapter(index) {
    String value = controller.getPaper(index).content.chapter;
    if(value.isNotEmpty) {
      return Text(
          value,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: getTextColor(),
            fontSize: Get.theme.textTheme.bodyLarge?.fontSize,
          )
      );
    } else {
      return Container();
    }
  }
}

class CustomTime extends StatelessWidget {
  final String lastEdit;
  final Color textColor;
  const CustomTime({super.key, required this.lastEdit, required this.textColor});


  String subTime() {
    DateTime last;
    try {
      last = DateFormat('yy/MM/dd HH:mm:ss').parse(lastEdit);
    } catch(e) {
      last = DateTime.now();
    }

    Duration diff = DateTime.now().difference(last);
    if(diff.inHours < 24) {
      String meridiem = (last.hour < 12)?"오전":"오후";
      int hour = last.hour - ((last.hour <= 12)?0:12);
      return "$meridiem $hour시 ${last.minute}분";
    } else {
      return DateFormat('yyyy년 MM월 dd일').format(last);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        subTime(),
        textAlign: TextAlign.center,
        style: TextStyle(
          height: 1.0,
          color: textColor,
          fontSize: Get.theme.textTheme.labelMedium?.fontSize
        )
    );
  }
}
