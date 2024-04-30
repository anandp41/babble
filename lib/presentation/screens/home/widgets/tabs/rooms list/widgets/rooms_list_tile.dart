import 'package:babble/repositories/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:babble/models/room_model.dart';
import 'package:babble/presentation/screens/home/widgets/tabs/rooms%20list/widgets/room/screen/room.dart';

import '../../../../../../../controller/auth_controller.dart';
import '../../../../../../../core/radii.dart';
import '../../../../../../../core/strings.dart';
import '../../../../../../../core/textstyles.dart';
import '../../../../../../../models/user_model.dart';

class RoomsListTile extends ConsumerWidget {
  final RoomModel roomData;
  final UserModel? userData;

  const RoomsListTile({
    super.key,
    required this.roomData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Get.to(() => Room(roomData: roomData, userData: userData));
      },
      child: Container(
        height: 2 * chatListImageRadii,
        margin: const EdgeInsets.all(10),
        child: Row(
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
              child: Column(
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
                  Expanded(
                    flex: 1,
                    child: roomData.speakingPhoneNumbers.isNotEmpty
                        ? Row(
                            children: [
                              const Icon(
                                Icons.mic,
                                size: 20,
                                color: Colors.green,
                              ),
                              const Icon(
                                Icons.group,
                                size: 20,
                                color: Colors.blue,
                              ),
                              FutureBuilder(
                                initialData:
                                    roomData.speakingPhoneNumbers.join(', '),
                                future: Future(() async {
                                  List<String> names = [];
                                  for (var number
                                      in roomData.speakingPhoneNumbers) {
                                    String name = await ref
                                        .read(contactsRepositoryProvider)
                                        .ifSavedContactName(
                                            phoneNumberFromServerToCheck:
                                                number);
                                    names.add(name);
                                  }
                                  names.join(', ');
                                }),
                                builder: (context, snapshot) => Expanded(
                                  child: Text(
                                    snapshot.data!,
                                    maxLines: 1,
                                    style: roomsListTileSpeakingTitleTextStyle,
                                  ),
                                ),
                              )
                            ],
                          )
                        : const SizedBox(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
