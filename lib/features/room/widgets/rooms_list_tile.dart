import 'package:babble/core/misc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:babble/models/room_model.dart';
import '../../../../../../../core/radii.dart';
import '../../../../../../../core/strings.dart';
import '../../../../../../../models/user_model.dart';
import '../../chat/widgets/profile_pic_viewer.dart';
import '../screens/room.dart';
import 'room_list_tile_name_field.dart';

class RoomsListTile extends StatelessWidget {
  final RoomModel roomData;
  final UserModel? userData;

  const RoomsListTile({
    super.key,
    required this.roomData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (roomData.hostUid != userData!.uid && roomData.isRoomClosed) {
          Get.showSnackbar(const GetSnackBar(
            duration: snackbarDuration,
            message: "Room currently closed by the host",
          ));
        } else {
          Get.to(
            () => Room(roomData: roomData, userData: userData),
          );
        }
      },
      child: Container(
        height: 2 * chatListImageRadii,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () => Get.to(
                () => ProfilePicViewer(
                  imageUrl: roomData.roomPic,
                  name: roomData.name,
                  isRoom: true,
                  roomId: roomData.roomId,
                ),
                transition: Transition.fadeIn,
              ),
              child: roomData.roomPic != ''
                  ? FutureBuilder(
                      initialData: const AssetImage(defaultProfilePic),
                      future: Future(() => NetworkImage(roomData.roomPic)),
                      builder: (context, snapshot) => CircleAvatar(
                        backgroundImage:
                            snapshot.data! as ImageProvider<Object>,
                        radius: chatListImageRadii,
                      ),
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage(defaultRoomPic),
                      radius: chatListImageRadii,
                    ),
            ),
            RoomListTileNameField(roomData: roomData, userData: userData),
          ],
        ),
      ),
    );
  }
}
