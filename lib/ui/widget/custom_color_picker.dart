import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorController {
  final Function(void Function()) notifyParent;
  ColorController({
    required this.notifyParent,
    required Color baseColor
  }) {
    red = baseColor.red;
    blue = baseColor.blue;
    green = baseColor.green;
  }

  int red = 255;
  int blue = 255;
  int green = 255;

  int getRed() => red;
  int getBlue() => blue;
  int getGreen() => green;

  setRed(int value) {
    red = value;
    notifyParent(() {});
  }

  setBlue(int value) {
    blue = value;
    notifyParent(() {});
  }

  setGreen(int value) {
    green = value;
    notifyParent(() {});
  }

  getColor() => Color.fromRGBO(red, green, blue, 1);
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({super.key, required this.baseColor});
  final Color baseColor;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late final ColorController controller;

  final double width = 360;
  final double height = 420;
  final double padding = 12;
  final double fontSize = 24;
  final double borderRadius = 24;
  final double buttonFontSize = 16;
  final String title = "색상 선택";

  @override
  void initState() {
    super.initState();
    controller = ColorController(
        notifyParent: setState,
        baseColor: widget.baseColor
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Theme.of(context).colorScheme.background
          ),
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(padding),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold
                      )
                  )
              ),
              ColorView(controller: controller),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColorSlider(rgb: RGB.red, controller: controller),
                      //G
                      ColorSlider(rgb: RGB.green, controller: controller),
                      //B
                      ColorSlider(rgb: RGB.blue, controller: controller),
                    ]
                )
              ),
              // Buttons
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text("취소",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: buttonFontSize
                          )
                      )
                  ),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pop(controller.getColor().value);
                      },
                      child: Text("저장",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: buttonFontSize
                          )
                      )
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }
}

enum RGB {
  red("R"), green("G"), blue("B");
  final String label;
  const RGB(this.label);
}

class ColorView extends StatelessWidget {
  const ColorView({super.key, required this.controller});
  final ColorController controller;

  final double size = 240;
  final double borderRadius = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: controller.getColor()
      ),
    );
  }
}


class ColorSlider extends StatefulWidget {
  const ColorSlider({super.key, required this.rgb, required this.controller});
  final RGB rgb;
  final ColorController controller;

  @override
  State<ColorSlider> createState() => _ColorSliderState();
}

class _ColorSliderState extends State<ColorSlider> {
  late final RGB rgb;
  late final ColorController controller;

  final double backgroundHeight = 12;
  final double backgroundPadding = 16;
  final double sliderHeight = 36;
  final double labelWidth = 54;

  @override
  void initState() {
    super.initState();
    rgb = widget.rgb;
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: backgroundPadding,
          alignment: Alignment.centerRight,
          child: Text(rgb.label),
        ),
        Expanded(
          child: Container(
              height: sliderHeight,
              alignment: Alignment.center,
              child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: _buildGradient()
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: _buildSlider()
                    )
                  ]
              )
          )
        )
      ]
    );
  }

  _buildGradient() {
    Color endColor;
    switch(rgb) {
      case RGB.red:
        endColor = const Color.fromRGBO(255, 0, 0, 1);
        break;
      case RGB.green:
        endColor = const Color.fromRGBO(0, 255, 0, 1);
        break;
      case RGB.blue:
        endColor = const Color.fromRGBO(0, 0, 255, 1);
        break;
    }
    return Container(
        height: backgroundHeight,
        width: double.infinity,
        margin: EdgeInsets.only(right: backgroundPadding, left: backgroundPadding),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(0, 0, 0, 1),
                  endColor
                ]
            ),
            borderRadius: BorderRadius.circular(backgroundHeight)
        )
    );
  }

  _buildSlider() {
    return Slider(
        min: 0,
        max: 255,
        divisions: 256,
        inactiveColor: Colors.transparent,
        activeColor: Colors.transparent,
        thumbColor: _getThumbColor(),
        value: _getColor().toDouble(),
        onChanged: (value) => setState(() {
          _setColor(value.round());
        })
    );
  }

  _getThumbColor() {
    switch(rgb) {
      case RGB.red:
        final red = controller.getRed();
        return Color.fromRGBO(255, 255 - red, 255 - red, 1);
      case RGB.green:
        final green = controller.getGreen();
        return Color.fromRGBO(255 - green, 255, 255 - green, 1);
      case RGB.blue:
        final blue = controller.getBlue();
        return Color.fromRGBO(255 - blue, 255 - blue, 255, 1);
    }
  }

  _getColor() {
    switch(rgb) {
      case RGB.red:
        return controller.getRed();
      case RGB.green:
        return controller.getGreen();
      case RGB.blue:
        return controller.getBlue();
    }
  }

  _setColor(var value) {
    switch(rgb) {
      case RGB.red:
        controller.setRed(value);
        break;
      case RGB.green:
        controller.setGreen(value);
        break;
      case RGB.blue:
        controller.setBlue(value);
        break;
    }
  }
}


