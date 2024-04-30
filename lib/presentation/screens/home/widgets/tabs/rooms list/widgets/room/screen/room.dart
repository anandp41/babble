import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:babble/models/room_model.dart';
import 'package:babble/presentation/screens/home/widgets/tabs/rooms%20list/widgets/room/zego_room.dart';

import '../../../../../../../../../models/user_model.dart';
import '../room control/room_controls.dart';
import '../widgets/room_appbar.dart';

class Room extends StatelessWidget {
  final RoomModel roomData;
  final UserModel? userData;
  const Room({
    super.key,
    required this.roomData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: RoomAppBar(
              roomData: roomData,
              isHost: userData!.uid == roomData.hostUid,
            )),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: LiveAudioRoomPage(
                isHost: userData!.uid == roomData.hostUid,
                roomId: roomData.roomId,
                userData: userData),
          ),
        )
        // Container(
        //   width: double.infinity,
        //   height: MediaQuery.of(context).size.height,
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: roomBackgroundGradientColorsList,
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //     ),
        //   ),
        //   child: SafeArea(
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           const Text(
        //             "Speaking:",
        //             style: roomHeadingsTextStyle,
        //           ),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           Expanded(
        //             flex: 2,
        //             child: GridView.builder(
        //               itemCount: 8,
        //               scrollDirection: Axis.vertical,
        //               gridDelegate:
        //                   const SliverGridDelegateWithMaxCrossAxisExtent(
        //                       crossAxisSpacing: 0,
        //                       mainAxisSpacing: 8,
        //                       mainAxisExtent: 100,
        //                       maxCrossAxisExtent: 100),
        //               itemBuilder: (context, index) => const RoomMemberTile(),
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 20,
        //           ),
        //           const Text(
        //             "Others:",
        //             style: roomHeadingsTextStyle,
        //           ),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           Expanded(
        //             flex: 3,
        //             child: GridView.builder(
        //               shrinkWrap: true,
        //               itemCount: 28,
        //               gridDelegate:
        //                   const SliverGridDelegateWithMaxCrossAxisExtent(
        //                       mainAxisSpacing: 8,
        //                       crossAxisSpacing: 0,
        //                       mainAxisExtent: 100,
        //                       maxCrossAxisExtent: 100),
        //               scrollDirection: Axis.vertical,
        //               itemBuilder: (context, index) => const RoomMemberTile(),
        //             ),
        //           ),
        //           const SizedBox(
        //             height: 10,
        //           ),
        //           const Align(
        //             alignment: Alignment.center,
        //             child: RoomMuteButton(),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
