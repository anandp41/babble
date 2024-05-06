import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../widgets/bottom_chat_field_if_needed.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_messages_list.dart';

class ChatScreen extends ConsumerWidget {
  final String uid;
  final String phoneNumber;
  final String profilePic;
  final String name;
  const ChatScreen({
    super.key,
    required this.uid,
    required this.phoneNumber,
    required this.profilePic,
    required this.name,
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
            name: name,
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
            BottomChatFieldIfNeeded(uid: uid, phoneNumber: phoneNumber)
          ],
        ),
      ),
    );
  }
}
