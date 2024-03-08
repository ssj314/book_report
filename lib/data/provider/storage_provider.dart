import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageProvider {
  final String uid;
  Reference storageRef = FirebaseStorage.instance.ref();

  StorageProvider({required this.uid});

  putData(String ref, Uint8List data) async {
    try {
      await storageRef.child("IMAGES/$uid/$ref").putData(data);
    } catch(e) {
      throw Exception(e);
    }
  }

  getData(ref) async {
    try {
      return await storageRef.child("IMAGES/$uid/$ref").getData();
    } catch(e) {
      throw Exception(e);
    }
  }

  getDownloadURL(String ref) async {
    try {
      return await storageRef.child("IMAGES/$uid/$ref").getDownloadURL();
    } catch(e) {
      throw Exception(e);
    }
  }

  removeData(ref) async {
    try {
      await storageRef.child("IMAGES/$uid/$ref").delete();
    } catch(e) {
      throw Exception(e);
    }
  }
}