import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../models/message.dart';
import '../../../common/widgets/error_screen.dart';
import '../../../common/widgets/loader.dart';
import '../controller/chat_controller.dart';
import 'chat_messages_list_in_a_chat.dart';
import 'functions.dart';

class ChatMessagesList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatMessagesList({
    super.key,
    required this.receiverUserId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatMessagesListState();
}

class _ChatMessagesListState extends ConsumerState<ChatMessagesList> {
  final messageController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return const ErrorScreen(error: "Check connectivity");
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.animateTo(
                messageController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          });
          String? date = '';
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              bool printDate = false;

              final Message messageData = snapshot.data![index];
              var timeSent = DateFormat('hh:mm a').format(messageData.timeSent);
              String newDate = groupMessageDateAndTime(
                      messageData.timeSent.microsecondsSinceEpoch.toString())
                  .toString();
              if (date != newDate) {
                date = newDate;
                printDate = true;
              }

              if (!messageData.isSeen &&
                  messageData.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                    receiverUserId: widget.receiverUserId,
                    messageId: messageData.messageId);
              }

              return ChatMessagesListInAChat(
                  printDate: printDate,
                  newDate: newDate,
                  messageData: messageData,
                  widget: widget,
                  timeSent: timeSent,
                  ref: ref);
            },
          );
        });
  }
}
