import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chat_contact.dart';
import 'data_provider_for_chat_list_tile.dart';

class ChatListBuilderFromSnapshot extends StatelessWidget {
  final AsyncSnapshot<List<ChatContact>> snapshot;
  const ChatListBuilderFromSnapshot({
    super.key,
    required this.snapshot,
    required this.ref,
    required this.name,
  });

  final WidgetRef ref;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        var chatContactData = snapshot.data![index];
        return DataProviderForChatListTile(
            chatContactData: chatContactData, ref: ref, name: name);
      },
    );
  }
}
