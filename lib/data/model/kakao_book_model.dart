class KakaoBook {
  final List<KakaoBookInfo> items;
  KakaoBook({required this.items});

  factory KakaoBook.fromJson(Map<String, dynamic> json) {
    List<dynamic> parsed = json["documents"];
    List<KakaoBookInfo> books = [];
    for(var data in parsed) {
      try {
        books.add(KakaoBookInfo.fromJson(data));
      } catch(e) {
        print(e);
        print(data);
      }
    }
    return KakaoBook(items: books);
  }
}

class KakaoBookInfo {
  final String title;
  final String isbn;
  final String image;
  final String author;

  KakaoBookInfo({
    required this.title,
    required this.isbn,
    required this.image,
    required this.author
  });

  factory KakaoBookInfo.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    String image = json['thumbnail'];
    String isbn = json["isbn"];
    String author = "";
    if(json["authors"].isNotEmpty) author = json["authors"][0];

    return KakaoBookInfo(
      title: title,
      isbn: isbn,
      image: image,
      author: author
    );
  }
}