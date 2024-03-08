import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/values.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final List<String> autofillHints;
  final TextInputType keyboardType;
  final Function(String value) onChanged;
  final String? Function(String? value) validator;
  static const emptyList = <String>[];

  const CustomTextField({super.key,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.autofillHints = emptyList,
    this.keyboardType = TextInputType.text,
    required this.onChanged, required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(CustomRadius.medium.radius),
        child: TextFormField(
          onChanged: onChanged,
          validator: validator,
          autofillHints: autofillHints,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              labelText: label,
              fillColor: Get.theme.colorScheme.secondaryContainer,
              filled: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(CustomRadius.medium.radius),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(CustomRadius.medium.radius),
              ),
              counterText: "",
              prefixIcon: Icon(
                  icon,
                  size: 24,
                  color: Get.theme.colorScheme.primary
              )
          ),
          maxLines: 1,
          maxLength: 30,
          obscureText: obscure,
        )
    );
  }
}