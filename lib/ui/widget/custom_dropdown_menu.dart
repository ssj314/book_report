import 'dart:async';

import 'package:book_report/constant/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownController extends GetxController {
  final items = <CustomDropdownItem>[].obs;
  final overlay = Rx<OverlayEntry?>(null);
  final widgetPosition = Offset.zero.obs;
  final widgetSize = (0.0).obs;
  final isOpen = false.obs;
  final clickIndex = (-1).obs;
  final key = GlobalKey().obs;
  final double overlayWidth = 240;
  final double overlayHeight = 42;

  setItems(dynamic value) {
    items(value);
    items.refresh();
  }

  GlobalKey getKey() => key.value;
  void setIndex(int index) => clickIndex.value = index;

  void open() {
    if(isOpen.value) {
      close();
    } else {
      getButton();
      overlay.value = getOverlay();
      Overlay.of(Get.overlayContext!).insert(overlay.value!);
      isOpen.value = true;
    }
  }

  close() {
    overlay.value!.remove();
    isOpen.value = false;
  }

  void isMenuOpened() => isOpen.value;
  void getButton() {
    final RenderBox box = key.value.currentContext!.findRenderObject() as RenderBox;
    widgetPosition(box.localToGlobal(Offset.zero));
    widgetSize.value = box.size.width;
  }

  OverlayEntry getOverlay() {
    return OverlayEntry(builder: (context) => Stack(
      children: [
        Positioned.fill(child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(color: Colors.black.withOpacity(0.5)),
          onTap: () {
            if(isOpen.value) close();
          }
        )),
        Positioned(
            top: widgetPosition.value.dy + widgetSize.value * 1.5,
            left: widgetPosition.value.dx - overlayWidth + widgetSize.value,
            width: overlayWidth,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(CustomRadius.small.radius),
                child: Material(
                    child: Obx(() => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = items[index];
                          return GestureDetector(
                              onTap: () {
                                if(isOpen.value) close();
                                item.onClick();
                              },
                              onTapDown: (_) => setIndex(index),
                              onTapUp: (_) => setIndex(-1),
                              onPanEnd: (_) => setIndex(-1),
                              child: Obx(() => Container(
                                  width: overlayWidth,
                                  height: overlayHeight,
                                  color: (index == clickIndex.value)?
                                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5):
                                  Theme.of(context).colorScheme.surfaceVariant,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(Spacing.tiny.size),
                                  child: item.child
                              ))
                          );
                        },
                        separatorBuilder: (_, __) => Divider(
                          thickness: 0.5,
                          height: 1,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        itemCount: items.length
                    ))
                )
            )
        )
      ])
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  CustomDropdownButton({super.key, required this.items});
  final controller = Get.put(CustomDropdownController());
  final List<CustomDropdownItem> items;

  @override
  Widget build(BuildContext context) {
    controller.setItems(items);
    return CupertinoButton(
        key: controller.getKey(),
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(CustomRadius.circle.radius)
          ),
          child: const Icon(Icons.more_horiz_rounded)
        ),
        onPressed: () => controller.open()
    );
  }
}

class CustomDropdownItem {
  final Function() onClick;
  final Widget child;
  CustomDropdownItem({required this.onClick, required this.child});
}
