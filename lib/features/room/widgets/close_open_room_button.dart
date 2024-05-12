import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/colors.dart';
import '../../../core/textstyles.dart';
import '../controller/room_controller.dart';

class CloseOpenRoomButton extends ConsumerWidget {
  final bool isRoomClosed;
  final String roomId;
  const CloseOpenRoomButton(
      {super.key, required this.isRoomClosed, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
              backgroundColor: MaterialStatePropertyAll(isRoomClosed
                  ? roomControlCloseRoomButtonGreenColor
                  : roomControlCloseRoomButtonRedColor)),
          onPressed: () async {
            if (isRoomClosed) {
              await ref.read(roomControllerProvider).openRoom(roomId: roomId);
            } else {
              await ref.read(roomControllerProvider).closeRoom(roomId: roomId);
            }
            // ignore: unused_result
            ref.refresh(roomControllerProvider);
          },
          child: Text(
            isRoomClosed ? "Open Room" : "Close room",
            style: roomAppBarLeaveTextStyle,
          )),
    );
  }
}
