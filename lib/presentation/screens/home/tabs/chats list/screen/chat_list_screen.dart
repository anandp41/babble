import 'package:babble/core/radii.dart';
import 'package:babble/presentation/screens/home/tabs/chats%20list/chat_screen/screen/chat_screen.dart';
import 'package:babble/presentation/screens/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../../../controller/chat_controller.dart';
import '../../../../../../models/chat_contact.dart';
import '../widgets/chats_list_tile.dart';
import '../../../../../common/list_tile_separator.dart';
import '../../../../common/custom_search_bar.dart';

class ChatsListScreen extends ConsumerWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomSearchBar(
          label: "Search chats",
          onChanged: (p0) {},
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) =>
                      const ListTileSeparator(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];

                    return InkWell(
                      onTap: () {
                        Get.to(() => ChatScreen(
                            name: chatContactData.name,
                            uid: chatContactData.contactId,
                            profilePic: chatContactData.profilePic));
                      },
                      child: ChatsListTile(
                        name: chatContactData.name,
                        profilePic: chatContactData.profilePic,
                        lastMessage: chatContactData.lastMessage,
                        timeSent: chatContactData.timeSent,
                      ),
                    );
                  },
                );
              }),
        ),
        const SizedBox(
          height: 3 * chatListImageRadii,
        )
      ],
    );
  }
}
