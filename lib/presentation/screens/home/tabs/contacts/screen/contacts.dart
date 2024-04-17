import 'package:babble/core/misc.dart';
import 'package:babble/presentation/screens/common/custom_search_bar.dart';
import 'package:babble/presentation/screens/widgets/error_screen.dart';
import 'package:babble/presentation/screens/widgets/loader.dart';
import 'package:babble/controller/contacts_controller.dart';
import 'package:babble/presentation/screens/home/tabs/contacts/screen/widgets/contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/radii.dart';
import '../../../../../../core/strings.dart';
import '../../../../../../core/textstyles.dart';
import '../../chats list/chat_screen/screen/chat_screen.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactsScreenState();
}

Future<void> _launchSMS({required String phoneNumber}) async {
  final Uri url = Uri.parse('sms:+$phoneNumber?body=$prefilledInviteSMSText');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    Get.showSnackbar(const GetSnackBar(
        message: "Can't open SMS app", duration: snackbarDuration));
  }
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  String name = '';
  List<Contact> contactsOnBabble = [];
  List<Contact> contactsNotOnBabble = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CustomSearchBar(
            label: "Search contacts",
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          Expanded(
            child: ref.watch(getContactsProvider).when(
                data: (contactList) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
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
                            itemBuilder: (context1, index) {
                              final contact = contactList[index];
                              if (contact['uid'] != '' &&
                                  contact['name']!
                                      .toUpperCase()
                                      .contains(name.toUpperCase())) {
                                return InkWell(
                                    onTap: () => Get.to(() => ChatScreen(
                                        name: contact['name']!,
                                        uid: contact['uid']!,
                                        profilePic: contact['profile_pic']!)),
                                    child: ContactTile(
                                      name: contact['name']!,
                                      profilePic: contact['profile_pic']!,
                                      invite: false,
                                    ));
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          const Text(
                            "Invite to Babble",
                            style: roomHeadingsTextStyle,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: contactList.length,
                            itemBuilder: (context1, index) {
                              final contact = contactList[index];
                              if (contact['uid'] == '' &&
                                  contact['name']!
                                      .toUpperCase()
                                      .contains(name.toUpperCase())) {
                                return InkWell(
                                    onTap: () {
                                      _launchSMS(
                                          phoneNumber:
                                              contact['phone_number']!);
                                    },
                                    child: ContactTile(
                                      name: contact['name']!,
                                      invite: true,
                                    ));
                              } else {
                                return const SizedBox();
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
                },
                error: (error, stackTrace) =>
                    ErrorScreen(error: error.toString()),
                loading: () => const Loader()),
          )
        ],
      ),
    );
  }
}
