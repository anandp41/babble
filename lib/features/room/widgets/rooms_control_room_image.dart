import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/radii.dart';
import '../../../core/strings.dart';
import '../../../models/room_model.dart';
import '../../chat/widgets/profile_pic_viewer.dart';

class RoomControlsRoomImage extends StatelessWidget {
  const RoomControlsRoomImage({
    super.key,
    required this.newRoomData,
  });

  final RoomModel? newRoomData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
          () => ProfilePicViewer(
                imageUrl: newRoomData!.roomPic,
                name: newRoomData!.name,
                isRoom: true,
                roomId: newRoomData!.roomId,
              ),
          transition: Transition.fadeIn),
      child: newRoomData!.roomPic != ''
          ? FutureBuilder(
              initialData: const AssetImage(defaultRoomPic),
              future: Future(() => NetworkImage(newRoomData!.roomPic)),
              builder: (context, snapshot) => CircleAvatar(
                backgroundImage: snapshot.data! as ImageProvider<Object>,
                radius: 3 * chatListImageRadii,
              ),
            )
          : const CircleAvatar(
              backgroundImage: AssetImage(defaultRoomPic),
              radius: 3 * chatListImageRadii,
            ),
    );
  }
}
