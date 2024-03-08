import 'package:book_report/data/model/user_access_enum.dart';
import 'package:book_report/data/model/user_model.dart';
import 'package:book_report/data/provider/mapping_provider.dart';
import 'package:book_report/data/provider/user_provider.dart';
import 'package:book_report/data/repository/mapping_repository.dart';
import 'package:book_report/data/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User, UserInfo;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/preference_model.dart';
import '../../../data/provider/preference_provider.dart';
import '../../../data/repository/preference_repository.dart';
import '../../../main.dart';
import '../../widget/custom_indicator.dart';

class SignUpPageController extends GetxController {
  var formKey = GlobalKey<FormState>().obs;
  var username = "".obs;
  var password = "".obs;
  var rePassword = "".obs;
  var email = "".obs;

  getKey() => formKey.value;

  setUserName(value) => username.value = value;
  checkUserName(value) {
    if(value == null || value.length < 6) {
      return "사용자명은 최소 6자 이상이어야 합니다.";
    }
  }

  setPassword(value) => password.value = value;
  checkPassword(value) {
    if(value == null || value.length < 6) {
      return "비밀번호는 최소 6자 이상이어야 합니다.";
    }
  }

  setRePassword(value) => rePassword.value = value;
  checkRePassword(String? value) {
    if(value == null || value.isEmpty || value != password.value) {
      return "비밀번호가 일치하지 않습니다. 다시 입력해주세요.";
    }
  }

  setEmail(value) => email.value = value;
  checkEmail(value) {
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
      return "Please enter a valid email address.";
    }
  }

  submit() async {
    var validate = formKey.value.currentState!.validate();
    if(validate) {
      Get.dialog(const CustomIndicator(simple: true));
      try {
        final key = const Uuid().v4().split("-")[0];
        String? uid;
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.value, password: password.value
        ).then((UserCredential value) => uid = value.user?.uid);
        if(uid == null) throw Exception("USER_NOT_FOUND");
        await PreferenceRepository(provider: PreferenceProvider())
            .setPreference(UserPreference(loginHistory: true, uid: uid!));
        await UserRepository(provider: UserProvider(uid: uid!))
            .set(User(userName: username.value, key: key, uid: uid!).toMap());
        await MappingRepository(provider: MappingProvider())
            .update({key: uid});
        Get.offAll(MainPage());
      } on FirebaseAuthException catch(_) {
        Get.back();
      }
    }
  }
}