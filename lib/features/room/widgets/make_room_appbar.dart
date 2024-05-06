import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/textstyles.dart';
import 'select_contacts_room.dart';

class MakeRoomAppBar extends ConsumerWidget {
  const MakeRoomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Get.back();
            ref.read(selectedRoomContacts.state).update((state) => []);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: appbarBackButtonColor,
          )),
      toolbarHeight: 50,
      title: const Text(
        'Make a Room',
        style: chatAppBarTextStyle,
      ),
      backgroundColor: chatAppBarBg,
    );
  }
}
