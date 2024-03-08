import 'package:book_report/data/model/book_model.dart';
import 'package:book_report/data/model/paper_model.dart';
import 'package:book_report/data/provider/book_provider.dart';
import 'package:book_report/data/repository/book_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'encrypter.dart';

class DataController extends GetxController {
  late BookRepository bookRepo;
  var index = RxInt(0);
  final books = RxList<BookData>([]);
  final controller = FixedExtentScrollController().obs;
  final uid = RxString("");
  final key = RxString("");

  init({required String uid, required String key}) async {
    try {
      this.uid(uid);
      this.key(key);
      bookRepo = BookRepository(provider: BookProvider(uid: uid));
      books(await bookRepo.getBookDatabase(Encryptor(userKey: key), true));
      books.refresh();
      return;
    } catch(e) {
      throw Exception(e);
    }
  }

  removeBook() async {
    await BookRepository(provider: BookProvider(uid: uid.value)).removeAll();
  }

  bool hasData() => books.isNotEmpty;

  BookData getBook(index) => books[index];
  int getLength() => books.length;
  String getTitle(index) => getBook(index).info.title;
  String getAuthor(index) => getBook(index).info.author;
  String getDescription(index) => getBook(index).info.desc;
  String getImage(index) => getBook(index).info.thumbnail;
  int getAuthorID(index) => getBook(index).info.authorId;
  bool getInterest(index) => getBook(index).info.interest;
  setInterest(index) async {
    final temp = getBook(index);
    if(getInterest(index)) {
      temp.info.interest = false;
      books.removeAt(index);
      books.add(temp);
    } else {
      temp.info.interest = true;
      books.removeAt(index);
      books.insert(0, temp);
    }

    books.refresh();
    await bookRepo.set(null,
        BookList(items: books).toMap(Encryptor(userKey: key.value))
    );
  }

  addBook(BookData data) async {
    books.add(data);
    books.refresh();
    var length = getLength() - 1;
    await bookRepo.set("$length", data.toMap(Encryptor(userKey: key.value)));
  }

  Future<void> deleteBook(int position) async {
    books.removeAt(position);
    books.refresh();
    setIndex(position - 1);
    await bookRepo.set(
        null,
        BookList(items: books).toMap(Encryptor(userKey: key.value))
    );
  }

  setIndex(value) {
    if(value < 0) value = 0;
    index.value = value;
  }

  jumpToItem() => controller.value.jumpToItem(index.value);

  getIndex() => (index.value < 0)?0:index.value;
  isCurrentIndex(idx) => index.value == idx;

  getController() {
    controller.value = FixedExtentScrollController(
      initialItem: index.value
    );
    return controller.value;
  }

  // Paper
  List<Paper> getPapers() => getBook(index.value).paperList;
  int getPaperCount() => getPapers().length;

  Future<bool> addPaper({
    required Paper paper,
    required int paperIndex,
    required int bookIndex,
  }) async {
    try {
      final papers = getPapers();
      if(paperIndex > - 1) papers.removeAt(paperIndex);
      papers.insert(0, paper);
      await bookRepo.set("$bookIndex/PAPER", PaperList(paperList: papers).toMap(Encryptor(userKey: key.value)));
      books.refresh();
      return true;
    } catch(e) {
      return false;
    }
  }

  Color getPaperColor(int paperIndex) {
    int bg = getPapers()[paperIndex].bgColor;
    if(bg == -1) {
      Color color =  Get.theme.colorScheme.secondaryContainer;
      bg = color.value;
    }
    return Color(bg);
  }

  switchPaper(int from, int to) async {
    if(to < from) {
      // 앞으로 이동
      Paper paper = getPapers().removeAt(from);
      getPapers().insert(to, paper);
    } else {
      Paper paper = getPaper(from);
      getPapers().insert(to, paper);
      getPapers().removeAt(from);
    }
    await bookRepo.set(
        "${index.value}/PAPER",
        PaperList(paperList: getPapers()).toMap(
            Encryptor(userKey: key.value)
        )
    );
    books.refresh();
  }

  removePaper(int paperIndex) async {
    final papers = getPapers();
    papers.removeAt(paperIndex);
    books.refresh();
    await bookRepo.set(
        "${index.value}/PAPER/",
        PaperList(paperList: papers).toMap(Encryptor(userKey: key.value))
    );
  }

  Paper getPaper(int index) => getPapers()[index];
}