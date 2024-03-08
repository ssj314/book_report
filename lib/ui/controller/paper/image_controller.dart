import 'dart:typed_data';

import 'package:book_report/ui/controller/universal_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:uuid/uuid.dart';

import '../../../data/model/image_model.dart';
import '../../../data/provider/storage_provider.dart';
import '../../../data/repository/storage_repository.dart';

enum ImageError { fileNotFound, maxExtent, maxSize, success }

class ImageController extends GetxController {
  final images = <ImagePile>[].obs;
  final newImage = ImagePile().obs;
  final uid = "".obs;
  final index = 0.obs;
  final maxCount = 5;
  final maxSize = 1024 * 1024 * 5;

  init({required String id, required dynamic items}) async {
    clean();
    uid.value = id;
    final repo = StorageRepository(provider: StorageProvider(uid: id));
    for(List<String> item in items) {
      final pile = ImagePile();
      for(String name in item) {
        try {
          pile.add(ImageAsset(
              name: name,
              url: await repo.getDownloadURL(name),
              remove: false
          ));
        } catch(_) {}
      }
      images.add(pile);
    }
    images.refresh();
  }

  clean() {
    uid.value = "";
    images.clear();
    index.value = 0;
    newImage.value = ImagePile();
  }

  List<String> getImageNames() {
    List<String> names = [];
    for(ImageAsset asset in getImagePile().toList()) {
      names.add(asset.name);
    }
    return names;
  }

  ImagePile getImagePile({int idx = -1}) {
    if(idx != -1) {
      return images[idx];
    } else  if(index.value == -1) {
      return newImage.value;
    } else {
      return images[index.value];
    }
  }

  getMaxCount() => maxCount;

  int getImageCount ({int idx = -1}) {
    if(idx != -1) {
      return getImagePile(idx: idx).length();
    } else if(index.value == -1) {
      return newImage.value.length();
    } else {
      return getImagePile(idx: index.value).length();
    }
  }

  setIndex(idx) {
    if(idx == -1) newImage.value = ImagePile();
    index.value = idx;
  }

  addImage() async {
    if(getImagePile().length() == maxCount) {
      return ImageEnum.maxExtent;
    }
    final result = await _pickFromLocal();
    refreshImage();
    if(result != null) return result;
  }

  refreshImage() {
    if(index.value > -1) {
      images.refresh();
    } else {
      newImage.refresh();
    }
  }

  _pickFromLocal() async {
    try {
      final result = await FilePicker.platform.pickFiles(
          type: FileType.image, allowMultiple: false, withData: true
      );

      if(result == null) {
        return ImageError.fileNotFound;
      } else {
        final file = result.files.first;
        if(file.size > maxSize) {
          return ImageEnum.maxSize;
        } else if(file.bytes == null || file.bytes!.isEmpty){
            return ImageEnum.broken;
        } else {
          getImagePile().add(ImageAsset(
              name: "${const Uuid().v1()}.jpg",
              data: await compress(file.bytes!)
          ));
          return ImageEnum.success;
        }
      }
    } catch(e) {

      return ImageEnum.notSupported;
    }
  }

  compress(Uint8List data) async {
    if(getPlatform() == UserPlatform.android) {
      return await FlutterImageCompress.compressWithList(
          data, quality: 25, format: CompressFormat.jpeg
      );
    } else {
      return encodeJpg(decodeImage(data)!, quality: 25);
    }
  }

  upload() async {
    try {
      final repo = StorageRepository(provider: StorageProvider(uid: uid.value));
      for(ImageAsset asset in getImagePile().toList()) {
        if(asset.data != null) {
          await repo.putData(asset.name, asset.data!);
          asset.data = null;
          asset.url = await repo.getDownloadURL(asset.name);
        }
      }
      images.refresh();
    } catch(e) {
      throw Exception(e);
    }
  }

  removeAt(index) async {
    if(getImagePile().elementAt(index).remove) {
      getImagePile().elementAt(index).remove = false;
    } else {
      getImagePile().elementAt(index).remove = true;
    }
    refreshImage();
  }

  removeAll() async {
    final repo = StorageRepository(provider: StorageProvider(uid: uid.value));
    final assets = getImagePile().toList();
    for(int i = getImageCount() - 1; i >= 0; i--) {
      if(assets[i].remove) {
        await repo.removeData(assets[i].name);
        assets.removeAt(i);
      }
    }
    refreshImage();
  }

  _insert() {
    ImagePile pile;
    if(index.value > -1) {
      pile = images.removeAt(index.value);
    } else {
      pile = getImagePile();
    }
    images.insert(0, pile);
    images.refresh();
  }

  save() async {
    await removeAll();
    await upload();
    _insert();
    index.value = 0;
  }

  cancel() {
    if(index.value > -1) {
      var assets = getImagePile().toList();
      for(int i = getImageCount() - 1; i >= 0; i--) {
        if(assets[i].data != null) {
          assets.removeAt(i);
        } else if(assets[i].remove) {
          assets[i].remove = false;
        }
      }
      images.refresh();
    }
  }

  clear(int index) async {
    final repo = StorageRepository(provider: StorageProvider(uid: uid.value));
    for(ImageAsset asset in getImagePile(idx: index).toList()) {
        await repo.removeData(asset.name);
    }
    images.removeAt(index);
    images.refresh();
  }
}

enum ImageEnum { fileNotFound, maxExtent, maxSize, success, broken, notSupported }

