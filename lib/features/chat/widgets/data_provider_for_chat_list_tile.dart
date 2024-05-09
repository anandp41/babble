import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chat_contact.dart';
import '../../select_contacts/controller/contacts_controller.dart';
import 'chats_list_tile.dart';

class DataProviderForChatListTile extends StatelessWidget {
  const DataProviderForChatListTile({
    super.key,
    required this.chatContactData,
    required this.ref,
    required this.name,
  });

  final ChatContact chatContactData;
  final WidgetRef ref;
  final String name;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: chatContactData.phoneNumber,
      future: ref.watch(selectContactControllerProvider).ifSavedContactName(
          phoneNumberFromServerToCheck: chatContactData.phoneNumber),
      builder: (context, snapshot) {
        var chatContactName = snapshot.data;
        if (chatContactName!
            .toUpperCase()
            .contains(name.trim().toUpperCase())) {
          return ChatsListTile(
              name: chatContactName, chatContactData: chatContactData);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
