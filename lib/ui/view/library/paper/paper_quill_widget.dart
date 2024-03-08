import 'package:book_report/ui/controller/paper/paper_edit_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

import '../../../../constant/values.dart';

class QuillTools {

  getBottomTool() {
    return QuillToolbar(
        configurations: QuillToolbarConfigurations(
            multiRowsDisplay: true,
            fontSizesValues: {
              "Small": '${CustomFont.caption.size}',
              "Medium": '${CustomFont.body.size}',
              "Large": '${CustomFont.title.size}',
            },
            showFontFamily: false,
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
            showSmallButton: false,
            toolbarSize: 20,
            sectionDividerSpace: 0,
            toolbarIconAlignment: WrapAlignment.center,
            toolbarIconCrossAlignment: WrapCrossAlignment.center
        )
    );
  }
}
