import 'package:babble/common/providers/message_reply_provider.dart';
import 'package:babble/presentation/screens/widgets/error_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:babble/controller/chat_controller.dart';
import 'package:babble/presentation/screens/widgets/loader.dart';

import '../../../../../../../../common/enums/message_enum.dart';
import '../../../../../../../../core/misc.dart';
import '../../../../../../../../models/message.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

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

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref
        .read(messageReplyProvider.state)
        .update((state) => MessageReply(message, isMe, messageEnum));
  }

  String groupMessageDateAndTime(String time) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      difference = "Today";
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = DateFormat.yMMMd().format(dt).toString();
    }

    return difference;
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

              return Column(
                children: [
                  if (printDate)
                    Center(
                        child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 87, 88, 89),
                                borderRadius:
                                    BorderRadius.circular(messageBorderRadius)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                newDate,
                                style: const TextStyle(
                                    fontFamily: 'Hind',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                    fontSize: 12),
                              ),
                            ))),
                  if (messageData.receiverId == widget.receiverUserId)
                    MyMessageCard(
                      isMyMessage: true,
                      message: messageData.text,
                      date: timeSent,
                      type: messageData.type,
                      repliedText: messageData.repliedMessage,
                      username: messageData.repliedTo,
                      repliedMessageType: messageData.repliedMessageType,
                      isSeen: messageData.isSeen,
                      onLeftSwipe: () => onMessageSwipe(
                          messageData.text, true, messageData.type),
                    )
                  else
                    SenderMessageCard(
                        isMyMessage: false,
                        message: messageData.text,
                        date: timeSent,
                        type: messageData.type,
                        repliedText: messageData.repliedMessage,
                        username: messageData.repliedTo,
                        repliedMessageType: messageData.repliedMessageType,
                        onRightSwipe: () => onMessageSwipe(
                            messageData.text, false, messageData.type))
                ],
              );
            },
          );
        });
  }
}
