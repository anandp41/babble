import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/colors.dart';
import '../../../../core/misc.dart';
import '../../../../core/textstyles.dart';
import 'tabs/chats list/widgets/contacts/screen/contacts.dart';
import 'tabs/rooms list/widgets/make_room/screen/make_room_screen.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final bool isRoomsList;
  const CustomFloatingActionButton({super.key, required this.isRoomsList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isRoomsList
            ? Get.to(() => const MakeRoomScreen())
            : Get.to(() => const ContactsScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(floatingActionButtonPadding),
        decoration: ShapeDecoration(
          color: babbleTitleColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(messageBorderRadius)),
        ),
        child: isRoomsList
            ? const Text(
                "Make a room",
                style: floatingActionRoomAddButtonTextStyle,
              )
            : const Icon(
                Icons.add_comment,
                size: floatingActionButtonIconSize,
                color: floatingActionButtonIconColor,
              ),
      ),
    );
  }
}
