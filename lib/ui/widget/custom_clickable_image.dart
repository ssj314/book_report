import 'package:book_report/constant/values.dart';
import 'package:flutter/material.dart';

class ClickableImage extends StatefulWidget {
  final double width;
  final double height;
  final String src;
  final String? title;
  final Function()? onClick;
  final Function()? onLongPress;

  const ClickableImage({
    super.key,
    required this.width,
    required this.height,
    required this.src,
    this.title,
    this.onClick,
    this.onLongPress,
  });

  @override
  State<ClickableImage> createState() => _ClickableImageState();
}

class _ClickableImageState extends State<ClickableImage> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: widget.width,
              height: widget.height,
              child: GestureDetector(
                  onTapDown: (details) => setState(() => clicked = true),
                  onTapUp: (details) => setState(() => clicked = false),
                  onTapCancel: () => setState(() => clicked = false),
                  onTap: widget.onClick,
                  onLongPress: widget.onLongPress,
                  child: Material(
                      borderRadius: BorderRadius.circular(CustomRadius.small.radius),
                      elevation: (clicked)?1:4,
                      child: WebCompatibleImage(
                        width: widget.width,
                        height: widget.height,
                        src: widget.src,
                      )
                  )
              )
          ),
          Container(
            padding: EdgeInsets.all(Spacing.tiny.size),
            width: widget.width,
            height: (widget.title == null)?0:null,
            child: Text("${widget.title}\n",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis
            ),
          )
        ]
    );
  }
}

class WebCompatibleImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String src;
  final BoxFit fit;
  const WebCompatibleImage({
    super.key,
    required this.width,
    required this.height,
    required this.src,
    this.fit = BoxFit.fill
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(CustomRadius.small.radius),
            child: Image.network(
                src,
                fit: fit,
                errorBuilder: (context, _, __) => getBypassImage()
            )
        )
    );
  }

  getBypassImage() {
    final image = getBypassURI(src);
    try {
      return Image(
          image: NetworkImage(
            image["uri"],
            headers: image["headers"],
          ),
          fit: fit,
          errorBuilder: (context, _, __) => Material(
              color: Theme.of(context).colorScheme.secondary,
              child: Center(
                  child: Text("No Image", style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold
                  ))
              )
          )
      );
    } catch (e) {
      return Container(child: Text("No Image"));
    }

  }


  getBypassURI(query) {
    var uri = Uri.parse(query);
    var root = Uri.parse("https://proxy.cors.sh/$uri");
    return {"uri": root.toString(), "headers": {'x-cors-api-key': 'temp_4cc4a95bde915180d40ce6ac0ed89cec'}};
  }
}
