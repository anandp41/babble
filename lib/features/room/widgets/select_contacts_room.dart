import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/custom_search_bar.dart';
import '../../../core/colors.dart';
import '../../../core/radii.dart';
import '../../../core/textstyles.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../select_contacts/controller/contacts_controller.dart';
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
            .read(selectedRoomContacts.notifier)
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
            .read(newMembersUids.notifier)
            .update((state) => [...state, contact['uid']!]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomSearchBar(
            label: "Search contacts",
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          kIsWeb
              ? FutureBuilder<UserModel?>(
                  future:
                      ref.watch(authControllerProvider).getCurrentUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    UserModel userData = snapshot.data!;
                    var contactList = userData.savedContacts;
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Contacts on Babble",
                              style: roomHeadingsTextStyle,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: contactList.length,
                              itemBuilder: (context, index) {
                                final contact = contactList[index];

                                if (contact.uid != '' &&
                                    contact.name
                                        .toUpperCase()
                                        .contains(name.trim().toUpperCase()) &&
                                    !widget.alreadyMembers
                                        .contains(contact.uid)) {
                                  return InkWell(
                                    onTap: () => selectContact(contact.toMap()),
                                    child: ListTile(
                                      title: ContactTile(
                                        name: contact.name,
                                        profilePic: contact.profilePic,
                                        invite: false,
                                      ),
                                      trailing: selectedContactsUid
                                              .contains(contact.uid)
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
                            const SizedBox(
                              height: 3 * chatListImageRadii,
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : RefreshIndicator(
                  onRefresh: () async {
                    // ignore: unused_result
                    ref.refresh(savedContactsOnBabbleProvider);
                    ref
                        .read(selectContactControllerProvider)
                        .updateSavedContactsListToServe(ref: ref);
                  },
                  child: ref.watch(savedContactsOnBabbleProvider).when(
                        data: (contactList) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: contactList.length,
                            itemBuilder: (context, index) {
                              final contact = contactList[index];

                              if (contact['uid'] != '' &&
                                  contact['name']!
                                      .toUpperCase()
                                      .contains(name.trim().toUpperCase()) &&
                                  !widget.alreadyMembers
                                      .contains(contact['uid'])) {
                                return InkWell(
                                  onTap: () => selectContact(contact),
                                  child: ListTile(
                                    title: ContactTile(
                                      name: contact['name']!,
                                      profilePic: contact['profile_pic']!,
                                      invite: false,
                                    ),
                                    trailing: selectedContactsUid
                                            .contains(contact['uid'])
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
                          );
                        },
                        error: (error, stackTrace) => Text(
                          stackTrace.toString(),
                          style: roomControlMembersTitleTextStyle,
                        ),
                        loading: () => const CircularProgressIndicator(
                          color: babbleTitleColor,
                        ),
                      ))
        ],
      ),
    );
  }
}
