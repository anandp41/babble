import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:babble/features/room/controller/room_controller.dart';

import '../../../../../core/radii.dart';
import '../../../../../core/strings.dart';
import '../../../../../core/textstyles.dart';
import '../../../../../models/room_model.dart';
import '../../../core/colors.dart';
import 'room_controls.dart';

class RoomAppBar extends ConsumerWidget {
  final RoomModel roomData;
  final String memberId;
  final String phoneNumber;
  const RoomAppBar({
    super.key,
    required this.roomData,
    required this.memberId,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Get.to(() => RoomControls(roomData: roomData, memberId: memberId));
      },
      child: AppBar(
        backgroundColor: roomBgGradientList[0],
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              Get.back();
              ref.read(roomControllerProvider).removePhoneNumberAsSpeaking(
                  roomId: roomData.roomId, phoneNumber: phoneNumber);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: appbarBackButtonColor,
            )),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            roomData.roomPic != ''
                ? FutureBuilder(
                    initialData: const AssetImage(defaultProfilePic),
                    future: Future(() => NetworkImage(roomData.roomPic)),
                    builder: (context, snapshot) => CircleAvatar(
                      backgroundImage: snapshot.data! as ImageProvider<Object>,
                      radius: chatListImageRadii,
                    ),
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage(defaultRoomPic),
                    radius: chatListImageRadii,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                roomData.name,
                style: roomsListTileNameTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
