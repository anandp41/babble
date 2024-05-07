import 'package:babble/core/misc.dart';
import 'package:babble/features/settings/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/colors.dart';
import '../../../common/widgets/babble_title.dart';
import '../../../core/textstyles.dart';

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
      centerTitle: true,
      title: const SafeArea(child: BabbleTitleWidget()),
      actions: [
        PopupMenuButton(
          color: const Color(0xFFD9D9D9),
          iconSize: 40,
          iconColor: babbleTitleColor,
          onSelected: (value) {
            if (value == 0) {
              Get.to(() => const SettingsScreen());
            }
          },
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(messageBorderRadius)),
          padding: EdgeInsetsDirectional.zero,
          itemBuilder: (context) => [
            const PopupMenuItem(
              padding: EdgeInsets.zero,
              value: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Settings",
                      style: dropDownListButtonTS,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
