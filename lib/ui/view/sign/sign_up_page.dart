
import 'package:book_report/ui/controller/sign/sign_up_page_controller.dart';
import 'package:book_report/ui/widget/custom_long_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../controller/universal_controller.dart';
import '../../widget/custom_textfield.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final controller = Get.put(SignUpPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        appBar: CupertinoNavigationBar(
            backgroundColor: Get.theme.colorScheme.background,
            middle: Text(
              "회원 가입",
              style: Get.theme.textTheme.titleMedium,
            )
        ),
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.only(bottom: getBottomSpacing()),
              padding: EdgeInsets.all(Spacing.medium.size),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SignUpFormat(),
                    SignUpButtonRow()
                  ]
              )
          )
        )
    );
  }
}

class SignUpButtonRow extends StatelessWidget {
  SignUpButtonRow({super.key});
  final controller = Get.find<SignUpPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CustomLongButton(
              label: "가입하기",
              onClick: () async => controller.submit()
          ),
          Container(
              padding: const EdgeInsets.all(12),
              child: const Text("or", textAlign: TextAlign.center)
          ),
          CustomLongButton(
              label: "구글 계정으로 로그인",
              onClick: () {}
          ),
          Divider(height: Spacing.medium.size, color: Colors.transparent),
          CustomLongButton(
              label: "카카오톡으로 로그인",
              onClick: () {}
          ),
        ]
    );
  }
}

class SignUpFormat extends StatelessWidget {
  SignUpFormat({super.key});
  final controller = Get.find<SignUpPageController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.getKey(),
      child: AutofillGroup(
        child:  Column(
            children: [
              CustomTextField(
                  label: "Username",
                  icon: Icons.account_circle_rounded,
                  onChanged: (String value) => controller.setUserName(value),
                  validator: (String? value) => controller.checkUserName(value)
              ),
              Divider(height: Spacing.medium.size, color: Colors.transparent),
              CustomTextField(
                  label: "E-Mail",
                  autofillHints: const [AutofillHints.email],
                  icon: Icons.alternate_email_rounded,
                  onChanged: (String value) => controller.setEmail(value),
                  validator: (String? value) => controller.checkEmail(value)
              ),
              Divider(height: Spacing.medium.size, color: Colors.transparent),
              CustomTextField(
                  label: "Password",
                  autofillHints: const [AutofillHints.password],
                  icon: Icons.password_rounded,
                  obscure: true,
                  onChanged: (String value) => controller.setPassword(value),
                  validator: (String? value) => controller.checkPassword(value)
              ),
              Divider(height: Spacing.medium.size, color: Colors.transparent),
              CustomTextField(
                  label: "Re-Password",
                  icon: Icons.password_rounded,
                  obscure: true,
                  onChanged: (String value) => controller.setRePassword(value),
                  validator: (String? value) => controller.checkRePassword(value)
              )
            ]
        )
      )
    );
  }
}
