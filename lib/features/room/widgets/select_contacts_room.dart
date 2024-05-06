import 'package:babble/features/select_contacts/controller/contacts_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/custom_search_bar.dart';
import '../../../common/widgets/error_screen.dart';
import '../../select_contacts/widgets/contact_tile.dart';

final selectedRoomContacts =
    StateProvider<List<Map<String, String>>>((ref) => []);

final newMembersUids = StateProvider<List<String>>((ref) => []);

class SelectContactsRoom extends ConsumerStatefulWidget {
  final List<String> alreadyMembers;
  const SelectContactsRoom({super.key, this.alreadyMembers = const []});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsRoomState();
}

class _SelectContactsRoomState extends ConsumerState<SelectContactsRoom> {
  List<String> selectedContactsUid = [];
  String name = '';
  void selectContact(Map<String, String> contact) {
    if (widget.alreadyMembers.isEmpty) {
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
    } else {
      if (selectedContactsUid.contains(contact['uid'])) {
        selectedContactsUid.remove(contact['uid']);
      } else {
        selectedContactsUid.add(contact['uid']!);
      }
      setState(() {
        ref
            .read(newMembersUids.state)
            .update((state) => [...state, contact['uid']!]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                    data: (contactList) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contactList.length,
                      itemBuilder: (context, index) {
                        final contact = contactList[index];

                        if (contact['uid'] != '' &&
                            contact['name']!
                                .toUpperCase()
                                .contains(name.trim().toUpperCase()) &&
                            !widget.alreadyMembers.contains(contact['uid'])) {
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
                    error: (error, stackTrace) =>
                        ErrorScreen(error: error.toString()),
                    loading: () => const CircularProgressIndicator(
                      color: babbleTitleColor,
                    ),
                  ))
        ],
      ),
    );
  }
}
