import 'dart:convert';

import '/data/model/book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/user_model.dart';

class UserProvider {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  UserProvider({required this.uid});
  final String uid;

  Future<bool> set(Object data) async {
    try {
      await ref.child("USER_DATA/$uid").set(data);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> update(Map<String, dynamic> data) async {
    try {
      await ref.child("USER_DATA/$uid").update(data);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> remove() async {
    try {
      await ref.child("USER_DATA/$uid").remove();
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<User?> getUser() async {
    final snapshot = await ref.child("USER_DATA/$uid").get();
    if(snapshot.value == null) {
      throw Exception("Error");
    } else {
      final jsonRes = jsonDecode(jsonEncode(snapshot.value));
      return User.fromJson(jsonRes);
    }
  }

  Stream<DatabaseEvent> getUserStream() => ref.child("USER_DATA/$uid").onValue;
}