import 'package:babble/features/chat/widgets/profile_pic_viewer.dart';
import 'package:babble/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../../../core/radii.dart';
import '../../../../../core/strings.dart';
import '../screens/chat_screen.dart';
import 'chat_list_tile_name_field.dart';

class ChatsListTile extends ConsumerWidget {
  final ChatContact chatContactData;
  final String name;
  const ChatsListTile(
      {super.key, required this.chatContactData, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Get.to(() => ChatScreen(
          name: name,
          phoneNumber: chatContactData.phoneNumber,
          uid: chatContactData.contactId,
          profilePic: chatContactData.profilePic)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 2 * chatListImageRadii,
        child: Row(
          children: [
            InkWell(
              onTap: () => Get.to(
                () => ProfilePicViewer(
                  imageUrl: chatContactData.profilePic,
                  name: name,
                  isRoom: false,
                  roomId: null,
                ),
                transition: Transition.fadeIn,
              ),
              child: chatContactData.profilePic != ''
                  ? FutureBuilder(
                      initialData: const AssetImage(defaultProfilePic),
                      future: Future(
                          () => NetworkImage(chatContactData.profilePic)),
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
            ),
            ChatListTileNameField(name: name, chatContactData: chatContactData),
          ],
        ),
      ),
    );
  }
}
