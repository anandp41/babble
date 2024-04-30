import 'package:babble/models/chat_contact.dart';
import 'package:babble/repositories/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../../core/radii.dart';
import '../../../../../../../core/strings.dart';
import '../../../../../../../core/textstyles.dart';
import '../chat_screen/screen/chat_screen.dart';

class ChatsListTile extends ConsumerWidget {
  final ChatContact chatContactData;
  const ChatsListTile({
    super.key,
    required this.chatContactData,
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
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => Get.to(() => ChatScreen(
          name: chatContactData.name,
          phoneNumber: chatContactData.phoneNumber,
          uid: chatContactData.contactId,
          profilePic: chatContactData.profilePic)),
      child: SizedBox(
        height: 2 * chatListImageRadii,
        child: Row(
          children: [
            chatContactData.profilePic != ''
                ? FutureBuilder(
                    initialData: const AssetImage(defaultProfilePic),
                    future:
                        Future(() => NetworkImage(chatContactData.profilePic)),
                    builder: (context, snapshot) => CircleAvatar(
                      backgroundImage: snapshot.data! as ImageProvider<Object>,
                      radius: chatListImageRadii,
                    ),
                  )
                : const CircleAvatar(
                    backgroundImage: AssetImage(defaultProfilePic),
                    radius: chatListImageRadii,
                  ),
            Expanded(
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
                              FutureBuilder(
                                future: ref
                                    .watch(contactsRepositoryProvider)
                                    .ifSavedContactName(
                                        phoneNumberFromServerToCheck:
                                            chatContactData.phoneNumber),
                                initialData: chatContactData.phoneNumber,
                                builder: (context, snapshot) {
                                  return Expanded(
                                    child: Text(
                                      snapshot.data!,
                                      softWrap: true,
                                      maxLines: 1,
                                      textWidthBasis: TextWidthBasis.parent,
                                      overflow: TextOverflow.ellipsis,
                                      style: chatListTileNameTextStyle,
                                    ),
                                  );
                                },
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
            ),
          ],
        ),
      ),
    );
  }
}
