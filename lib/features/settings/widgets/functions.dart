import 'package:babble/features/room/controller/room_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/functions/functions.dart';
import '../../../core/colors.dart';
import '../../../core/strings.dart';
import '../../../core/textstyles.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/registration.dart';

babbleAboutDialog(BuildContext context) {
  return showAboutDialog(
      barrierDismissible: true,
      context: context,
      applicationName: appTitle,
      barrierLabel: "App info",
      applicationVersion: appVersion,
      children: [
        const Text("Created by: Anand P",
            style: TextStyle(color: Colors.black)),
        const SizedBox(
          height: 6,
        ),
        RichText(
          text: TextSpan(children: <TextSpan>[
            const TextSpan(
                text: 'Email: ', style: TextStyle(color: Colors.black)),
            TextSpan(
                text: myEmail,
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchEmailSubmission();
                  })
          ]),
        ),
        const SizedBox(
          height: 6,
        ),
        RichText(
          text: TextSpan(
              text: "LinkedIn",
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await launchUrl(Uri.parse(myLinkedInUrl));
                }),
        ),
        const SizedBox(
          height: 6,
        ),
        const Text(formalDescriptionOfBabble),
      ]);
}

deleteAccountDialog(BuildContext context, WidgetRef ref) {
  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content:
              const Text("Tapping 'Yes' will delete your account permanently"),
          actions: [
            TextButton(
              onPressed: () async {
                await ref
                    .read(authControllerProvider)
                    .deleteAccountPermanenlty(ref: ref);
                Get.offAll(() => const RegistrationScreen(),
                    transition: Transition.zoom);
              },
              child: const Text(
                "Yes",
                style: settingsRedButtonTS,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: settingsButtonTS,
              ),
            ),
          ],
        );
      });
}

Future<dynamic> showNameBottomSheet(
    BuildContext context, String name, WidgetRef ref,
    {bool isRoom = false, String? roomId}) {
  var newNameController = TextEditingController(text: name);
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: settingsNameSheetBg,
    context: context,
    builder: (context1) {
      return Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context1).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRoom ? "Enter room name" : "Enter your name",
              style: settingsNameSheetTextStyle,
            ),
            TextField(
              autofocus: true,
              style: settingsNameSheetTextStyle,
              cursorColor: Colors.white,
              maxLength: 25,
              controller: newNameController,
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: settingsButtonTS,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (newNameController.text != name &&
                        newNameController.text != '') {
                      if (isRoom) {
                        await ref.read(roomControllerProvider).updateRoomName(
                            ref: ref, name: name, roomId: roomId!);
                        Get.back();
                        ref.refresh(roomControllerProvider);
                      } else {
                        await ref.read(authControllerProvider).updateUserName(
                            name: newNameController.text.trim(), ref: ref);
                        Get.back();
                        ref.refresh(userDataAuthProvider);
                      }
                    }
                    if (newNameController.text == '') {
                      showCustomSnackBar(message: 'Enter valid name');
                    }
                  },
                  child: const Text(
                    "Save",
                    style: settingsButtonTS,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future<void> launchEmailSubmission() async {
  final Uri params = Uri(
      scheme: 'mailto',
      path: 'apanandp41@gmail.com',
      query: 'subject=Feedback for Babble');
  if (await canLaunchUrl(params)) {
    await launchUrl(params);
  } else {
    debugPrint('Could not launch $params');
  }
}
