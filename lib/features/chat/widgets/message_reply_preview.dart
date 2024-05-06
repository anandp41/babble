import 'package:babble/common/providers/message_reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/misc.dart';
import 'display_file.dart';

class MessageReplyPreview extends ConsumerWidget {
  final String name;
  const MessageReplyPreview({super.key, required this.name});
  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      width: screenWidth - widthToDecreaseForMessageCard,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.transparent.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Container(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: bodyBackgroundColor.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: senderMessageNameColor,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 14,
                      onPressed: () => cancelReply(ref),
                      icon: const Icon(
                        Icons.close,
                      ),
                    )
                  ],
                ),
              ),
              DisplayTextImageGIF(
                  isMyMessage: false,
                  message: messageReply!.message,
                  type: messageReply.messageEnum),
            ],
          ),
        ),
      ),
    );
  }
}
