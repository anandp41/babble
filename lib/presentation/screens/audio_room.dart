// import 'package:babble/core/keys.dart';
// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

// class ZegoCloudAudioRoom extends StatelessWidget {
//   final String roomID;
//   final bool isHost;

//   const ZegoCloudAudioRoom(
//       {super.key, required this.roomID, this.isHost = false});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ZegoUIKitPrebuiltLiveAudioRoom(
//         appID:
//             zegoAppId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//         appSign:
//             zegoAppSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//         userID: 'anand_p_41',
//         userName: 'Anand P',
//         roomID: roomID,
//         config: isHost
//             ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
//             : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
//           ..seat = ZegoLiveAudioRoomSeatConfig(showSoundWaveInAudioMode: true),
//       ),
//     );
//   }
// }
