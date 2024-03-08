import '/data/model/paper_model.dart';

import '../../ui/controller/encrypter.dart';

class BookInfo {
  String title;
  String author;
  String isbn;
  int authorId;
  String thumbnail;
  String desc;
  bool interest;
  int pages;

  BookInfo({
    required this.title,
    required this.author,
    required this.authorId,
    required this.thumbnail,
    required this.desc,
    required this.isbn,
    required this.interest,
    required this.pages
  });

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    String title = json['TITLE'];
    String author = json['AUTHOR'];
    String thumbnail = json['IMAGE'];
    String isbn = json["ISBN"];
    int authorId = json['AUTHOR_ID'] ?? 0;
    bool interest = json["INTEREST"] ?? false;
    String desc = json['DESC'];
    int pages = json['PAGES'] ?? 0;

    return BookInfo(
        title: title,
        author: author,
        authorId: authorId,
        isbn: isbn,
        thumbnail: thumbnail,
        desc: desc,
        interest: interest,
        pages: pages
    );
  }

  toMap() => {
    "TITLE": title,
    "AUTHOR": author,
    "IMAGE": thumbnail,
    "DESC": desc,
    "PAGES": pages,
    "ISBN": isbn,
    "INTEREST": interest
  };
}

class SimpleBookInfo {
  String image;
  String title;
  String isbn;
  String author;

  SimpleBookInfo({
    required this.image,
    required this.title,
    required this.isbn,
    required this.author
  });

  factory SimpleBookInfo.fromJson(Map<String, dynamic> json) {
    String image = json["IMAGE"];
    String title = json["TITLE"];
    String isbn = json["ISBN"];
    String author = json["AUTHOR"] ?? "";
    return SimpleBookInfo(author: author, image: image, title: title, isbn: isbn);
  }

  toMap() => {"IMAGE": image, "TITLE": title, "ISBN": isbn};
}

class BookData {
  List<Paper> paperList;
  dynamic info;

  BookData({
    required this.info,
    required this.paperList
  });

  factory BookData.fromJson(dynamic json, Encryptor encrypter, bool isUser) {
    BookInfo info;
    PaperList list;

    if(json["INFO"] != null) {
      info = BookInfo.fromJson(json["INFO"]);
    } else {
      throw const FormatException();
    }

    if(json["PAPER"] != null) {
      list = PaperList.fromJson(json["PAPER"], encrypter, isUser);
    } else {
      list = PaperList(paperList: []);
    }

    return BookData(
        info: info,
        paperList: list.paperList
    );
  }

  toMap(Encryptor encrypter) {
    Map<String, dynamic> map = {
      "INFO": info.toMap(),
      "PAPER": PaperList(paperList: paperList).toMap(encrypter)
    };
    return map;
  }
}

class BookList {
  List<BookData> items;
  BookList({required this.items});

  factory BookList.fromJson(dynamic json, Encryptor encrypter, bool isUser) {
    List<BookData> books = [];
    for(var data in json) {
      if(data != null) {
        books.add(BookData.fromJson(data, encrypter, isUser));
      }
    }

    return BookList(items: books);
  }

  toMap(Encryptor encrypter) {
    Map<String, dynamic> map = {};
    for(int index = 0; index < items.length; index++) {
      map["$index"] = items[index].toMap(encrypter);
    }
    return map;
  }
}