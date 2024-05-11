import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/misc.dart';
import '../../../../../core/textstyles.dart';
import '../../../common/enums/message_enum.dart';
import 'display_file.dart';

class MyMessageCard extends StatelessWidget {
  final String message;

  final bool isMyMessage;
  final String date;
  final MessageEnum type;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  const MyMessageCard({
    super.key,
    required this.isMyMessage,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  });

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    final replyMinWidth = MediaQuery.of(context).size.width / 2;
    return SwipeTo(
      onLeftSwipe: () => onLeftSwipe(),
      child: Align(
        alignment: Alignment.centerRight,
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
                    bottomLeft: Radius.circular(messageBorderRadius),
                    bottomRight: Radius.circular(messageBorderRadius),
                    topLeft: Radius.circular(messageBorderRadius),
                    topRight: Radius.zero)),
            color: myMessageCardColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
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
                          decoration: BoxDecoration(
                              color: bodyBackgroundColor.withAlpha(30),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
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
                                      color: myMessageNameColor),
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
                        const SizedBox(height: 8)
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
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: myMessageCardTimeTextStyle,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen ? seenMsgTickColor : unseenMsgTickColor,
                      ),
                    ],
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
