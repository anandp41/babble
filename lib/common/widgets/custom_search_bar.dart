import 'package:flutter/material.dart';

import '../../core/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String label;
  final void Function(String)? onChanged;
  const CustomSearchBar({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        onChanged!(value);
      },
      textAlign: TextAlign.justify,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
          constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 100),
          labelText: label,
          labelStyle: const TextStyle(
            color: searchBoxTextColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: searchBoxBg,
          contentPadding:
              const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
          border: InputBorder.none,
          suffix: const Icon(
            Icons.search,
            color: babbleTitleColor,
            size: 34,
          )),
    );
  }
}
