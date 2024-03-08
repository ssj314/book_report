import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSubmitted;
  const CustomSearchBar({super.key, required this.onSubmitted});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {

  late final TextEditingController controller;
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 25,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        constraints: const BoxConstraints(maxHeight: 42, minHeight: 42),
        suffixIcon: (hasText)?IconButton(
          onPressed: () => setState(() {
            controller.text = '';
            hasText = false;
          }),
          icon: const Icon(Icons.cancel, size: 20),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ):null,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surfaceVariant,
            width: 0
          )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surfaceVariant,
                width: 0
            )
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surfaceVariant,
                width: 0
            )
        ),
        counterText: "",
        counter: null,
        contentPadding: EdgeInsets.zero,
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: "검색",
      ),
      onChanged: (value) => setState(() => hasText = value.isNotEmpty),
      onFieldSubmitted: widget.onSubmitted
    );
  }
}
