import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import '../../../../../core/radii.dart';
import '../../../../../core/strings.dart';
import '../../../../../core/textstyles.dart';
import '../../../../../models/user_model.dart';
import '../../../config/zego_cloud_config.dart';
import '../../../core/colors.dart';
import '../../chat/controller/chat_controller.dart';
import '../../select_contacts/repository/contacts_repository.dart';
import '../controller/room_controller.dart';
import 'room_occupant_name_tile.dart';

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
    return FutureBuilder(
        future: ref.read(roomControllerProvider).getDetailsOfRoom(roomId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: babbleTitleColor,
                ),
              ],
            );
          }
          var roomConfig = isHost
              ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
              : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();
          return ZegoUIKitPrebuiltLiveAudioRoom(
            events: ZegoUIKitPrebuiltLiveAudioRoomEvents(
              onLeaveConfirmation: (event, defaultAction) async {
                await ref
                    .read(roomControllerProvider)
                    .removePhoneNumberAsSpeaking(
                        roomId: roomId, phoneNumber: userData!.phoneNumber);

                return await defaultAction.call();
              },
            ),
            appID: ZegoCloudConfig.appId, // your AppID,
            appSign: ZegoCloudConfig.appSign,
            userID: userData!.uid,
            userName: userData!.phoneNumber,
            roomID: roomId,
            config: roomConfig
              ..seat = ZegoLiveAudioRoomSeatConfig(
                  takeIndexWhenJoining: isHost ? 0 : -1,
                  avatarBuilder: (context, size, user, extraInfo) {
                    if (user!.microphone.value) {
                      Future(() => ref
                          .read(roomControllerProvider)
                          .addPhoneNumberAsSpeaking(
                              roomId: roomId,
                              phoneNumber: userData!.phoneNumber));
                    } else {
                      Future(() => ref
                          .read(roomControllerProvider)
                          .removePhoneNumberAsSpeaking(
                              roomId: roomId,
                              phoneNumber: userData!.phoneNumber));
                    }
                    return FutureBuilder(
                      initialData: const AssetImage(defaultProfilePic),
                      future: Future(() async {
                        var profilePic = await ref
                            .watch(chatControllerProvider)
                            .getProfilePicOfAUser(userId: user.id);
                        if (profilePic == '') {
                          return const AssetImage(defaultProfilePic);
                        } else {
                          return NetworkImage(profilePic);
                        }
                      }),
                      builder: (context, snapshot) => Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                snapshot.data! as ImageProvider<Object>,
                            radius: chatListImageRadii,
                          ),
                          if (user.id != userData!.uid)
                            FutureBuilder(
                              future: ref
                                  .read(contactsRepositoryProvider)
                                  .ifSavedContactName(
                                      phoneNumberFromServerToCheck: user.name),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    user.name != snapshot.data) {
                                  return Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        snapshot.data!.split(' ').first,
                                        textAlign: TextAlign.center,
                                        style: roomSpeakingMemberInNameTS,
                                      ));
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            )
                          else
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "You",
                                textAlign: TextAlign.center,
                                style: roomSpeakingMemberInNameTS,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  hostIndexes: const [0],
                  showSoundWaveInAudioMode: true)
              ..duration = ZegoLiveAudioRoomLiveDurationConfig(isVisible: true)
              ..useSpeakerWhenJoining = false
              ..turnOnMicrophoneWhenJoining = true
              ..background = Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: roomBgGradientList)),
              )
              ..turnOnMicrophoneWhenJoining = true
              ..seat.closeWhenJoining = false
              ..memberList = ZegoLiveAudioRoomMemberListConfig(
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

                  return RoomOccupantNameTile(
                    user: user,
                  );
                },
              ),
          );
        });
  }
}
