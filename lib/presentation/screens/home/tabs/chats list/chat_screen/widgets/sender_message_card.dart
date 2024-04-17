import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../../../../common/enums/message_enum.dart';
import '../../../../../../../core/colors.dart';
import '../../../../../../../core/misc.dart';
import '../../../../../../../core/textstyles.dart';
import 'display_file.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.isMyMessage,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  });
  final bool isMyMessage;
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    final replyMinWidth = MediaQuery.of(context).size.width / 2;
    return SwipeTo(
      onRightSwipe: () => onRightSwipe(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: isReplying ? replyMinWidth : 120,
            maxWidth: MediaQuery.of(context).size.width -
                widthToDecreaseForMessageCard,
          ),
          child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.zero,
                    topRight: Radius.circular(20))),
            color: senderMessageCardColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          top: 5, left: 5, right: 5, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isReplying) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: senderMessageReplyBgColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: replyMinWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: senderMessageNameColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                DisplayTextImageGIF(
                                    isMyMessage: isMyMessage,
                                    message: repliedText,
                                    type: repliedMessageType),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      DisplayTextImageGIF(
                          isMyMessage: isMyMessage,
                          message: message,
                          type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Text(
                    date,
                    style: senderCardTimeTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
