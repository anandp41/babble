import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/textstyles.dart';
import '../../../common/utils/utils.dart';
import '../../../core/colors.dart';
import '../../../models/room_model.dart';
import '../../settings/widgets/functions.dart';
import '../controller/room_controller.dart';
import 'close_open_room_button.dart';
import 'room_control_bottom_button.dart';
import 'room_controls_members_list_box.dart';
import 'room_controls_members_title_row.dart';
import 'rooms_control_room_image.dart';

class RoomControls extends ConsumerStatefulWidget {
  final RoomModel roomData;
  final String memberId;
  const RoomControls(
      {super.key, required this.roomData, required this.memberId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RoomControlsState();
}

class _RoomControlsState extends ConsumerState<RoomControls> {
  Future<void> selectImage() async {
    File? image = await Utils.pickImageFromGallery();
    if (image != null) {
      await ref.read(roomControllerProvider).updateRoomPhoto(
          roomPic: image, roomId: widget.roomData.roomId, ref: ref);
      // ignore: unused_result
      ref.refresh(roomControllerProvider);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FutureBuilder(
            future: ref
                .watch(roomControllerProvider)
                .getDetailsOfRoom(widget.roomData.roomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: babbleTitleColor,
                ));
              }
              var newRoomData = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.roomData.hostUid == widget.memberId
                      ? Align(
                          alignment: Alignment.topRight,
                          child: CloseOpenRoomButton(
                            roomId: newRoomData!.roomId,
                            isRoomClosed: newRoomData.isRoomClosed,
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(
                            children: [
                              RoomControlsRoomImage(newRoomData: newRoomData),
                              Positioned(
                                bottom: -5,
                                right: -5,
                                child: IconButton(
                                    onPressed: () async {
                                      await selectImage();
                                    },
                                    icon: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: babbleTitleColor,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      ),
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  newRoomData!.name,
                                  style: roomControlRoomNameTextStyle,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showNameBottomSheet(
                                        context, newRoomData.name, ref,
                                        isRoom: true,
                                        roomId: newRoomData.roomId);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: babbleTitleColor,
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RoomControlsMembersTitleRow(
                              newRoomData: newRoomData,
                              memberId: widget.memberId),
                          const SizedBox(
                            height: 20,
                          ),
                          RoomControlsMembersListBox(newRoomData: newRoomData),
                          const SizedBox(
                            height: 15,
                          ),
                          RoomControlBottomButton(
                            roomName: newRoomData.name,
                            isHost: newRoomData.hostUid == widget.memberId,
                            roomId: newRoomData.roomId,
                            memberId: widget.memberId,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
