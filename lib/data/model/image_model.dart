import 'dart:typed_data';

class ImageAsset {
  String? url;
  String name;
  Uint8List? data;
  bool remove;

  ImageAsset({
    this.url,
    this.data,
    this.remove = false,
    required this.name
  });
}

class ImagePile {
  List<ImageAsset> images = [];

  void addAll(List<ImageAsset> img) => images.addAll(img);
  void add(ImageAsset img) => images.add(img);
  ImageAsset removeAt(int index) {
    if(index < images.length) {
      return images.removeAt(index);
    } else {
      throw IndexError;
    }
  }

  ImageAsset elementAt(int index) => images[index];
  void clear() => images.clear();
  int length() => images.length;
  bool isEmpty() => images.isEmpty;
  List<ImageAsset> toList() => images;
  bool contains(ImageAsset img) => images.contains(img);
  void insert(int index, ImageAsset img) {
    if(index < length()) {
      images.insert(index, img);
    } else {
      throw IndexError;
    }
  }
}