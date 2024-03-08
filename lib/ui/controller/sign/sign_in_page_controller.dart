import 'package:book_report/data/provider/preference_provider.dart';
import 'package:book_report/data/repository/preference_repository.dart';
import 'package:book_report/ui/widget/custom_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/model/preference_model.dart';
import '../../../main.dart';

class SignInPageController extends GetxController {
  var formKey = GlobalKey<FormState>().obs;
  var password = "".obs;
  var email = "".obs;

  getKey() => formKey.value;

  setPassword(value) => password.value = value;
  checkPassword(String? value) {
    if(value == null || value.length < 6) {
      return "비밀번호는 최소 6자 이상이어야 합니다.";
    }
  }

  setEmail(value) => email.value = value;
  checkEmail(value) {
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
      return "이메일 주소 형식이 올바르지 않습니다.";
    }
  }

  submit() async {
    var validate = formKey.value.currentState!.validate();
    if(validate) {
      Get.dialog(const CustomIndicator(simple: true), barrierDismissible: false);
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.value,
          password: password.value,
        );
        final uid = credential.user?.uid;
        final repo = PreferenceRepository(provider: PreferenceProvider());
        await repo.setPreference(UserPreference(
            loginHistory: true,
            uid: uid!
        ));
        Get.offAll(() => MainPage());
      } on FirebaseAuthException catch(e) {
        Get.back();
        Get.snackbar(
            "로그인 실패",
            e.toString(),
            duration: const Duration(seconds: 5),
        );
      }
    }
  }
}