import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../core/textstyles.dart';
import '../../../models/room_model.dart';
import '../../../models/user_model.dart';
import 'room_list_tile_speakers_name_subfield.dart';

class RoomListTileNameField extends StatelessWidget {
  const RoomListTileNameField({
    super.key,
    required this.roomData,
    required this.userData,
  });

  final RoomModel roomData;
  final UserModel? userData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      roomData.name,
                      maxLines: 1,
                      style: roomsListTileNameTextStyle,
                    ),
                  ),
                ),
                RoomListTileSpeakersNameSubField(
                    roomData: roomData, userData: userData)
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                roomData.isRoomClosed
                    ? const Icon(Icons.lock_outline,
                        color: roomControlCloseRoomButtonRedColor)
                    : const SizedBox.shrink(),
                roomData.hostUid == userData!.uid
                    ? const Icon(Icons.admin_panel_settings,
                        color: Colors.white)
                    : const SizedBox.shrink()
              ],
            )
          ],
        ),
      ),
    );
  }
}
