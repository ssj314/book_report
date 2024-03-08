import 'package:book_report/constant/values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLongButton extends StatefulWidget {
  final String label;
  final Function() onClick;
  const CustomLongButton({super.key, required this.label, required this.onClick});

  @override
  State<CustomLongButton> createState() => _LongElevatedButtonState();
}

class _LongElevatedButtonState extends State<CustomLongButton> {
  
  bool clicked = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (dt) => setState(() => clicked = true),
        onTapUp: (dt) => setState(() => clicked = false),
        onTap: widget.onClick,
        child: Opacity(
            opacity: (clicked)?0.8:1,
            child: Material(
                borderRadius: BorderRadius.circular(CustomRadius.corner.radius),
                elevation: (clicked)?1:4,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(CustomRadius.corner.radius)
                  ),
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.0,
                        color: Get.theme.colorScheme.onBackground,
                        fontSize: CustomFont.caption.size
                    )
                  )
                )
            )
        )
    );
  }
}
