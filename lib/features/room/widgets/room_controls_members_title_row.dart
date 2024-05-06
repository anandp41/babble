import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/textstyles.dart';
import '../../../models/room_model.dart';
import 'add_member.dart';

class RoomControlsMembersTitleRow extends StatelessWidget {
  const RoomControlsMembersTitleRow({
    super.key,
    required this.newRoomData,
    required this.memberId,
  });

  final RoomModel? newRoomData;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Members",
          style: roomControlMembersTitleTextStyle,
        ),
        newRoomData!.hostUid == memberId
            ? IconButton(
                onPressed: () {
                  Get.to(() => AddMemberToRoomScreen(
                      alreadyMembers: newRoomData!.membersUid,
                      roomId: newRoomData!.roomId));
                },
                icon: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ))
            : const SizedBox.shrink(),
      ],
    );
  }
}
