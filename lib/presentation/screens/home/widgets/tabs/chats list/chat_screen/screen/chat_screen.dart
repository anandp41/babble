import 'package:babble/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_messages_list.dart';

class ChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final String phoneNumber;
  final String profilePic;

  const ChatScreen({
    super.key,
    required this.name,
    required this.uid,
    required this.phoneNumber,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var routeToRemove = Get.arguments;
    if (routeToRemove != null) {
      Get.removeRoute(routeToRemove);
    }
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: ChatAppBar(
            phoneNumber: phoneNumber,
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
            FutureBuilder(
              initialData: true,
              future: ref
                  .read(chatControllerProvider)
                  .doesThisUserExistNow(uid: uid),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return BottomChatField(
                    phoneNumber: phoneNumber,
                    receiverUserId: uid,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
