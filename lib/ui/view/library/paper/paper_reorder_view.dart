import 'package:book_report/ui/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constant/values.dart';

class PaperReorderView extends StatelessWidget {
  PaperReorderView({super.key});
  final controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(Spacing.small.size),
        child: Obx(() => ReorderableListView(
            shrinkWrap: true,
            children: List.generate(
                controller.getPaperCount(),
                    (index) {
                  return Container(
                      key: Key("$index"),
                      margin: EdgeInsets.only(
                        top: Spacing.tiny.size,
                        bottom: Spacing.tiny.size
                      ),
                      padding: EdgeInsets.all(Spacing.tiny.size),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(CustomRadius.corner.radius),
                          color: Theme.of(context).colorScheme.tertiaryContainer
                      ),
                      child: ListTile(title: PaperWidget(index: index))
                  );
              }
            ),
            onReorder: (from, to) {
              if(from != to) controller.switchPaper(from, to);
            }
        ))
    );
  }
}

class PaperWidget extends StatelessWidget {
  PaperWidget({super.key, required this.index});
  final int index;
  final controller = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
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
                fontWeight: FontWeight.bold
            ),
          ),
          Obx(() => getChapter(index)),
          Divider(height: Spacing.small.size, color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("p.${controller.getPaper(index).pageStart} - p.${controller.getPaper(index).pageEnd}",
                textAlign: TextAlign.center,
                style: const TextStyle(height: 1.0),
              ),
              CustomTime(lastEdit: controller.getPaper(index).lastDate)
            ],
          )
        ]
    ));
  }

  getChapter(index) {
    String value = controller.getPaper(index).content.chapter;
    if(value.isNotEmpty) {
      return Text(
          value,
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            //color: Colors.black,
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
  const CustomTime({super.key, required this.lastEdit});

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
          fontSize: Get.theme.textTheme.labelMedium?.fontSize,
        )
    );
  }
}