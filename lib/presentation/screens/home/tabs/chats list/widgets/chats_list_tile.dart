import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/radii.dart';
import '../../../../../../core/strings.dart';
import '../../../../../../core/textstyles.dart';

class ChatsListTile extends StatelessWidget {
  final String name;
  final String profilePic;
  final DateTime timeSent;
  final String lastMessage;
  const ChatsListTile({
    super.key,
    required this.name,
    required this.profilePic,
    required this.timeSent,
    required this.lastMessage,
  });
  String timeOrDate(DateTime timeSent) {
    //var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String toDisplay = '';
    final aDate = DateTime(timeSent.year, timeSent.month, timeSent.day);

    if (aDate == today) {
      toDisplay = DateFormat('hh:mm a').format(timeSent);
    } else if (aDate == yesterday) {
      toDisplay = "Yesterday";
    } else {
      toDisplay = DateFormat('dd/MM/y').format(timeSent).toString();
    }

    return toDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2 * chatListImageRadii,
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          profilePic != ''
              ? CircleAvatar(
                  backgroundImage: NetworkImage(profilePic),
                  radius: chatListImageRadii,
                )
              : const CircleAvatar(
                  backgroundImage: AssetImage(defaultProfilePic),
                  radius: chatListImageRadii,
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        style: chatListTileNameTextStyle,
                      ),
                      Text(
                        lastMessage,
                        maxLines: 1,
                        style: chatListTileLastMsgTextStyle,
                      )
                    ],
                  ),
                  Text(
                    timeOrDate(timeSent),
                    style: chatListTileLastMsgTimeTextStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
