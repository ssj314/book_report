import 'package:book_report/constant/values.dart';
import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/view/library/paper/paper_page.dart';
import 'package:book_report/ui/widget/custom_clickable_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/string.dart';

class VerticalBookListView extends StatelessWidget {
  VerticalBookListView({super.key});
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataController.getLength(),
      itemBuilder: (context, index) => Dismissible(
          key: Key("$index"),
          background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(bottom: Spacing.medium.size),
              child: const Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              )
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async => await _dismissFunction(index),
          child: VerticalViewItem(index: index)
      )
    ));
  }

  _dismissFunction(int index) async {
    return await showCupertinoDialog(
        context: Get.context!,
        builder: (context) => CupertinoAlertDialog(
            title: const Text(bookDeleteText),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(dismissText),
              ),
              CupertinoDialogAction(
                  child: const Text(
                      confirmText,
                      style: TextStyle(color: Colors.blueAccent)
                  ),
                  onPressed: () => Navigator.of(context).pop(true)
              )
            ]
        )
    ).then((value) async {
      if(value) {
        await dataController.deleteBook(index);
        return true;
      }
      return false;
    });
  }
}

class VerticalViewItem extends StatelessWidget {
  VerticalViewItem({super.key, required this.index});
  final int index;
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => ClickableImage(
                    src: dataController.getImage(index),
                    width: 100,
                    height: 150,
                  )),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: Spacing.medium.size,
                              right: Spacing.medium.size
                          ),
                          child: VerticalBookInfoWidget(index: index)
                      )
                  ),
                  CupertinoButton(
                      onPressed: () => dataController.setInterest(index),
                      padding: EdgeInsets.zero,
                      child: Obx(() => Icon(
                          (dataController.getInterest(index))?
                          Icons.star_rounded:
                          Icons.star_outline_rounded,
                          color: (dataController.getInterest(index))?
                          Theme.of(context).colorScheme.tertiary:
                          Theme.of(context).colorScheme.outline
                      ))
                  )
                ]
            )
        ),
        onPressed: () {
          dataController.setIndex(index);
          Get.to(() => PaperPage(book: dataController.getBook(index)));
        }
    );
  }
}

class VerticalBookInfoWidget extends StatelessWidget {
  final int index;
  const VerticalBookInfoWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataController>();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "독후감",
              style: TextStyle(
                  fontSize: CustomFont.caption.size,
                  fontWeight: FontWeight.w100
              )
          ),
          Text(
              controller.getTitle(index),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: CustomFont.body.size,
                  fontWeight: FontWeight.bold
              )
          ),
          Text(
              controller.getAuthor(index),
              style: TextStyle(
                  fontSize: CustomFont.caption.size,
                  fontFamily: "LINE"
              )
          ),


          Divider(height: Spacing.medium.size, color: Colors.transparent),
          Text(
              controller.getDescription(index),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: CustomFont.small.size)
          )
        ]
    );
  }
}
