import 'package:babble/controller/contacts_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:babble/presentation/screens/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../../../../../../core/textstyles.dart';
import '../../../../../../../common/custom_search_bar.dart';
import '../../../../chats list/chat_screen/screen/chat_screen.dart';
import '../../../../chats list/widgets/contacts/widgets/contact_tile.dart';

final selectedRoomContacts =
    StateProvider<List<Map<String, String>>>((ref) => []);

class SelectContactsRoom extends ConsumerStatefulWidget {
  const SelectContactsRoom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsRoomState();
}

class _SelectContactsRoomState extends ConsumerState<SelectContactsRoom> {
  List<String> selectedContactsUid = [];
  String name = '';
  void selectContact(Map<String, String> contact) {
    if (selectedContactsUid.contains(contact['uid'])) {
      selectedContactsUid.remove(contact['uid']);
    } else {
      selectedContactsUid.add(contact['uid']!);
    }
    setState(() {
      ref
          .read(selectedRoomContacts.state)
          .update((state) => [...state, contact]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomSearchBar(
          label: "Search contacts",
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        RefreshIndicator(
            onRefresh: () async {
              ref.refresh(contactsOnBabbleProvider);
            },
            child: ref.watch(contactsOnBabbleProvider).when(
                  data: (contactList) => Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contactList.length,
                        itemBuilder: (context, index) {
                          final contact = contactList[index];

                          if (contact['uid'] != '' &&
                              contact['name']!
                                  .toUpperCase()
                                  .contains(name.toUpperCase())) {
                            return InkWell(
                              onTap: () => selectContact(contact),
                              child: ListTile(
                                title: ContactTile(
                                  name: contact['name']!,
                                  profilePic: contact['profile_pic']!,
                                  invite: false,
                                ),
                                trailing:
                                    selectedContactsUid.contains(contact['uid'])
                                        ? const CircleAvatar(
                                            backgroundColor: babbleTitleColor,
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                  error: (error, stackTrace) =>
                      ErrorScreen(error: error.toString()),
                  loading: () => const CircularProgressIndicator(
                    color: babbleTitleColor,
                  ),
                ))
      ],
    );
  }
}
