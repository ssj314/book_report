import 'package:book_report/data/model/book_model.dart';
import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/widget/custom_clickable_image.dart';
import 'package:book_report/ui/widget/custom_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../../data/provider/rest_api_provider.dart';
import '../../../data/repository/rest_api_repository.dart';
import '../../controller/universal_controller.dart';
import '../../widget/custom_long_button.dart';

class LibraryAddPageController extends GetxController {
  var info = Rxn<BookInfo>();

  init(author, String isbn) async  {
    try {
      if(isbn.contains(" ")) isbn = isbn.split(' ')[1];
      return await search(isbn, RequestMethod.aladin);
    } catch(e) {
      return null;
    }
  }

  search(String query, RequestMethod method) async {
    final repo = RestAPIRepository(provider: RestAPIProvider());
    final result = await repo.sendRequest(method: method, query: query);
    return result;
  }

  void setBook(BookInfo value) => info(value);
  BookInfo getBook() => info.value!;

  Future<BookData> getBookData() async {
/*    var moreInfo = <SimpleBookInfo>[];
    for(var book in bookList) {
      try {
        final BookInfo res = await search(book.isbn.split(' ')[1], RequestMethod.aladin);
        if(res.isbn != info.value?.isbn && res.authorId == info.value?.authorId) {
          moreInfo.add(SimpleBookInfo(
              image: res.thumbnail,
              title: res.title,
              isbn: res.isbn,
              author: res.author
          ));
        }
      } catch(_) {}
    }*/
    return BookData(
      paperList: [],
      info: info.value,
      //moreInfo: moreInfo
    );
  }
}

class LibraryAddPage extends StatelessWidget {
  final SimpleBookInfo bookInfo;
  LibraryAddPage(this.bookInfo, {super.key});
  final dataController = Get.find<DataController>();
  final controller = Get.put(LibraryAddPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: CupertinoNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              middle: Text(
                bookInfo.title,
                style: Theme.of(context).textTheme.titleMedium,
              )
          ),
          body: FutureBuilder(
              future: controller.init(bookInfo.author, bookInfo.isbn),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomIndicator(simple: true);
                } else if(snapshot.data == null) {
                  controller.setBook(BookInfo(
                    title: bookInfo.title,
                    author: bookInfo.author,
                    authorId: 0,
                    desc: "",
                    interest: false,
                    isbn: bookInfo.isbn,
                    pages: 0,
                    thumbnail: bookInfo.image
                  ));
                } else {
                  controller.setBook(snapshot.data as BookInfo);
                }

                return Padding(
                    padding: EdgeInsets.only(
                        bottom: Spacing.medium.size + getBottomSpacing(),
                        right: Spacing.medium.size,
                        left: Spacing.medium.size
                    ),
                    child: Stack(children: [
                      LibraryInfoField(),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomLongButton(
                            label: "저장",
                            onClick: () async {
                              Get.dialog(const CustomIndicator(label: "저장 중"), barrierDismissible: false);
                              final bookData = await controller.getBookData();
                              await dataController.addBook(bookData).then((value) {
                                var open = Get.isDialogOpen;
                                if(open != null && open) Get.back();
                                Get.back();
                              });
                            },
                          )
                      )
                    ])
                );
              }
          )

    );
  }
}

class LibraryInfoField extends StatelessWidget {
  final controller = Get.find<LibraryAddPageController>();
  LibraryInfoField({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Obx(() => imageWidget()),
          Obx(() => titleWidget()),
          Obx(() => authorWidget()),
          Obx(() => descriptionWidget()),
          Obx(() =>  pagesWidget()),
          const Divider(height: 64, color: Colors.transparent)
        ]
    );
  }

  imageWidget() {
    return Container(
        padding: EdgeInsets.all(Spacing.medium.size),
        alignment: Alignment.center,
        child: ClickableImage(
          width: 180,
          height: 270,
          onClick: () {},
          src: controller.getBook().thumbnail,
        )
    );
  }

  titleWidget() {
    return TextField(
      decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "제목"
      ),
      onChanged: (value) => controller.getBook().title = value,
      controller: TextEditingController(text: controller.getBook().title),
    );
  }

  authorWidget() {
    return TextField(
        decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: "저자"
        ),
        onChanged: (value) => controller.getBook().author = value,
        controller: TextEditingController(text: controller.getBook().author)
    );

  }

  descriptionWidget() {
    return TextField(
        decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: "설명"
        ),
        minLines: 3,
        maxLines: 10,
        maxLength: 250,
        onChanged: (value) => controller.getBook().desc = value,
        controller: TextEditingController(text: controller.getBook().desc)
    );
  }

  pagesWidget() {
    return TextField(
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "페이지 수",
          suffixText: "쪽",
        ),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false
        ),
        onChanged: (value) => controller.getBook().pages = int.parse(value),
        controller: TextEditingController(text: controller.getBook().pages.toString())
    );
  }
}
