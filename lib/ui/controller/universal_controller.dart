
import 'package:flutter/foundation.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

const bottomSpacing = 24.0;

double getBottomSpacing() {
  final platform = getPlatform();
  if(platform == UserPlatform.safari) {
    return bottomSpacing;
  } else {
    return 0;
  }
}

UserPlatform getPlatform() {
  if(kIsWeb) {
    final browser = Browser();
    switch(browser.browser) {
      case "Safari":
        return UserPlatform.safari;
      default:
        return UserPlatform.windows;
    }
  } else {
    switch(defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UserPlatform.ios;
      case TargetPlatform.android:
        return UserPlatform.android;
      default:
        return UserPlatform.etc;
    }
  }
}

List<String> mapToList(Map<String, dynamic> map, String type) {
  final list = map[type] ?? [];
  final tmpList = <String>[];
  for(var item in list) {
    tmpList.add(item);
  }
  return tmpList;
}

enum UserPlatform {
  safari, windows, ios, android, etc;
}