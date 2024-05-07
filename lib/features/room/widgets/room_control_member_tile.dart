import 'package:babble/common/widgets/error_screen.dart';
import 'package:babble/common/widgets/loader.dart';
import 'package:babble/features/auth/controller/auth_controller.dart';
import 'package:babble/features/room/controller/room_controller.dart';
import 'package:babble/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/textstyles.dart';
import '../../../core/radii.dart';
import '../../../core/strings.dart';
import '../../../models/room_model.dart';
import '../../chat/screens/chat_screen.dart';
import '../../select_contacts/repository/contacts_repository.dart';

class RoomControlMemberTile extends ConsumerWidget {
  final UserModel userData;
  final RoomModel roomData;
  const RoomControlMemberTile({
    super.key,
    required this.userData,
    required this.roomData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool nameFound = false;
    String name = '';

    return ref.read(userDataAuthProvider).when(
        data: (currentUserData) {
          return InkWell(
            child: SizedBox(
              height: 2 * chatListImageRadii,
              child: Row(
                children: [
                  userData.profilePic != ''
                      ? FutureBuilder(
                          initialData: const AssetImage(defaultProfilePic),
                          future:
                              Future(() => NetworkImage(userData.profilePic)),
                          builder: (context, snapshot) => CircleAvatar(
                            backgroundImage:
                                snapshot.data! as ImageProvider<Object>,
                            radius: chatListImageRadii,
                          ),
                        )
                      : const CircleAvatar(
                          backgroundImage: AssetImage(defaultProfilePic),
                          radius: chatListImageRadii,
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          userData.uid == currentUserData!.uid
                              ? const Text(
                                  "You",
                                  softWrap: true,
                                  maxLines: 1,
                                  textWidthBasis: TextWidthBasis.parent,
                                  style: chatListTileNameTextStyle,
                                )
                              : FutureBuilder(
                                  future: ref
                                      .watch(contactsRepositoryProvider)
                                      .ifSavedContactName(
                                          phoneNumberFromServerToCheck:
                                              userData.phoneNumber),
                                  initialData: userData.phoneNumber,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.data != userData.phoneNumber) {
                                      nameFound = true;
                                      name = snapshot.data!;
                                    }
                                    return Expanded(
                                      child: Text(
                                        snapshot.data!,
                                        softWrap: true,
                                        maxLines: 1,
                                        textWidthBasis: TextWidthBasis.parent,
                                        style: chatListTileNameTextStyle,
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                  currentUserData.uid == roomData.hostUid &&
                          currentUserData.uid != userData.uid
                      ? Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  shape: BoxShape.rectangle,
                                  color: roomControlExitIconBg),
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Are you sure?"),
                                        content: Text(
                                            "Remove ${nameFound ? name : userData.phoneNumber} from ${roomData.name} ?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(roomControllerProvider)
                                                  .removeAMember(
                                                      roomId: roomData.roomId,
                                                      memberId: userData.uid);
                                              ref.refresh(
                                                  roomControllerProvider);
                                              Get.back();
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: settingsRedButtonTS,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text(
                                              "No",
                                              style: settingsButtonTS,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.logout_outlined,
                                    size: 30,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (currentUserData.uid == roomData.hostUid)
                          InkWell(
                              onTap: () async {
                                await ref
                                    .read(roomControllerProvider)
                                    .makeMemberAsHost(
                                        roomId: roomData.roomId,
                                        memberId: userData.uid);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Text(
                                      "Make ${nameFound ? name : userData.phoneNumber} the host",
                                      style: dropDownListButtonTS,
                                    ),
                                  ),
                                ],
                              )),
                        InkWell(
                            onTap: () => Get.to(() => ChatScreen(
                                name: nameFound ? name : userData.phoneNumber,
                                phoneNumber: userData.phoneNumber,
                                uid: userData.uid,
                                profilePic: userData.profilePic)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    "Message ${nameFound ? name : userData.phoneNumber}",
                                    style: dropDownListButtonTS,
                                  ),
                                ),
                              ],
                            )),
                        if (!nameFound)
                          InkWell(
                              onTap: () async {
                                final newContact = Contact()
                                  ..name.first = userData.name
                                  ..name.last = ''
                                  ..phones = [Phone(userData.phoneNumber)];
                                await FlutterContacts.openExternalInsert(
                                    newContact);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Text(
                                      "Add to contacts",
                                      style: dropDownListButtonTS,
                                    ),
                                  ),
                                ],
                              ))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const Loader());
  }
//     );
}
// }
