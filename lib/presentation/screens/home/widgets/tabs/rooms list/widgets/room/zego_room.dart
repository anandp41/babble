import 'package:babble/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../../../../../../controller/chat_controller.dart';
import '../../../../../../../../core/keys.dart';
import '../../../../../../../../core/radii.dart';
import '../../../../../../../../core/strings.dart';
import '../../../../../../../../core/textstyles.dart';
import '../../../../../../../../models/user_model.dart';
import '../../../../../../../../repositories/contacts_repository.dart';

class LiveAudioRoomPage extends ConsumerWidget {
  final bool isHost;
  final String roomId;
  final UserModel? userData;
  const LiveAudioRoomPage({
    required this.isHost,
    required this.roomId,
    required this.userData,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ZegoUIKitPrebuiltLiveAudioRoom(
      appID: appId, // your AppID,
      appSign: appSign,
      userID: userData!.uid,
      userName: userData!.phoneNumber,
      roomID: roomId,
      config: (isHost
          ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
          : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience())
        ..seatConfig = ZegoLiveAudioRoomSeatConfig(
            avatarBuilder: (context, size, user, extraInfo) {
              return userData!.profilePic != ''
                  ? FutureBuilder(
                      initialData: const AssetImage(defaultProfilePic),
                      future: Future(() async {
                        var profilePic = await ref
                            .watch(chatControllerProvider)
                            .getProfilePicOfAUser(userId: user!.id);
                        if (profilePic == '') {
                          return const AssetImage(defaultProfilePic);
                        } else {
                          return NetworkImage(profilePic);
                        }
                      }),
                      builder: (context, snapshot) => CircleAvatar(
                        backgroundImage:
                            snapshot.data! as ImageProvider<Object>,
                        radius: chatListImageRadii,
                      ),
                    )
                  : const CircleAvatar(
                      backgroundImage: AssetImage(defaultProfilePic),
                      radius: chatListImageRadii,
                    );
            },
            showSoundWaveInAudioMode: true)
        ..durationConfig = ZegoLiveDurationConfig(isVisible: false)
        ..useSpeakerWhenJoining = false
        ..turnOnMicrophoneWhenJoining = true
        ..background = Container(
          color: bodyBackgroundColor,
        )
        ..turnOnMicrophoneWhenJoining = true
        ..closeSeatsWhenJoining = false
        ..memberListConfig = ZegoMemberListConfig(
          itemBuilder: (context, size, user, extraInfo) {
            if (user.id == userData!.uid) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "You",
                  softWrap: true,
                  maxLines: 1,
                  textWidthBasis: TextWidthBasis.parent,
                  overflow: TextOverflow.ellipsis,
                  style: roomListTileNameTextStyle,
                ),
              );
            }

            return FutureBuilder(
              future: ref
                  .read(contactsRepositoryProvider)
                  .ifSavedContactName(phoneNumberFromServerToCheck: user.name),
              initialData: user.name,
              builder: (context, snapshot) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      user.name == snapshot.data!
                          ? snapshot.data!
                          : "${snapshot.data!}-${user.name}",
                      softWrap: true,
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.ellipsis,
                      style: roomListTileNameTextStyle,
                    ),
                  ),
                );
              },
            );
          },
        ),
      controller: ZegoLiveAudioRoomController()..openSeats(),
    );
  }
}
