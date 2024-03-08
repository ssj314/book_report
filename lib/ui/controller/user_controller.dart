import 'dart:convert';

import 'package:book_report/data/provider/user_provider.dart';
import 'package:book_report/data/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, UserInfo;
import 'package:get/get.dart';

import '../../data/model/user_model.dart';
import '../../data/provider/preference_provider.dart';
import '../../data/repository/preference_repository.dart';

enum UserException {
  notFound(label: "USER_NOT_FOUND");
  final String label;
  const UserException({required this.label});
}

class UserController extends GetxController {
  final user = User().obs;

  getUid() => user.value.getUid();
  getKey() => user.value.getKey();

  hasPreference() async {
    final repo = PreferenceRepository(provider: PreferenceProvider());
    final pref = await repo.getPreference();
    if(pref.loginHistory && pref.uid.isNotEmpty) return pref.uid;
    throw Exception(UserException.notFound.label);
  }

  getUserData(String uid) async {
    try {
      final repo = UserRepository(provider: UserProvider(uid: uid));
      final value = await repo.getUser();
      if(value != null) {
        await setUser(value);
        repo.getUserStream().listen((event) {
          if(event.snapshot.value != null) {
            final jsonRes = jsonDecode(jsonEncode(event.snapshot.value));
            setUser(User.fromJson(jsonRes));
          }
        });
      } else {
        throw Exception();
      }
    } catch(_) {
      throw Exception(UserException.notFound.label);
    }
  }

  setUser(User user) async {
    this.user(user);
    this.user.refresh();
  }

  User getUser() => user.value;

  removeAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      await UserRepository(provider: UserProvider(uid: getUid())).remove();
      await PreferenceRepository(provider: PreferenceProvider()).removePreference();
    } catch(e) {
      throw Exception(e);
    }
  }

  logout() async {
    try {
      final repo = PreferenceRepository(provider: PreferenceProvider());
      await repo.removePreference();
    } catch(e) {
      throw Exception(e);
    }
  }


  // friends

  // User Subscribing Me
  List<FollowUser> getFollower() => user.value.follower;
  int getFollowerCount() => user.value.follower.length;
  bool hasFollower() => user.value.follower.isNotEmpty;


  // User I Subscribe
  List<FollowUser> getFollowing() => user.value.following;
  hasFollowing() => user.value.following.isNotEmpty;
  getFollowingCount() => user.value.following.length;

  // Add New User I Follow
  contains(List<FollowUser> list, String uid) {
    for(var user in list) {
      if(user.uid == uid) return true;
    }
    return false;
  }

  int search(List<FollowUser> list, String uid) {
    for(int index = 0; index < list.length; index++) {
      if(list[index].uid == uid) return index;
    }
    return -1;
  }

  addFollowing(String uid) async {
    if(contains(getFollowing(), uid)) {
      // Already Following this User
      return UserResult.exist;
    } else if(contains(getFollower(), uid)) {
      // Already Following Me (Followers)
      return await acceptFollower(uid);
    } else {
      try {
        final friendRepo = UserRepository(provider: UserProvider(uid: uid));
        final friend = await friendRepo.getUser();
        // User Not Found
        if(friend == null) {
          return UserResult.notFound;
        } else if(contains(friend.follower, getUid())) {
          // Already Sent a Request (Error Case)
          return UserResult.sent;
        } else if(contains(friend.following, getUid())) {
          // He follows you Already (Error Case)
          user.value.following.add(friend.simplify(Follow.follow));
          user.refresh();
          return await acceptFollower(uid);
        } else {
          // Totally New Follow. I'm your Follower Now.
          final repo = UserRepository(provider: UserProvider(uid: getUid()));
          user.value.following.add(friend.simplify(Follow.follow));
          user.refresh();
          await repo.set(user.value.toMap());

          friend.follower.add(user.value.simplify(Follow.follow));
          await friendRepo.set(friend.toMap());
          return UserResult.success;
        }
      } catch(e) {
        return UserResult.error;
      }
    }
  }

  acceptFollower(String uid) async {
    // Already in my follower list;

    final friendRepo = UserRepository(provider: UserProvider(uid: uid));
    final friend = await friendRepo.getUser();
    if(friend == null) return UserResult.notFound;

    final rIndex = search(getFollower(), uid);
    user.value.follower.elementAt(rIndex).follow = Follow.friend;
    user.value.following.add(friend.simplify(Follow.friend));
    user.refresh();
    final repo = UserRepository(provider: UserProvider(uid: getUid()));
    await repo.set(getUser().toMap());

    final iIndex = search(friend.following, getUid());
    friend.following.elementAt(iIndex).follow = Follow.friend;
    friend.follower.add(user.value.simplify(Follow.friend));
    await friendRepo.set(friend.toMap());
    return UserResult.success;
  }

  removeFollow(int index) async {
    /*String id = getUser().friends[index];
    getUser().friends.removeAt(index);
    friends.remove(id);
    final repo = UserRepository(provider: UserProvider(uid: getUid()));
    await repo.set(getUser().toMap());*/
  }

  getIntro() {
    if(user.value.hasIntro()) {
      return user.value.getIntro();
    } else {
      return "#";
    }
  }

  setIntro(String text) async {
    user.value.setIntro(text);
    final repo = UserRepository(provider: UserProvider(uid: getUid()));
    await repo.set(getUser().toMap());
  }
}

enum UserResult {
  exist,
  sent,
  notFound,
  success,
  error
}