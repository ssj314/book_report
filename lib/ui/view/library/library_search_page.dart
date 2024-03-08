import 'package:book_report/data/provider/rest_api_provider.dart';
import 'package:book_report/data/repository/rest_api_repository.dart';
import 'package:book_report/ui/controller/data_controller.dart';
import 'package:book_report/ui/view/library/library_add_page.dart';

import 'package:book_report/ui/widget/custom_searchbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../../data/model/book_model.dart';
import '../../widget/custom_clickable_image.dart';

class LibrarySearchController extends GetxController {
  var query = "".obs;

  search(String query) async {
    if(query.isEmpty) return <SimpleBookInfo>[];
    final repo = RestAPIRepository(provider: RestAPIProvider());
    return await repo.sendRequest(method: RequestMethod.kakao, query: query);
  }

  getQuery() => query.value;
  setQuery(value) => query.value = value;
}

class LibrarySearchPage extends StatelessWidget {
  final controller = Get.put(LibrarySearchController());
  LibrarySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text(
            "새로운 책 추가",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          border: null,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      right: Spacing.small.size,
                      left: Spacing.small.size
                  ),
                  child: CustomSearchBar(
                      onSubmitted: (value) => controller.setQuery(value)
                  )
              ),
              Expanded(
                  child: Obx(() => LibrarySearchContent(query: controller.getQuery()))
              )
            ]
        )
    );
  }
}

class LibrarySearchContent extends StatelessWidget {
  final String query;
  final controller = Get.find<LibrarySearchController>();
  final dataController = Get.find<DataController>();
  LibrarySearchContent({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.search(query),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoActivityIndicator();
          } else if(snapshot.hasData){
            final items = (snapshot.data as List<SimpleBookInfo>);
            if(items.isNotEmpty) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(Spacing.medium.size),
                child:  Wrap(
                    spacing: Spacing.large.size,
                    runSpacing: Spacing.large.size,
                    children: List.generate(items.length, (index) => ClickableImage(
                        width: 180,
                        height: 240,
                        src: items[index].image,
                        title: items[index].title,
                        onClick: () => Get.off(() => LibraryAddPage(items[index]))
                    ))
                )
              );
            }
          }
          return const BookNotFound();
        }
    );
  }
}

class BookNotFound extends StatelessWidget {
  const BookNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("images/no_image.svg",
                  width: 180,
                  height: 180
              ),
              Divider(height: Spacing.medium.size, color: Colors.transparent),
              Text("검색 결과 없음",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: CustomFont.body.size
                )
              )
            ]
        )
    );
  }
}