class AladinBook {
  final List<AladinBookInfo> items;
  AladinBook({required this.items});

  factory AladinBook.fromJson(Map<String, dynamic> json) {
    List<dynamic> parsed = json["item"];
    List<AladinBookInfo> books = [];
    for(var data in parsed) {
      books.add(AladinBookInfo.fromJson(data));
    }
    return AladinBook(items: books);
  }

  toMap() {
    Map<String, dynamic> map = {};
    for(int index = 0; index < items.length; index++) {
      map["$index"] = items[index].toMap();
    }
    return map;
  }
}

class AladinBookInfo {
  String title;
  String desc;
  String isbn;
  String image;
  String author;
  int authorId;
  int pages;

  AladinBookInfo({
    required this.title,
    required this.author,
    required this.authorId,
    required this.desc,
    required this.pages,
    required this.isbn,
    required this.image
  });

  factory AladinBookInfo.fromJson(Map<String, dynamic> json) {
    String title = json['title'];
    String image = json['cover'];
    String desc = json['description'];
    String isbn = json["isbn13"];

    Map<String, dynamic> bookInfo = json["bookinfo"] ?? {};
    int pages = bookInfo['itemPage'] ?? 0;

    List<dynamic> authorData = bookInfo["authors"] ?? [];
    String name = "";
    int authorId = 0;
    for(Map<String, dynamic> author in authorData) {
      if(author["authorType"] == "author") {
        authorId = author["authorid"];
        name = author["name"];
        break;
      }
    }

    return AladinBookInfo(
      title: title,
      author: name,
      authorId: authorId,
      isbn: isbn,
      image: image,
      desc: desc,
      pages: pages,
    );
  }

  toMap() => {
    "TITLE": title,
    "AUTHOR": author,
    "IMAGE": image,
    "DESC": desc,
    "PAGES": pages,
  };
}