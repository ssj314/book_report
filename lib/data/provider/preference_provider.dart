import '/data/model/preference_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceProvider {
  Future<UserPreference> getPreference() async {
    final pref = await SharedPreferences.getInstance();
    return UserPreference.fromMap({
      "LOGIN_HISTORY": pref.getBool("LOGIN_HISTORY") ?? false,
      "UID": pref.getString("UID") ?? "",
    });
  }

  setPreference(UserPreference user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("UID", user.uid);
    pref.setBool("LOGIN_HISTORY", user.loginHistory);
  }

  removePreference() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("UID");
    pref.remove("LOGIN_HISTORY");
  }
}