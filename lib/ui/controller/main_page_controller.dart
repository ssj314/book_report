import 'package:book_report/ui/view/search/search_page.dart';
import 'package:book_report/ui/view/social/social_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/library/library_page.dart';
import '../widget/custom_snackbar.dart';

class MainPageController extends GetxController {
  var pageIndex = 0.obs;

  getNavigationItems() {
    const values = NavigationItems.values;
    return List.generate(values.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(values[index].icon),
              label: values[index].label
            )
    );
  }

  getPage() {
    switch(pageIndex.value) {
      case 0:
        return LibraryPage();
      case 1:
        return SearchPage();
      case 2:
        return SocialPage();
    }
  }

  setPageIndex(index) => pageIndex.value = index;
}

enum NavigationItems {
  library("보관함", Icons.folder_rounded),
  search("검색", Icons.search_rounded),
  social("소셜", Icons.group_rounded);

  final String label;
  final IconData icon;
  const NavigationItems(this.label, this.icon);
}