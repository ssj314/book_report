import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '/ui/controller/data_controller.dart';
import '/ui/controller/main_page_controller.dart';
import '/ui/controller/paper/image_controller.dart';
import '/ui/controller/universal_controller.dart';
import '/ui/controller/user_controller.dart';
import '/ui/view/sign/sign_in_page.dart';
import '/ui/widget/custom_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/firebase_options.dart';
import 'constant/string.dart';
import 'constant/values.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(ImageController());
  Get.put(DataController());
  Get.put(MainPageController());
  Get.put(UserController());
  runApp(const BookTracker());
}

class BookTracker extends StatelessWidget {
  const BookTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appTitle,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: fontFamilyLine,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Theme.of(context).colorScheme.background,
          )
      ),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark
          ),
          useMaterial3: true,
          fontFamily: fontFamilyLine,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Theme.of(context).colorScheme.background,
          )
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
        scrollbars: false
      ),
      themeMode: ThemeMode.system,
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final DataController dataController = Get.find();
  final MainPageController mainPageController = Get.find();
  final UserController userController = Get.find();
  final pageController = PageController();

  init() async {
    try {
      final uid = await userController.hasPreference();
      await userController.getUserData(uid);
      await dataController.init(
        key: userController.getKey(),
        uid: userController.getUid()
      );
      return true;
    } catch(e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return FutureBuilder(
        future: init(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomIndicator(simple: true);
          } else if (!snapshot.hasData) {
            return const Scaffold(body: Center(child: Text(restartText)));
          } else if (snapshot.data as bool) {
            return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Obx(() => mainPageController.getPage()),
                bottomNavigationBar: Container(
                    padding: EdgeInsets.only(bottom: getBottomSpacing()),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(CustomRadius.corner.radius),
                            topRight: Radius.circular(CustomRadius.corner.radius)
                        )
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(CustomRadius.corner.radius),
                            topRight: Radius.circular(CustomRadius.corner.radius)
                        ),
                        child: Theme(
                            data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory
                            ),
                            child: Obx(() => BottomNavigationBar(
                                items: mainPageController.getNavigationItems(),
                                currentIndex: mainPageController.pageIndex.value,
                                onTap: (value) => mainPageController.setPageIndex(value),
                                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                selectedItemColor: Theme.of(context).colorScheme.primary,
                                unselectedItemColor: Theme.of(context).colorScheme.outline,
                                unselectedFontSize: CustomFont.small.size,
                                selectedFontSize: CustomFont.small.size
                            ))
                        )
                    )
                )
            );
          } else {
            return SignInPage();
          }
        }
    );
  }
}
