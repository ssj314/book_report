/*import 'package:app_book_tracker/constant/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleButton extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(CustomRadius.corner.radius),
        elevation: clicked?1:4,
        child: GestureDetector(
            child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.only(left: insetRegular, right: insetRegular),
                height: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(CustomRadius.corner.radius)
                ),
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Image.asset("images/google_icon.png",
                            width: iconLarge1,
                            height: iconLarge1
                        )
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Text(googleButtonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontRegular2,
                              color: Theme.of(context).colorScheme.outline,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold
                          ),
                        )
                    )
                  ],
                )
            ),
            onTapDown: (dt) => setState(() => clicked = true),
            onTapUp: (dt) => setState(() => clicked = false),
            onTap: () => setState(() {
              signIn();
            })
        )
    );
  }

  signIn() async {
*//*    UserCredential auth;
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    auth = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    return auth.user;*//*
  }

}

renderKakaoLoginButton() {
  return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(buttonRadius),
      color: const Color(0xfffee500),
      child: InkWell(
          borderRadius: BorderRadius.circular(buttonRadius),
          child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.only(left: insetRegular, right: insetRegular),
              height: longButtonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(buttonRadius),
              ),
              child: Stack(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset("images/kakao_icon.png",
                          width: iconLarge1,
                          height: iconLarge1
                      )
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text("카카오톡으로 로그인하기",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontFamily: "LINE",
                            fontSize: fontRegular2,
                            height: 1.0
                        ),
                      )
                  )
                ],
              )
          ),
          onTap: () {}
      )
  );
}*/

