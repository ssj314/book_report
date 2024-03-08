import 'dart:convert';

import '/data/model/aladin_book_model.dart';
import '/data/model/book_model.dart';
import '/data/model/kakao_book_model.dart';
import '../provider/rest_api_provider.dart';

class RestAPIRepository {

  final RestAPIProvider provider;
  RestAPIRepository({required this.provider});

  sendRequest({required RequestMethod method, required String query}) async {
    if(query.isEmpty) return null;
    final result = await provider.sendRequest(method: method, query: query);
    switch(method) {
      case RequestMethod.aladin:
        if(result == null) {
          throw Exception("No Result");
        }
        final item = AladinBook.fromJson(jsonDecode(result)).items[0];
        final pages = item.pages;
        return BookInfo(
          authorId: item.authorId,
          pages: pages,
          author: item.author,
          desc: item.desc,
          thumbnail: item.image,
          title: item.title,
          isbn: item.isbn,
          interest: false,
        );
      case RequestMethod.kakao:
        final book = KakaoBook.fromJson(jsonDecode(result));
        return List.generate(book.items.length, (index) {
          var item = book.items[index];
          return SimpleBookInfo(
              author: item.author,
              image: item.image,
              title: item.title,
              isbn: item.isbn
          );
        });
      case RequestMethod.url:
        return null;
    }
  }
}