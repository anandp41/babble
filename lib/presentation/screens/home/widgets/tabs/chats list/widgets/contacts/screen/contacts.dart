import 'package:babble/controller/auth_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:babble/core/misc.dart';
import 'package:babble/presentation/screens/common/custom_search_bar.dart';
import 'package:babble/presentation/screens/widgets/error_screen.dart';
import 'package:babble/presentation/screens/widgets/loader.dart';
import 'package:babble/controller/contacts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../../../core/radii.dart';
import '../../../../../../../../../core/strings.dart';
import '../../../../../../../../../core/textstyles.dart';
import '../../../chat_screen/screen/chat_screen.dart';
import '../widgets/contact_tile.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContactsScreenState();
}

Future<void> _launchSMS(
    {required String phoneNumber, required WidgetRef ref}) async {
  var prefilledSMSText = '';
  ref.read(smsDataProvider).whenData(
        (value) => prefilledSMSText = value,
      );
  if (prefilledSMSText == '') {
    prefilledSMSText = hardcodedPrefilledInviteSMSText;
  }
  final Uri url = Uri.parse('sms:+$phoneNumber?body=$prefilledSMSText');
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
  late List<Map<String, String>> data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    size: 32,
                    color: babbleTitleColor,
                  )),
              const SizedBox(
                height: 16,
              ),
              CustomSearchBar(
                label: "Search contacts",
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(contactsOnBabbleProvider);
                  },
                  child: ref.watch(contactsOnBabbleProvider).when(
                      data: (contactList) {
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
                                  itemBuilder: (context1, index) {
                                    final contact = contactList[index];
                                    if (contact['uid'] != '' &&
                                        contact['name']!
                                            .toUpperCase()
                                            .contains(name.toUpperCase())) {
                                      return InkWell(
                                          onTap: () {
                                            var routeToRemove = Get.rawRoute;
                                            Get.to(
                                                () => ChatScreen(
                                                    name: contact['name']!,
                                                    phoneNumber: contact[
                                                        'phone_number']!,
                                                    uid: contact['uid']!,
                                                    profilePic: contact[
                                                        'profile_pic']!),
                                                arguments: routeToRemove);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ContactTile(
                                              name: contact['name']!,
                                              profilePic:
                                                  contact['profile_pic']!,
                                              invite: false,
                                            ),
                                          ));
                                    } else {
                                      return const SizedBox.shrink();
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
                                                    contact['phone_number']!,
                                                ref: ref);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ContactTile(
                                              name: contact['name']!,
                                              invite: true,
                                            ),
                                          ));
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
                      },
                      error: (error, stackTrace) =>
                          ErrorScreen(error: error.toString()),
                      loading: () => const Loader()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
