import 'package:book_report/ui/controller/paper/paper_edit_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../../constant/values.dart';

class QuillTools {
  final controller = Get.find<PaperEditController>();

  getBottomTool() {
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
        controller: controller.getQuillController(),
        sharedConfigurations: const QuillSharedConfigurations(locale: Locale("ko")),
        multiRowsDisplay: true,
        fontSizesValues: {
          "Small": '${CustomFont.caption.size}',
          "Medium": '${CustomFont.body.size}',
          "Large": '${CustomFont.title.size}',
        },
        fontFamilyValues: const {
          "기본": 'LINE',
          "교보 손글씨체": 'KYOBO',
          "영덕 바다체": 'YEONGDEOK',
          "꿈누리터 모두체": 'MODU',
          "꿈누리터 꿈체": 'DREAM'
        },
        showDividers: false,
        showClearFormat: false,
        showListNumbers: false,
        showListBullets: false,
        showAlignmentButtons: true,
        showCodeBlock: false,
        showCenterAlignment: true,
        showDirection: false,
        showBackgroundColorButton: false,
        showHeaderStyle: false,
        showInlineCode: false,
        showListCheck: false,
        showIndent: false,
        showLink: false,
        showLeftAlignment: true,
        showRightAlignment: true,
        showQuote: false,
        showSearchButton: false,
        showSmallButton: false,
        showSubscript: false,
        showSuperscript: false,
        toolbarSize: 20,
        sectionDividerSpace: 0,
        toolbarIconAlignment: WrapAlignment.center,
        toolbarIconCrossAlignment: WrapCrossAlignment.center,
      )
    );
  }
}
