import '/data/model/user_access_enum.dart';
import '/ui/controller/encrypter.dart';

class PaperImage {
  List<String> images = [];
  PaperImage({required this.images});

  factory PaperImage.fromJson(List<dynamic> json) {
    List<String> images = [];
    for(var name in json) {
      images.add(name);
    }

    return PaperImage(images: images);
  }

  factory PaperImage.copyWith(PaperImage image)  {
    return PaperImage(
        images: List.from(image.images)
    );
  }


  toMap() {
    Map<String, dynamic> map = {};
    for(int index = 0; index < images.length; index++) {
      map["$index"] = images[index];
    }
    return map;
  }
}

class PaperContent {
  String title;
  String chapter;
  String summary;
  String comment;

  PaperContent({
    required this.title,
    required this.chapter,
    required this.summary,
    required this.comment
  });

  factory PaperContent.fromJson(Map<String, dynamic> json, Encryptor encrypter) {
    String title = (json["TITLE"] != null)?encrypter.decrypt(json["TITLE"]):"";
    String chapter = (json["CHAPTER"] != null)?encrypter.decrypt(json["CHAPTER"]):"";

    String summary = (json["SUMMARY"] != null)?encrypter.decrypt(json["SUMMARY"]):"";
    String comment = (json["COMMENT"] != null)?encrypter.decrypt(json["COMMENT"]):"";

    return PaperContent(
        title: title,
        chapter: chapter,
        summary: summary,
        comment: comment
    );
  }

  factory PaperContent.empty() {
    return PaperContent(
        title: "",
        chapter: "",
        summary: "",
        comment: ""
    );
  }

  factory PaperContent.copyWith(PaperContent content)  {
    return PaperContent(
        title: content.title,
        chapter: content.chapter,
        summary: content.summary,
        comment: content.comment
    );
  }

  toMap(Encryptor encrypter) {
    return {
      "TITLE": encrypter.encrypt(title),
      "CHAPTER": (chapter.isNotEmpty)?encrypter.encrypt(chapter):null,
      "SUMMARY": (summary.isNotEmpty)?encrypter.encrypt(summary):null,
      "COMMENT": (comment.isNotEmpty)?encrypter.encrypt(comment):null
    };
  }
}

class Paper {
  PaperContent content;
  String lastDate;
  int pageStart;
  int pageEnd;
  UserAccess access;
  PaperImage image;
  int bgColor;

  Paper({
    required this.content,
    required this.image,
    required this.lastDate,
    required this.pageStart,
    required this.pageEnd,
    required this.access,
    required this.bgColor
  });

  factory Paper.fromJson(Map<String, dynamic> json, Encryptor encrypter, isUser) {

    UserAccess access = UserAccess.parse(json["ACCESS"] ?? "PRIVATE");
    if(!isUser && access == UserAccess.private) {

      throw Exception();

    }

    PaperContent content = PaperContent.fromJson(json["CONTENT"], encrypter);

    PaperImage image;
    if(json["IMAGE"] == null) {
      image = PaperImage(images: []);
    } else {
      image = PaperImage.fromJson(json["IMAGE"]);
    }

    String lastDate = json["LAST_DATE"];
    int pageStart = json["PAGE_START"] ?? 0;
    int pageEnd = json["PAGE_END"] ?? 0;
    int bgColor = json["BG_COLOR"] ?? -1;

    return Paper(
        content: content,
        image: image,
        lastDate: lastDate,
        pageStart: pageStart,
        pageEnd: pageEnd,
        access: access,
        bgColor: bgColor
    );
  }

  factory Paper.empty()  {
    return Paper(
        content: PaperContent.empty(),
        image: PaperImage(images: []),
        lastDate: "",
        pageStart: 0,
        pageEnd: 0,
        access: UserAccess.public,
        bgColor: -1
    );
  }

  factory Paper.copyWith(Paper paper)  {
    return Paper(
        content: PaperContent.copyWith(paper.content),
        image: PaperImage.copyWith(paper.image),
        lastDate: paper.lastDate,
        pageStart: paper.pageStart,
        pageEnd: paper.pageEnd,
        access: paper.access,
        bgColor: paper.bgColor
    );
  }

  toMap(Encryptor encrypter) {
    return {
      "BG_COLOR": bgColor,
      "CONTENT": content.toMap(encrypter),
      "LAST_DATE": lastDate,
      "PAGE_START": pageStart,
      "PAGE_END": pageEnd,
      "ACCESS": access.access,
      "IMAGE": image.toMap(),
    };
  }
}

class PaperList {
  final List<Paper> paperList;
  PaperList({required this.paperList});

  factory PaperList.fromJson(List<dynamic> json, Encryptor encrypter, isUser) {
    List<Paper> papers = [];
    for(var paper in json) {
      try {
        papers.add(Paper.fromJson(paper, encrypter, isUser));
      } catch(_) {}
    }
    return PaperList(paperList: papers);
  }

  toMap(Encryptor encrypter) {
    Map<String, dynamic> map = {};
    for(int index = 0; index < paperList.length; ++index) {
        map["$index"] = paperList[index].toMap(encrypter);
    }
    return map;
  }
}
