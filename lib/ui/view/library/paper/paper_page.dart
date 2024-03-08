import 'package:book_report/constant/values.dart';
import 'package:book_report/data/model/book_model.dart';
import 'package:book_report/ui/view/library/paper/paper_edit_page.dart';
import 'package:book_report/ui/view/library/paper/paper_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../data/model/paper_model.dart';
import '../../../controller/data_controller.dart';
import '../../../controller/paper/image_controller.dart';
import '../../../controller/universal_controller.dart';
import '../../../controller/user_controller.dart';

class PaperPage extends StatefulWidget {
  final BookData book;
  const PaperPage({super.key, required this.book});

  @override
  State<StatefulWidget> createState() => _PaperPageState();
}

class _PaperPageState extends State<PaperPage> {
  late final BookData book;
  final dataController = Get.find<DataController>();
  final userController = Get.find<UserController>();
  final imageController = Get.find<ImageController>();
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        padding: EdgeInsets.only(bottom: getBottomSpacing()),
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                resizeToAvoidBottomInset: false,
                body: getWidget(),
                appBar: CupertinoNavigationBar(
                  border: null,
                  middle: Text(
                      book.info.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: CustomFont.caption.size,
                          height: 1
                      )
                  ),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                floatingActionButton: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CustomRadius.circle.radius)
                    ),
                    child: const Icon(Icons.add_rounded),
                    onPressed: () {
                      imageController.setIndex(-1);
                      Get.to(() => const PaperEditPage());
                    }
                )
            )
        )
    );
  }

  getWidget() {
    List<Paper> papers = book.paperList;
    return FutureBuilder(
        future: imageController.init(
            id: userController.getUid(),
            items: List.generate(papers.length, (index) {
              return papers[index].image.images;
            })
        ),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return Obx(() {
            if(dataController.getPapers().isEmpty) {
              return const PaperNotFound();
            } else {
              return PaperGridView();
            }
          });
        }
    );
  }
}

class PaperNotFound extends StatelessWidget {
  const PaperNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("images/paper_empty.svg",
                  width: 180,
                  height: 180
              ),
              Divider(height: Spacing.medium.size, color: Colors.transparent),
              Text("보관함이 비어있음",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: CustomFont.body.size
                ),
              ),
              Text("새로운 독후감을 추가하고 작성해보세요",
                  style: TextStyle(fontSize: CustomFont.caption.size)
              )
            ]
        )
    );
  }
}