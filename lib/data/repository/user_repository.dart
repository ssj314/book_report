
import 'package:firebase_database/firebase_database.dart';

import '../model/user_model.dart';
import '../provider/user_provider.dart';

class UserRepository {
  final UserProvider provider;
  UserRepository({required this.provider});

  set(Object data) async {
    return await provider.set(data);
  }

  update(Map<String, dynamic> data) async {
    return await provider.update(data);
  }

  remove() async {
    return await provider.remove();
  }

  Future<User?> getUser() async {
    try {
      return await provider.getUser();
    } catch(e) {
      throw Exception(e);
    }
  }

  Stream<DatabaseEvent> getUserStream() {
    try {
      return provider.getUserStream();
    } catch(e) {
      throw Exception(e);
    }
  }
}