import 'package:babble/features/room/controller/room_controller.dart';
import 'package:flutter/material.dart';
import 'package:babble/models/room_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../models/user_model.dart';
import '../widgets/room_appbar.dart';
import '../widgets/zego_room.dart';

class Room extends ConsumerWidget {
  final RoomModel roomData;
  final UserModel? userData;
  const Room({
    super.key,
    required this.roomData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvoked: (didPop) => ref
          .read(roomControllerProvider)
          .removePhoneNumberAsSpeaking(
              roomId: roomData.roomId, phoneNumber: userData!.phoneNumber),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: RoomAppBar(
                roomData: roomData,
                memberId: userData!.uid,
                phoneNumber: userData!.phoneNumber)),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: LiveAudioRoomPage(
                isHost: userData!.uid == roomData.hostUid,
                roomId: roomData.roomId,
                userData: userData),
          ),
        ),
      ),
    );
  }
}
