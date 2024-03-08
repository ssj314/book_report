
import 'package:book_report/ui/widget/custom_long_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../controller/universal_controller.dart';
import '../../widget/custom_indicator.dart';
import '../../widget/custom_textfield.dart';

class FindPageController extends GetxController {
  var formKey = GlobalKey<FormState>().obs;
  var password = "".obs;
  var email = "".obs;

  getKey() => formKey.value;

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
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: email.value
        );
        Get.back();
        Get.back();
        Get.snackbar("전송 완료", "해당 이메일 주소로 재설정 링크가 전송되었습니다.");
      } on FirebaseAuthException catch(e) {
        Get.back();
        if(e.code == "user-not-found") {
          Get.snackbar("전송 실패", "존재하지 않는 계정입니다. 다시 입력해주세요.");
        } else if(e.code == "invalid-email"){
          Get.snackbar("전송 실패", "올바르지 않는 이메일 형식입니다. 다시 입력해주세요.");
        } else {
          Get.snackbar("전송 실패", "오류가 발생했습니다. 다시 시도해주세요.");
        }
      }
    }
  }
}

class FindPasswordPage extends StatelessWidget {
  FindPasswordPage({super.key});
  final controller = Get.put(FindPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
            backgroundColor: Get.theme.colorScheme.background,
            middle: Text(
              "비밀번호 변경",
              style: Get.theme.textTheme.titleMedium,
            )
        ),
        body: Container(
            margin: EdgeInsets.only(bottom: getBottomSpacing()),
            padding: EdgeInsets.all(Spacing.medium.size),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("비밀번호를 잊어버리셨나요?",
                        style: TextStyle(
                          height: 1,
                          fontSize: Theme.of(context).textTheme.titleLarge?.fontSize
                        ),
                      ),
                      Divider(
                        height: Spacing.medium.size,
                        color: Colors.transparent,
                      ),
                      Text("작성한 이메일로 재설정 링크를 보내드릴게요.",
                        style: TextStyle(
                            height: 1,
                            fontSize: Theme.of(context).textTheme.titleSmall?.fontSize
                        ),
                      ),
                      Divider(
                        height: Spacing.medium.size,
                        color: Colors.transparent,
                      ),
                      SignUpFormat(),
                    ],
                  ),
                  CustomLongButton(label: "비밀번호 변경", onClick: () {
                    controller.submit();
                  })
                ]
            )
        )
    );
  }
}



class SignUpFormat extends StatelessWidget {
  SignUpFormat({super.key});
  final controller = Get.find<FindPageController>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.getKey(),
        child: AutofillGroup(
            child: CustomTextField(
                label: "E-Mail",
                autofillHints: const [AutofillHints.email],
                icon: Icons.alternate_email_rounded,
                onChanged: (String value) => controller.setEmail(value),
                validator: (String? value) => controller.checkEmail(value)
            )
        )
    );
  }
}
