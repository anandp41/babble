import 'package:flutter/material.dart';

import '../../../core/textstyles.dart';
import '../../../models/chat_contact.dart';
import 'functions.dart';

class ChatListTileNameField extends StatelessWidget {
  const ChatListTileNameField({
    super.key,
    required this.name,
    required this.chatContactData,
  });

  final String name;
  final ChatContact chatContactData;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          softWrap: true,
                          maxLines: 1,
                          textWidthBasis: TextWidthBasis.parent,
                          overflow: TextOverflow.ellipsis,
                          style: chatListTileNameTextStyle,
                        ),
                      ),
                      Text(
                        timeOrDate(chatContactData.timeSent),
                        style: chatListTileLastMsgTimeTextStyle,
                      )
                    ],
                  ),
                  Expanded(
                    child: Text(
                      chatContactData.lastMessage,
                      maxLines: 1,
                      softWrap: true,
                      textWidthBasis: TextWidthBasis.parent,
                      overflow: TextOverflow.ellipsis,
                      style: chatListTileLastMsgTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
