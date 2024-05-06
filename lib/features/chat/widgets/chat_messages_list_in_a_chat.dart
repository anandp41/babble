import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/colors.dart';
import '../../../core/misc.dart';
import '../../../core/textstyles.dart';
import '../../../models/message.dart';
import 'chat_messages_list.dart';
import 'functions.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

class ChatMessagesListInAChat extends StatelessWidget {
  const ChatMessagesListInAChat({
    super.key,
    required this.printDate,
    required this.newDate,
    required this.messageData,
    required this.widget,
    required this.timeSent,
    required this.ref,
  });

  final bool printDate;
  final String newDate;
  final Message messageData;
  final ChatMessagesList widget;
  final String timeSent;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (printDate)
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: chatScreenDateBg,
                      borderRadius: BorderRadius.circular(messageBorderRadius)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newDate,
                      style: chatDateTextStyle,
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
            onLeftSwipe: () =>
                onMessageSwipe(messageData.text, true, messageData.type, ref),
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
                  messageData.text, false, messageData.type, ref))
      ],
    );
  }
}
