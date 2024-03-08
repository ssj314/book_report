import 'dart:convert';

import '/data/model/book_model.dart';
import '/ui/controller/encrypter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookProvider {
  final String uid;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Reference storageRef = FirebaseStorage.instance.ref();

  BookProvider({required this.uid});

  getBookDatabase(Encryptor encrypter, bool isUser) async {
    try {
      final src = ref.child("BOOK_DATA/$uid");
      return await src.get().then((snapshot) {
        if(snapshot.value == null) {
          return <BookData>[];
        } else {
          final jsonRes = jsonDecode(jsonEncode(snapshot.value));
          return BookList.fromJson(jsonRes, encrypter, isUser).items;
        }
      });
    } catch(e) {
      return [];
    }
  }

  Future<bool> set(String? reference, Object data) async {
    try {
      if(reference == null) {
        await ref.child("BOOK_DATA/$uid").set(data);
      } else {
        await ref.child("BOOK_DATA/$uid/$reference").set(data);
      }
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> update(String? reference, Map<String, dynamic> data) async {
    try {
      if(reference == null) {
        await ref.child("BOOK_DATA/$uid").set(data);
      } else {
        await ref.child("BOOK_DATA/$uid/$reference").set(data);
      }
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> remove(String reference) async {
    try {
      await ref.child("BOOK_DATA/$uid/$reference").remove();
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<bool> removeAll() async {
    try {
      await ref.child("BOOK_DATA/$uid").remove();
      return true;
    } catch(e) {
      return false;
    }
  }
}