import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/chat_controller.dart';
import 'bottom_chat_field.dart';

class BottomChatFieldIfNeeded extends ConsumerWidget {
  const BottomChatFieldIfNeeded({
    super.key,
    required this.uid,
    required this.phoneNumber,
  });

  final String uid;
  final String phoneNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      initialData: true,
      future: ref.read(chatControllerProvider).doesThisUserExistNow(uid: uid),
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
    );
  }
}
