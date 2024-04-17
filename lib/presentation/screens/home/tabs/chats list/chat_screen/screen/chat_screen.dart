import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_messages_list.dart';

class ChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final String profilePic;
  const ChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: ChatAppBar(
            name: name,
            uid: uid,
            profilePic: profilePic,
          )),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ChatMessagesList(
                receiverUserId: uid,
              ),
            ),
            BottomChatField(
              name: name,
              receiverUserId: uid,
            ),
          ],
        ),
      ),
    );
  }
}
