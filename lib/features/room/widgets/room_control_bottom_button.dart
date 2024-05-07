import 'package:babble/features/room/controller/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../../core/colors.dart';
import '../../../core/textstyles.dart';

class RoomControlBottomButton extends ConsumerWidget {
  final bool isHost;
  final String roomName;
  final String roomId;
  final String memberId;
  const RoomControlBottomButton({
    super.key,
    required this.isHost,
    required this.roomId,
    required this.memberId,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        showDeleteLeaveDialog(context, ref);
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: roomMuteRedGradientColorsList),
        ),
        child: Center(
          child: Text(
            isHost ? "Delete Room" : "Leave Room",
            style: roomControlBottomButtonTextTS,
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteLeaveDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) {
        if (isHost) {
          return AlertDialog(
            title: const Text("Are you sure ?"),
            content: Text("Delete room $roomName ?"),
            actions: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(roomControllerProvider)
                      .deleteRoom(roomId: roomId);
                  Get.back();
                },
                child: const Text(
                  "Yes",
                  style: settingsRedButtonTS,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "No",
                  style: settingsButtonTS,
                ),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text("Are you sure ?"),
            content: Text("Leave room $roomName ?"),
            actions: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(roomControllerProvider)
                      .removeAMember(roomId: roomId, memberId: memberId);

                  Get.back();
                },
                child: const Text(
                  "Yes",
                  style: settingsRedButtonTS,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "No",
                  style: settingsButtonTS,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
