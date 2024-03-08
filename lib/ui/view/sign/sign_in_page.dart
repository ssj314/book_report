import 'package:book_report/ui/controller/sign/sign_in_page_controller.dart';
import 'package:book_report/ui/view/sign/sign_find_password_page.dart';
import 'package:book_report/ui/view/sign/sign_up_page.dart';
import 'package:book_report/ui/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../constant/values.dart';
import '../../controller/universal_controller.dart';

class SignInPage extends StatelessWidget{
  SignInPage({super.key});
  final controller = Get.put(SignInPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(Spacing.medium.size),
              child: Stack(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        child: Center(
                            child: SvgPicture.asset(
                                "images/login.svg",
                                width: 280,
                                height: 280
                            )
                        )
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: double.infinity,
                            color: Get.theme.colorScheme.background.withOpacity(0.85),
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  SignInFormat(),
                                  renderButtonRow()
                                ]
                            )
                        )
                    )
                  ]
              )
          )
        )
    );
  }

  renderButtonRow() {
    return Padding(
        padding: EdgeInsets.only(bottom: getBottomSpacing()),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  child: const Text("회원 가입"),
                  onPressed: () => Get.to(SignUpPage())
              ),
              Material(
                  color: Get.theme.colorScheme.primaryContainer,
                  elevation: 4,
                  borderRadius: BorderRadius.circular(CustomRadius.circle.radius),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(CustomRadius.circle.radius),
                      child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Get.theme.colorScheme.primary,
                              size: 24
                          )
                      ),
                      onTap: () async => controller.submit()
                  )
              )
            ]
        )
    );
  }
}

class SignInFormat extends StatelessWidget {
  SignInFormat({super.key});
  final controller = Get.find<SignInPageController>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.getKey(),
        child: AutofillGroup(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "로그인",
                      style: TextStyle(
                        fontSize: CustomFont.title.size,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  Divider(height: Spacing.small.size, color: Colors.transparent),
                  CustomTextField(
                    label: "E-Mail",
                    autofillHints: const [AutofillHints.email],
                    icon: Icons.alternate_email_rounded,
                    obscure: false,
                    onChanged: (String value) => controller.setEmail(value),
                    validator: (String? value) => controller.checkEmail(value),
                  ),
                  Divider(height: Spacing.medium.size, color: Colors.transparent),
                  CustomTextField(
                    label: "Password",
                    autofillHints: const [
                      AutofillHints.password
                    ],
                    icon: Icons.password_rounded,
                    obscure: true,
                    onChanged: (String value) => controller.setPassword(value),
                    validator: (String? value) => controller.checkPassword(value),
                  ),
                  Divider(height: Spacing.medium.size, color: Colors.transparent),
                  TextButton(
                      child: const Text("비밀번호 변경"),
                      onPressed: () => Get.to(FindPasswordPage())
                  )
                ]
            )
        )
    );
  }
}
