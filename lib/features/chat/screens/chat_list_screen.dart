import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:babble/core/colors.dart';
import 'package:babble/core/radii.dart';
import '../../../../../models/chat_contact.dart';
import '../../../common/widgets/custom_search_bar.dart';
import '../../../common/widgets/error_screen.dart';
import '../../../core/colors.dart';
import '../controller/chat_controller.dart';
import '../widgets/chat_list_builder_from_snapshot.dart';

class ChatsListScreen extends ConsumerStatefulWidget {
  const ChatsListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatsListScreenState();
}

class _ChatsListScreenState extends ConsumerState<ChatsListScreen> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          label: "Search chats",
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: StreamBuilder<List<ChatContact>>(
              stream: ref.watch(chatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: babbleTitleColor,
                      ),
                    ],
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const ErrorScreen(error: "You have no chats");
                }
                return ChatListBuilderFromSnapshot(
                  ref: ref,
                  name: name,
                  snapshot: snapshot,
                );
              }),
        ),
        const SizedBox(
          height: 3 * chatListImageRadii,
        )
      ],
    );
  }
}
