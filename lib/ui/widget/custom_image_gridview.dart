import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/model/image_model.dart';

class ImageGridView extends StatelessWidget {
  const ImageGridView({
    super.key,
    required this.images
  });
  final ImagePile images;
  final double borderRadius = 4;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: getGrid()
    );
  }

  getGrid() {
    switch(images.length()) {
      case 0:
        return const SizedBox();
      case 1:
        return getSingleGrid();
      case 2:
        return getDoubleGrid();
      case 3:
        return getTripleGrid();
      default:
        return getQuadGrid();
    }
  }

  getSingleGrid() {
    return Row(
        children: [
          ImageGridItem(flex: 1, image: images.elementAt(0)),
          const Flexible(
              flex: 1,
              child: AspectRatio(aspectRatio: 1)
          )
        ]
    );
  }

  getDoubleGrid() {
    return Row(
        children: [
          ImageGridItem(flex: 1, image: images.elementAt(0)),
          ImageGridItem(flex: 1, image: images.elementAt(1)),
          const Flexible(
              flex: 1,
              child: AspectRatio(aspectRatio: 1)
          )
        ]
    );
  }

  getTripleGrid() {
    return Row(
        children: [
          ImageGridItem(flex: 2, image: images.elementAt(0)),
          Flexible(
              flex: 1,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageGridItem(flex: 1, image: images.elementAt(1)),
                    ImageGridItem(flex: 1, image: images.elementAt(2))
                  ]
              )
          )
        ]
    );
  }

  getQuadGrid() {
    return Row(
        children: [
          Flexible(
              flex: 1,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageGridItem(flex: 1, image: images.elementAt(0)),
                    ImageGridItem(flex: 1, image: images.elementAt(1))
                  ]
              )
          ),
          Flexible(
              flex: 1,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageGridItem(flex: 1, image: images.elementAt(3)),
                    ImageGridItem(flex: 1, image: images.elementAt(4))
                  ]
              )
          )
        ]
    );
  }
}

class ImageGridItem extends StatelessWidget {
  const ImageGridItem({super.key, required this.image, required this.flex});
  final ImageAsset image;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return  Flexible(
        flex: flex,
        child: AspectRatio(
            aspectRatio: 1,
            child: getImage()
        )
    );
  }

  getImage() {
    if(image.url != null) {
      return Image.network(
          image.url!,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low
      );
    } else {
      return Image.memory(
          image.data!,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low
      );
    }
  }
}
