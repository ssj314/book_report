import 'dart:typed_data';

import '/data/provider/storage_provider.dart';

class StorageRepository {
  final StorageProvider provider;
  StorageRepository({required this.provider});

  putData(String ref, Uint8List data) async {
    try {
      await provider.putData(ref, data);
    } catch(e) {
      throw Exception(e);
    }
  }

  Future<Uint8List> getData(ref) async {
    try {
      return await provider.getData(ref);
    } catch(e) {
      throw Exception(e);
    }
  }

  getDownloadURL(String ref) async {
    try {
      return await provider.getDownloadURL(ref);
    } catch(e) {
      throw Exception(e);
    }
  }

  removeData(String ref) async {
    try {
      await provider.removeData(ref);
    } catch(e) {
      throw Exception("NOT_FOUND");
    }
  }
}