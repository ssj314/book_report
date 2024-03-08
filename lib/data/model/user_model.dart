import '/data/model/user_access_enum.dart';

enum Follow {
  none(label: "none"),
  follow(label: "follow"),
  friend(label: "friend");

  final String label;
  const Follow({required this.label});

  factory Follow.parse(String? label) {
    switch(label) {
      case "follow":
        return Follow.follow;
      case "friend":
        return Follow.friend;
      default:
        return Follow.none;
    }
  }
}

class FollowUser {
  String userName;
  String uid;
  String key;
  String? intro;
  String? image;
  Follow? follow;

  String getUsername() => userName;
  String? getImage() => image;
  bool hasImage() => (image != null);

  Follow? getFollow() => follow;
  String getUid() => uid;
  String getKey() => key;
  String? getIntro() => intro;
  bool hasIntro() => (intro != null);

  FollowUser({
    this.userName = "",
    this.key = "",
    this.uid = "",
    this.intro,
    this.image,
    this.follow
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    final userName = json[UserModel.userName.label];
    final key = json[UserModel.key.label];
    final uid = json[UserModel.uid.label];
    final follow = Follow.parse(json[UserModel.follow.label]);
    final intro = json[UserModel.intro.label];
    final image = json[UserModel.image.label];

    return FollowUser(
        image: image,
        uid: uid,
        userName: userName,
        key: key,
        intro: intro,
        follow: follow
    );
  }

  toMap() {
    Map<String, dynamic> map = {
      UserModel.userName.label: userName,
      UserModel.key.label: key,
      UserModel.uid.label: uid,
    };

    if(follow != null) map[UserModel.follow.label] = follow!.label;
    if(intro != null) map[UserModel.intro.label] = intro;
    if(image != null) map[UserModel.image.label] = image;
    return map;
  }
}

class User {
  String userName;
  String uid;
  String key;
  String? intro;
  String? image;
  late UserAccess access;
  late List<FollowUser> follower;
  late List<FollowUser> following;

  User({
    this.userName = "",
    this.key = "",
    this.uid = "",
    this.intro,
    this.image,
    UserAccess? access,
    List<FollowUser>? follower,
    List<FollowUser>? following,
  }) {
    this.follower = follower ?? [];
    this.following = following ?? [];
    this.access = access ?? UserAccess.public;
  }

  String getUsername() => userName;
  String? getImage() => image;
  bool hasImage() => (image != null);

  String getUid() => uid;
  String getKey() => key;
  String? getIntro() => intro;
  bool hasIntro() => (intro != null);
  void setIntro(String intro) => this.intro = intro;
  UserAccess getAccess() => access;

  factory User.fromJson(Map<String, dynamic> json) {
    final userName = json[UserModel.userName.label];
    final key = json[UserModel.key.label];
    final uid = json[UserModel.uid.label];
    final intro = json[UserModel.intro.label];
    final image = json[UserModel.image.label];
    final access = UserAccess.parse(json[UserModel.access.label]);
    final following = <FollowUser>[];
    final follower = <FollowUser>[];

    final List<dynamic> followingJson = json[UserModel.following.label] ?? [];
    if(followingJson.isNotEmpty) {
      following.addAll(List.generate(followingJson.length, (index) => FollowUser.fromJson(followingJson[index])));
    }

    final List<dynamic> followerJson = json[UserModel.follower.label] ?? [];
    if(followerJson.isNotEmpty) {
      follower.addAll(List.generate(followerJson.length, (index) => FollowUser.fromJson(followerJson[index])));
    }

    return User(
      image: image,
      uid: uid,
      userName: userName,
      key: key,
      intro: intro,
      access: access,
      following: following,
      follower: follower
    );
  }

  simplify(Follow? follow) => FollowUser(
      uid: uid,
      key: key,
      image: image,
      userName: userName,
      intro: intro,
      follow: follow
  );

  toMap() {
    Map<String, dynamic> map = {
      UserModel.userName.label: userName,
      UserModel.key.label: key,
      UserModel.uid.label: uid,
    };

    if(intro != null) map[UserModel.intro.label] = intro;
    if(image != null) map[UserModel.image.label] = image;
    map[UserModel.access.label] = access.access;
    if(follower.isNotEmpty) map[UserModel.follower.label] = _listToMap(follower);
    if(following.isNotEmpty) map[UserModel.following.label] = _listToMap(following);
    return map;
  }

  List<dynamic> _listToMap(List<FollowUser> list) {
    List<dynamic> tmpMap = [];
    for(int i = 0; i < list.length; ++i) {
      tmpMap.add(list[i].toMap());
    }
    return tmpMap;
  }
}

enum UserModel {
  userName(label: "USER_NAME"),
  key(label: "KEY"),
  uid(label: "UID"),
  access(label: "ACCESS"),
  intro(label: "INTRO"),
  image(label: "IMAGE"),
  following(label: "FOLLOWING"),
  follower(label: "FOLLOWER"),
  follow(label: "FOLLOW"),
  pending(label: "PENDING");

  final String label;
  const UserModel({required this.label});
}
