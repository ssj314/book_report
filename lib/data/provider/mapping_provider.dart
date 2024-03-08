import 'dart:convert';

import '/data/model/book_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/mapping_model.dart';
import '../model/user_model.dart';

class MappingProvider {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<bool> set(Object data) async {
    try {
      await ref.child("MAPPING").set(data);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> update(Map<String, dynamic> data) async {
    try {
      await ref.child("MAPPING").update(data);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> remove(String reference) async {
    try {
      await ref.child("MAPPING/$reference").remove();
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<String?> get(String reference) async {
    final snapshot = await ref.child("MAPPING/$reference").get();
    if(snapshot.value == null) {
      throw Exception("Error");
    } else {
      return snapshot.value.toString();
    }
  }

  Future<Mapping?> getAll() async {
    final DataSnapshot snapshot = await ref.child("MAPPING").get();
    if(snapshot.value == null) {
      throw Exception("Error");
    } else {
      return Mapping.fromJson(jsonDecode(jsonEncode(snapshot.value)));
    }
  }
}