import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/radii.dart';
import '../../../../../../../../../core/strings.dart';
import '../../../../../../../../../core/textstyles.dart';
import '../../../../../../../../../models/room_model.dart';
import '../room control/room_controls.dart';

class RoomAppBar extends StatelessWidget {
  final RoomModel roomData;
  final bool isHost;
  const RoomAppBar({super.key, required this.roomData, required this.isHost});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isHost) {
          Get.to(() => const RoomContols());
        }
      },
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: () {
        //       //Navigator.pop(roomCtx);
        //       Get.back();
        //     },
        //     icon: SvgPicture.asset(
        //       backArrow,
        //       height: 50,
        //       width: 60,
        //     )),
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
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //     child: ElevatedButton(
        //         onPressed: () {},
        //         style: const ButtonStyle(
        //             minimumSize: MaterialStatePropertyAll(Size(84, 36)),
        //             backgroundColor:
        //                 MaterialStatePropertyAll(Color(0xFFBA3B3B))),
        //         child: const Text(
        //           "Leave",
        //           style: roomAppBarLeaveTextStyle,
        //         )),
        //   )
        // ],
      ),
    );
  }
}
