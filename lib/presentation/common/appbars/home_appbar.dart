import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../babble_title.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 70,
      backgroundColor: bodyBackgroundColor,
      //automaticallyImplyLeading: false,
      centerTitle: true,
      title: const SafeArea(child: BabbleTitleWidget()),
      actions: [
        Column(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: babbleTitleColor,
                  size: 40,
                )),
          ],
        )
      ],
    );
  }
}
