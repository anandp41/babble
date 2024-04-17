import 'package:flutter/material.dart';

import '../../../../../core/colors.dart';

class CustomRoomsSearchBar extends StatelessWidget {
  const CustomRoomsSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.justify,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
          constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 100),
          labelText: "Search in your rooms",
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
          suffix: IconButton(
              alignment: Alignment.center,
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: babbleTitleColor,
                size: 34,
              ))),
    );
  }
}
