import 'dart:convert';
import 'package:book_report/data/model/user_access_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/paper_model.dart';

class PaperEditController extends GetxController {
  final editMode = true.obs;

  final index = 0.obs;
  final uid = "".obs;
  final userKey = "".obs;

  final mode = 0.obs;

  final summary = QuillController.basic().obs;
  final comment = QuillController.basic().obs;

  final access = UserAccess.public.obs;
  final paper = Paper.empty().obs;
  final pageStart = 1.obs;
  final pageEnd = 1.obs;

  final summaryLength = 0.obs;
  final commentLength = 0.obs;

  Paper getPaper() => paper.value;
  setLastDate(value) => getPaper().lastDate = value;

  save() {
    if(getTitle().isNotEmpty) {
      setLastDate(DateFormat('yy/MM/dd HH:mm:ss').format(DateTime.now()));
      setSummary();
      setComment();
      getPaper().pageStart = pageStart.value;
      getPaper().pageEnd = pageEnd.value;
      return true;
    } else {
      return false;
    }
  }

  getIndex() => index.value;
  init({required String key, required String uid, required int index, Paper? data}) {
    userKey.value = key;
    this.index.value = index;
    this.uid.value = uid;
    editMode.value = index < 0;

    if(data != null) {
      paper(data);
      pageStart.value = data.pageStart;
      pageEnd.value = data.pageEnd;
      setAccess(data.access);
      try {
        if(data.content.summary.isNotEmpty) {
          summary(QuillController(document: Document.fromJson(jsonDecode(data.content.summary)), selection: const TextSelection.collapsed(offset: 0)));
        }
      } catch(e) {
        data.content.summary = data.content.summary.replaceAll('\n', '\\n');
        if(data.content.summary.isNotEmpty) {
          summary(QuillController(document: Document.fromJson(jsonDecode(data.content.summary)), selection: const TextSelection.collapsed(offset: 0)));
        }
      }

      try {
        if(data.content.comment.isNotEmpty) {
          comment(QuillController(document: Document.fromJson(jsonDecode(data.content.comment)), selection: const TextSelection.collapsed(offset: 0)));
        }
      } catch(e) {
        String query = data.content.comment;
        data.content.comment = jsonEncode([{"insert":'$query\n'}]);
        comment(QuillController(document: Document.fromJson(jsonDecode(data.content.comment)), selection: const TextSelection.collapsed(offset: 0)));
      }

      comment.value.addListener(() => mode.value = 0);
      summary.value.addListener(() => mode.value = 1);
      commentLength.value = comment.value.document.length - 1;
      summaryLength.value = summary.value.document.length - 1;
      paper.refresh();
    }

    comment.value.document.changes.listen((event) {
      int limit = 150;
      commentLength.value =  comment.value.document.length - 1;
      if (commentLength.value > limit) {
        final latestIndex = limit - 1;
        comment.value.replaceText(
          latestIndex,
          commentLength.value - limit,
          '',
          TextSelection.collapsed(offset: latestIndex),
        );
      }
    });

    summary.value.document.changes.listen((event) {
      int limit = 500;
      summaryLength.value = summary.value.document.length - 1;
      if (summaryLength.value > limit) {
        final latestIndex = limit - 1;
        summary.value.replaceText(
          latestIndex,
          summaryLength.value - limit,
          '',
          TextSelection.collapsed(offset: latestIndex),
        );
      }
    });
  }

  QuillController getQuillController() {
    switch(mode.value) {
      case 0:
        return comment.value;
      case 1:
        return summary.value;
      default:
        return comment.value;
    }
  }

  getSummaryLength() => summaryLength.value;
  getCommentLength() => commentLength.value;

  isEditMode() => editMode.value;
  changeEditMode() => editMode.value = isEditMode()?false:true;

  String getTitle() => getPaper().content.title;
  setTitle(value) => getPaper().content.title = value;

  getAccess() => access.value;
  setAccess(value) {
    access.value = value;
    paper.value.access = value;
  }

  Color getBgColor() {
    int bg = getPaper().bgColor;
    if(bg == -1) {
      Color color =  Get.theme.colorScheme.secondaryContainer;
      bg = color.value;
    }
    return Color(bg + 0xFF000000);
  }

  setBgColor(int color) => getPaper().bgColor = color;

  getChapter() => getPaper().content.chapter;
  setChapter(value) => getPaper().content.chapter = value;

  setSummary() => getPaper().content.summary = jsonEncode(
      getSummary().document.toDelta().toJson());
  QuillController getSummary() => summary.value;

  getComment() => comment.value;
  setComment() {
    getPaper().content.comment = jsonEncode(
        getComment().document.toDelta().toJson());
  }

  getPageStart() => pageStart.value;
  setPageStart(value) => pageStart.value = value;
  getPageEnd() => pageEnd.value;
  setPageEnd(value) => pageEnd.value = value;

  getLastEdit() {
    var date = getPaper().lastDate;
    DateTime format;

    if(date.isEmpty) {
      format = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    } else {
      format = DateFormat("yy/MM/dd").parse(date);
    }
    var str = "${format.year}년 ${format.month}월 ${format.day}일 ";
    
    switch(format.weekday) {
      case DateTime.monday:
        str += "월요일";
        break;
      case DateTime.tuesday:
        str += "화요일";
        break;
      case DateTime.wednesday:
        str += "수요일";
        break;
      case DateTime.thursday:
        str += "목요일";
        break;
      case DateTime.friday:
        str += "금요일";
        break;
      case DateTime.saturday:
        str += "토요일";
        break;
      case DateTime.sunday:
        str += "일요일";
        break;
    }
  return str;
  }

  setImage(List<String> items) => getPaper().image = PaperImage(images: items);
  getImage() => getPaper().image.images;

  getAccessButton() {
    switch(getAccess()) {
      case UserAccess.public:
        return CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.public_rounded,
              color: Get.theme.colorScheme.primary,
            ),
            onPressed: () {
              if(isEditMode()) setAccess(UserAccess.follow);
            }
        );
      case UserAccess.follow:
        return CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.groups_rounded,
              color: Get.theme.colorScheme.primary,
            ),
            onPressed: () {
              if(isEditMode()) setAccess(UserAccess.restricted);
            }
        );
      case UserAccess.restricted:
        return CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.group_rounded,
              color: Get.theme.colorScheme.primary,
            ),
            onPressed: () {
              if(isEditMode()) setAccess(UserAccess.private);
            }
        );
      case UserAccess.private:
        return CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.person_rounded,
              color: Get.theme.colorScheme.primary,
            ),
            onPressed: () {
              if(isEditMode()) setAccess(UserAccess.public);
            }
        );
      }
    }
}