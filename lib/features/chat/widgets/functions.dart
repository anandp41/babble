import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/providers/message_reply_provider.dart';

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

void onMessageSwipe(
    String message, bool isMe, MessageEnum messageEnum, WidgetRef ref) {
  ref
      .read(messageReplyProvider.notifier)
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
