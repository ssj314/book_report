import 'package:book_report/data/model/book_model.dart';
import 'package:book_report/data/model/paper_model.dart';
import 'package:book_report/data/provider/book_provider.dart';
import 'package:book_report/data/repository/book_repository.dart';
import 'package:get/get.dart';
import '../encrypter.dart';

class FriendController extends GetxController {
  var index = RxInt(0);
  final books = RxList<BookData>([]);

  init({required String uid, required String key}) async {
    try {
      final bookRepo = BookRepository(provider: BookProvider(uid: uid));
      books(await bookRepo.getBookDatabase(Encryptor(userKey: key), false));
      books.refresh();
    } catch(e) {
      throw Exception();
    }
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

  setIndex(value) => index.value = value;
  getIndex() => (index.value < 0)?0:index.value;
  isCurrentIndex(idx) => index.value == idx;

  List<Paper> getPapers() => getBook(index.value).paperList;
  int getPaperCount() => getPapers().length;
  Paper getPaper(int index) => getPapers()[index];
}