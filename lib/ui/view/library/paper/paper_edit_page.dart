import 'dart:async';

import 'package:book_report/data/model/image_model.dart';
import 'package:book_report/ui/controller/user_controller.dart';
import 'package:book_report/ui/view/library/paper/paper_quill_widget.dart';
import 'package:book_report/ui/widget/custom_color_picker.dart';
import 'package:book_report/ui/widget/custom_indicator.dart';
import 'package:book_report/ui/widget/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';

import 'package:book_report/data/model/user_access_enum.dart';
import 'package:book_report/ui/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:get/get.dart';

import '../../../../constant/string.dart';
import '../../../../constant/values.dart';
import '../../../controller/data_controller.dart';
import '../../../controller/paper/image_controller.dart';
import '../../../controller/paper/paper_edit_page_controller.dart';
import '../../../controller/universal_controller.dart';

class PaperEditPage extends StatefulWidget {
  const PaperEditPage({super.key, this.index = -1});
  final int index;

  @override
  State<StatefulWidget> createState() => _PaperEditPage();
}

class _PaperEditPage extends State<PaperEditPage> {
  late int index;
  late Timer timer;

  final controller = Get.put(PaperEditController());
  final dataController = Get.find<DataController>();
  final userController = Get.find<UserController>();
  final imageController = Get.find<ImageController>();

  @override
  void initState() {
    super.initState();
    index = widget.index;
    controller.init(
        key: userController.getKey(),
        index: index,
        uid: userController.getUid(),
        data: (index == -1)?null:dataController.getPaper(index)
    );
    timer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      if(controller.isEditMode() && controller.save()) {
        try {
          await imageController.save();
          controller.save();
          await dataController.addPaper(
            paper: controller.getPaper(),
            paperIndex: controller.getIndex(),
            bookIndex: dataController.index.value,
          ).then((value) {
            var dialog = Get.isDialogOpen;
            if(dialog! && dialog) Get.back();
            if(value) CustomSnackBar.show(title: "성공", message: "독후감이 자동 저장되었습니다");
            controller.index.value = 0;
          });
        } catch(e) {
          CustomSnackBar.show(title: "실패", message: "저장하는 중에 오류가 발생했습니다.");
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: CupertinoNavigationBar(
          border: null,
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if(controller.isEditMode()) {
                  CustomDialog.showDialog(
                      context: context,
                      title: "돌아가기",
                      content: "새로 작성한 내용은 저장되지 않습니다",
                      confirmAction: () {
                        imageController.cancel();
                        Get.back();
                      }
                  );
                } else {
                  Get.back();
                }
              },
              child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Get.theme.colorScheme.primary
              )
          ),
          padding: EdgeInsetsDirectional.zero,
          middle: Text(paperText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: CustomFont.caption.size,
                  color: Theme.of(context).colorScheme.onBackground,
                  height: 1.0
              )
          ),
          trailing: Obx(() => _editButton()),
        ),
        body: Container(
            margin: EdgeInsets.only(bottom: getBottomSpacing()),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaperToolBar(),
                  Expanded(child: Obx(() => _body())),
                ]
            )
        )
    );
  }

  _editButton() {
    if(controller.isEditMode()) {
      return CupertinoButton(
          padding: EdgeInsets.all(Spacing.small.size),
          child: Text(
              saveText,
              style: TextStyle(
                  height: 1,
                  fontSize: CustomFont.caption.size,
                  color: Get.theme.colorScheme.primary
              )
          ),
          onPressed: () async {
            if(controller.save()) {
                Get.dialog(const CustomIndicator(label: "저장 중"), barrierDismissible: false);
                final result = await _save();
                var open = Get.isDialogOpen;
                if(open != null && open) Get.back();
                if(result) {
                  controller.index.value = 0;
                  controller.changeEditMode();
                } else {
                  CustomSnackBar.show(title: "실패", message: "독후감을 저장하지 못하였습니다");
                }
            } else {
              CustomSnackBar.show(title: "실패", message: "제목이 작성되지 않았습니다");
            }
          }
      );
    } else {
      return CupertinoButton(
          padding: EdgeInsets.all(Spacing.small.size),
          child: Text(
              editText,
              style: TextStyle(
                  height: 1,
                  fontSize: CustomFont.caption.size,
                  color: Get.theme.colorScheme.primary
              )
          ),
          onPressed: ()  => controller.editMode.value = true
      );
    }
  }

  _save() async {
    try {
      await imageController.save();
      controller.setImage(imageController.getImageNames());
      return await dataController.addPaper(
        paper: controller.getPaper(),
        paperIndex: controller.getIndex(),
        bookIndex: dataController.index.value,
      );
    } catch(e) {
      return false;
    }
  }

  _body() {
    if(controller.isEditMode()) {
      return PaperContentEditor();
    } else {
      return Obx(() => PaperContentView(index: controller.getIndex()));
    }
  }
}

class PaperToolBar extends StatelessWidget {
  final controller = Get.find<PaperEditController>();
  final imageController = Get.find<ImageController>();
  final userController = Get.find<UserController>();

  PaperToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
        visible: controller.isEditMode(),
        child: Container(
            padding: EdgeInsets.only(
                right: Spacing.medium.size, left: Spacing.medium.size
            ),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Get.theme.colorScheme.outline, width: 1),
                    bottom: BorderSide(color: Get.theme.colorScheme.outline, width: 1)
                )
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                        )
                    ),
                    child: _backgroundColor(context),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                        )
                    ),
                    child: controller.getAccessButton(),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1),
                          )
                      ),
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(Icons.image),
                          onPressed: () => _addImage()
                      )
                  ),
                  VerticalDivider(color: Colors.transparent, width: Spacing.medium.size),
                  Expanded(child: SingleChildScrollView(
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      child: QuillProvider(
                        configurations: QuillConfigurations(
                          controller: controller.getQuillController()
                        ),
                        child: QuillTools().getBottomTool()
                      )
                  ))
                ]
            )
        )
    ));
  }

  _backgroundColor(BuildContext context) {
    return CupertinoButton(
        padding: EdgeInsets.zero,
        child: const Icon(Icons.palette_rounded),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) => ColorPicker(
                baseColor: controller.getBgColor()
              )
          ).then((value) {
            if(value != null) controller.setBgColor(value);
          });
        }
    );
  }


  _addImage() async {
    Get.dialog(const CustomIndicator(label: "사진 압축하는 중"), barrierDismissible: false);
    final result = await imageController.addImage();
    final image = Get.isDialogOpen;
    if(image != null && image) Get.back();
    switch(result) {
      case ImageEnum.success:
        break;
      case ImageEnum.maxExtent:
        CustomSnackBar.show(
            title: "오류",
            message: "최대 5장까지 업로드할 수 있습니다.");
        break;
      case ImageEnum.maxSize:
        CustomSnackBar.show(
            title: "오류",
            message: "이미지 크기가 5MB를 초과합니다.");
        break;
      case ImageEnum.broken:
        CustomSnackBar.show(
            title: "오류",
            message: "이미지가 손상되어 업로드할 수 없습니다.");
        break;
      case ImageEnum.fileNotFound:
        CustomSnackBar.show(
            title: "오류",
            message: "해당 이미지를 찾을 수 없습니다.");
        break;
      case ImageEnum.notSupported:
        CustomSnackBar.show(
            title: "오류",
            message: "해당 이미지 형식은 지원하지 않습니다.");
        break;
    }
  }
}

class PaperContentView extends StatelessWidget {
  PaperContentView({super.key, required this.index});
  final controller = Get.find<PaperEditController>();
  final dataController = Get.find<DataController>();
  final imageController = Get.find<ImageController>();
  final double imageSize = 180;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            right: Spacing.medium.size,
            left: Spacing.medium.size
        ),
        child: Obx(() => ListView(
            children: [
              renderTitle(),
              renderChapter(),
              Divider(height: Spacing.small.size, color: Colors.transparent),
              PaperInfo(),
              Divider(
                  height: Spacing.huge.size,
                  color: Theme.of(context).colorScheme.outline
              ),
              PaperCommentEditor(),
              Divider(height: Spacing.huge.size, color: Colors.transparent),
              PaperSummaryEditor(),
              Divider(height: Spacing.huge.size, color: Colors.transparent),
              PaperImageEditor(imageSize: imageSize),
              Divider(height: Spacing.small.size, color: Colors.transparent),
              renderRemoveButton()
            ]
        ))

    );
  }

  renderRemoveButton() {
    return CupertinoButton(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                  CupertinoIcons.delete,
                  color: Colors.redAccent,
                  size: IconSize.small.size
              ),
              VerticalDivider(color: Colors.transparent, width: Spacing.tiny.size),
              Text(removeText,
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: CustomFont.caption.size
                  )
              )
            ]
        ),
        onPressed: () async {
          await showCupertinoDialog(
              context: Get.context!,
              builder: (context) => CupertinoAlertDialog(
                    title: const Text(paperDeleteText),
                    actions: [
                      CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(dismissText)
                      ),
                      CupertinoDialogAction(
                          child: const Text(confirmText, style: TextStyle(
                            color: Colors.blueAccent
                          )),
                          onPressed: () async {
                            try {
                              await imageController.clear(index);
                              await dataController.removePaper(index);
                              if(context.mounted) Navigator.of(context).pop(true);
                            } catch(e) {
                              if(context.mounted) Navigator.of(context).pop(false);
                            }
                          }
                          )
                    ]
              )
          ).then((value) {
            if(value) Get.back();
          });
        }
    );
  }

  renderTitle() {
    return Text(
        controller.getTitle(),
        maxLines: 1,
        style: TextStyle(
            fontSize: CustomFont.title.size,
            fontWeight: FontWeight.bold
        ),
    );
  }

  renderChapter() {
    if(controller.getChapter().isNotEmpty) {
      return Text(
        controller.getChapter(),
        maxLines: 1,
        style: TextStyle(fontSize: CustomFont.body.size),
      );
    } else {
      return const SizedBox();
    }
  }
}

class PaperInfo extends StatelessWidget {
  PaperInfo({super.key});
  final controller = Get.find<PaperEditController>();
  final dataController = Get.find<DataController>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(() => Text(controller.getLastEdit())),
            VerticalDivider(color: Colors.transparent, width: Spacing.tiny.size),
            Obx(() => getAccess()),
          ]
        ),
        _pageExtent()
      ],
    );
  }

  getAccess() {
    switch(controller.getAccess()) {
      case UserAccess.private:
        return _iconText(Icons.person_rounded, "나만 보기");
      case UserAccess.restricted:
        return _iconText(Icons.group_rounded, "친구 공개");
      case UserAccess.follow:
        return _iconText(Icons.groups_rounded, "팔로워 공개");
      case UserAccess.public:
        return _iconText(Icons.public_rounded, "전체 공개");
    }
  }

  _iconText(IconData icon, String text) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,
            size: IconSize.small.size,
            color: Get.theme.colorScheme.primary,
          ),
          const VerticalDivider(color: Colors.transparent, width: 4),
          Text(text, textAlign: TextAlign.center)
        ]
    );
  }

  _pageExtent() {
    final pages = dataController.getBook(dataController.getIndex()).info.pages;
    if(controller.isEditMode()) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                child: Container(
                    width: 48,
                    alignment: Alignment.center,
                    child: Obx(() => Text(
                        "p.${controller.getPageStart()}",
                        style: TextStyle(
                            color: Get.theme.colorScheme.primary
                        )
                    ))
                ),
                onTap: () => _pageSelectModal(pages, controller.getPageStart() - 1, (value) {
                  controller.setPageStart(value + 1);
                  if(controller.getPageStart() > controller.getPageEnd()) {
                    controller.setPageEnd(value + 1);
                  }
                })
            ),
            const Text(" - ", textAlign: TextAlign.center),
            GestureDetector(
                child: Container(
                    width: 48,
                    alignment: Alignment.center,
                    child: Obx(() => Text(
                        "p.${controller.getPageEnd()}",
                        style: TextStyle(
                            color: Get.theme.colorScheme.primary
                        )
                    ))),
                onTap: () => _pageSelectModal(pages, controller.getPageEnd() - 1, (value) {
                  controller.setPageEnd(value + 1);
                  if(controller.getPageStart() > controller.getPageEnd()) {
                    controller.setPageStart(value + 1);
                  }
                })
            )
          ]
      );
    } else {
      return Text(
          "p.${controller.getPageStart()}  -  p.${controller.getPageEnd()}",
          style: TextStyle(
              color: Get.theme.colorScheme.onBackground
          )
      );
    }
  }

  _pageSelectModal(int count, int initial, Function(int) onSelectedItemChanged) {
    return showModalBottomSheet(
        context: Get.context!,
        isDismissible: true,
        isScrollControlled: true,
        enableDrag: true,
        builder: (context) => SizedBox(
            height: 360,
            child: CupertinoPicker.builder(
                childCount: count,
                scrollController: FixedExtentScrollController(initialItem: initial),
                itemBuilder: (context, index) => Center(child: Text("${index + 1}쪽")),
                itemExtent: 48,
                onSelectedItemChanged: onSelectedItemChanged
            )
        )
    );
  }
}

class PaperContentEditor extends StatelessWidget {
  PaperContentEditor({super.key});
  final controller = Get.find<PaperEditController>();
  final dataController = Get.find<DataController>();
  final double imageSize = 180;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            right: Spacing.medium.size,
            left: Spacing.medium.size
        ),
        child: Obx(() => ListView(
            children: [
              renderTitle(),
              renderChapter(),
              Divider(height: Spacing.small.size, color: Colors.transparent),
              PaperInfo(),
              Divider(height: Spacing.huge.size, color: Theme.of(context).colorScheme.outline),
              PaperCommentEditor(),
              PaperSummaryEditor(),
              PaperImageEditor(imageSize: imageSize),
            ]
        ))
    );
  }

  renderTitle() {
    return TextFormField(
        maxLength: 25,
        maxLines: 1,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        style: TextStyle(
            fontSize: CustomFont.title.size,
            fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "제목을 작성해보세요",
            hintStyle: TextStyle(
                fontSize: CustomFont.title.size,
                fontWeight: FontWeight.bold,
            ),
            counterText: ""
        ),
        controller: TextEditingController(text: controller.getTitle()),
        onChanged: (value) => controller.setTitle(value)
    );
  }

  renderChapter() {
    return TextFormField(
      maxLength: 30,
      maxLines: 1,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      style: TextStyle(fontSize: CustomFont.body.size),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "부제를 입력하세요",
          hintStyle: TextStyle(fontSize: CustomFont.body.size),
          counterText: ""
      ),
      controller: TextEditingController(text: controller.getChapter()),
      onChanged: (value) => controller.setChapter(value),
    );
  }
}

class PaperCommentEditor extends StatelessWidget {
  PaperCommentEditor({super.key});
  final controller = Get.find<PaperEditController>();
  final dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    final QuillController comment = controller.getComment();
    if (controller.isEditMode()) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("코멘트", style: TextStyle(
                fontSize: CustomFont.body.size,
                fontWeight: FontWeight.bold
            )),
            Divider(color: Colors.transparent, height: Spacing.tiny.size),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.colorScheme.outline, width: 1),
                    borderRadius: BorderRadius.circular(CustomRadius.tiny.radius)
                ),
                padding: EdgeInsets.all(Spacing.small.size),
                child: Obx(() => _quillEditor(comment))
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(Spacing.tiny.size),
                    child: Obx(() => Text(
                        "${controller.getCommentLength()}/150",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: CustomFont.small.size)
                    ))
                )
            )
          ]
      );
    } else if(!comment.document.isEmpty()) {
      return Container(
          padding: EdgeInsets.all(Spacing.medium.size),
          decoration: BoxDecoration(border: Border(
              left: BorderSide(color: Get.theme.colorScheme.primary, width: 3)
          )),
          child: Obx(() => _quillEditor(comment))
      );
    } else {
      return const SizedBox();
    }
  }

  _quillEditor(QuillController comment) {
    final brightness = Get.mediaQuery.platformBrightness;
    return QuillProvider(
        configurations: QuillConfigurations(
          controller: comment
        ),
        child: QuillEditor(
          scrollController: ScrollController(),
          configurations: QuillEditorConfigurations(
              enableSelectionToolbar: false,
              detectWordBoundary: false,
              placeholder: "",
              readOnly: !controller.isEditMode(),
              scrollable: false,
              padding: EdgeInsets.zero,
              autoFocus: false,
              showCursor: controller.isEditMode(),
              expands: false,
              minHeight: controller.isEditMode()?120:null,
              customStyles: DefaultStyles(
                  paragraph: DefaultTextBlockStyle(
                      TextStyle(
                          color: (brightness == Brightness.light)?Colors.black:Colors.white,
                          fontSize: CustomFont.body.size,
                          fontFamily: "LINE"
                      ),
                      const VerticalSpacing(0, 0),
                      const VerticalSpacing(0, 0),
                      null
                  )
              )
          ),
          focusNode: FocusNode(),
        ));
  }
}

class PaperSummaryEditor extends StatelessWidget {
  PaperSummaryEditor({super.key});
  final controller = Get.find<PaperEditController>();

  @override
  Widget build(BuildContext context) {
    final summary = controller.getSummary();
    if(controller.isEditMode()) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("줄거리", style: TextStyle(
                fontSize: CustomFont.body.size,
                fontWeight: FontWeight.bold
            )),
            Divider(color: Colors.transparent, height: Spacing.tiny.size),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.colorScheme.outline, width: 1),
                    borderRadius: BorderRadius.circular(CustomRadius.tiny.radius)
                ),
                padding: EdgeInsets.all(Spacing.small.size),
                child: Obx(() => _quillEditor(summary))
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                    padding: EdgeInsets.all(Spacing.tiny.size),
                    child: Obx(() => Text(
                        "${controller.getSummaryLength()}/500",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: CustomFont.small.size)
                    ))
                )
            )
          ]
      );
    } else if(!summary.document.isEmpty()) {
      return Obx(() => _quillEditor(summary));
    } else {
      return const SizedBox();
    }
  }

  _quillEditor(QuillController summary) {
    final brightness = Get.mediaQuery.platformBrightness;
    return QuillProvider(
        configurations: QuillConfigurations(
          controller: summary,
        ),
        child: QuillEditor(
            focusNode: FocusNode(),
            scrollController: ScrollController(),
            configurations: QuillEditorConfigurations(
                readOnly: !controller.isEditMode(),
                placeholder: "",
                scrollable: true,
                padding: EdgeInsets.zero,
                autoFocus: false,
                showCursor: controller.isEditMode(),
                enableSelectionToolbar: false,
                expands: false,
                minHeight: controller.isEditMode()?180:null,
                customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                        TextStyle(
                            color: (brightness == Brightness.light)?Colors.black:Colors.white,
                            fontSize: CustomFont.caption.size,
                            fontFamily: "LINE"
                        ),
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null
                    )
                )
            )
        )
    );
  }
}

class PaperImageEditor extends StatelessWidget {
  PaperImageEditor({super.key, required this.imageSize});
  final dataController = Get.find<DataController>();
  final controller = Get.find<PaperEditController>();
  final imageController = Get.find<ImageController>();
  final double imageSize;

  @override
  Widget build(BuildContext context) {
      if(controller.isEditMode()) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("사진 첨부", style: TextStyle(
                  fontSize: CustomFont.body.size,
                  fontWeight: FontWeight.bold
              )),
              Divider(color: Colors.transparent, height: Spacing.tiny.size),
              Obx(() => getWidget()),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: EdgeInsets.all(Spacing.tiny.size),
                      child: Obx(() => Text(
                          "${imageController.getImageCount()}/5",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: CustomFont.small.size)
                      ))
                  )
              )
            ]
        );
      } else if(imageController.getImageCount() > 0) {
        return Obx(() => getWidget());
      } else {
        return const SizedBox();
      }
  }

  getWidget() {
    if(imageController.getImageCount() == 0) {
      return Container(
        height: imageSize,
        decoration: BoxDecoration(
            color: Get.theme.colorScheme.outline,
            borderRadius: BorderRadius.circular(CustomRadius.tiny.radius)
        ),
        padding: EdgeInsets.all(Spacing.small.size),
        width: double.infinity,
        alignment: Alignment.center,
          child: Text(
              addImageText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Get.theme.colorScheme.background)
        )
      );
    } else {
      return SizedBox(
          height: imageSize,
          child: Obx(() => ListView.separated(
              itemCount: imageController.getImageCount(),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => SizedBox(width: Spacing.small.size),
              itemBuilder: (_, index) => PaperImageWidget(
                  imageSize: imageSize, index: index
              )
          ))

      );
    }
  }
}

class PaperImageWidget extends StatelessWidget {
  final int index;
  final double imageSize;
  PaperImageWidget({super.key, required this.index, required this.imageSize});
  final controller = Get.find<PaperEditController>();
  final imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: imageSize,
        height: imageSize,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(CustomRadius.medium.radius),
            child: PaperImageAction(index: index, imageSize: imageSize)
        )
    );
  }
}

class PaperImageAction extends StatelessWidget {
  final int index;
  final double imageSize;
  PaperImageAction({super.key, required this.index, required this.imageSize});

  final controller = Get.find<PaperEditController>();
  final imageController = Get.find<ImageController>();

  @override
  Widget build(BuildContext context) {
    if (controller.isEditMode()) {
      return Obx(() => GestureDetector(
          child: Opacity(
            opacity: imageController.getImagePile().elementAt(index).remove?0.2:1,
            child: renderImageByDataType(index: index, resize: true),
          ),
          onTap: () {
            imageController.removeAt(index);
          }
      ));
    } else {
      return GestureDetector(
          child: renderImageByDataType(index: index, resize: true),
          onTap: () => showDialog(
              context: Get.context!,
              barrierDismissible: true,
              builder: (context) {
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    floatingActionButton: ClipRRect(
                      borderRadius: BorderRadius.circular(CustomRadius.circle.radius),
                      child: FloatingActionButton(
                        child: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ),
                    body: Center(
                        child: renderImageByDataType(
                            index: index,
                            resize: false
                        )
                    )
                );
              }
          )
      );
    }
  }


  dynamic renderImageByDataType({required index, required resize}) {
    return InteractiveViewer(
        panEnabled: !resize,
        scaleEnabled: !resize,
        child: getImage(imageController.getImagePile().elementAt(index), resize)
    );
  }

  getImage(ImageAsset image, bool resize) {
    if(image.url == null) {
      return Image.memory(
        image.data!,
        fit: BoxFit.cover,
        width: (resize)?imageSize:null,
        height: (resize)?imageSize:null,
        filterQuality: FilterQuality.high,
      );
    } else {
      return Image.network(
        image.url!,
        fit: BoxFit.cover,
        width: (resize)?imageSize:null,
        height: (resize)?imageSize:null,
        filterQuality: FilterQuality.high,
      );
    }
  }
}
