class UserPreference {
  final bool loginHistory;
  final String uid;

  UserPreference({
    required this.loginHistory,
    required this.uid
  });

  factory UserPreference.fromMap(Map<String, dynamic> map) {
    bool loginHistory = map["LOGIN_HISTORY"];
    String uid = map["UID"];
    return UserPreference(loginHistory: loginHistory, uid: uid);
  }
}