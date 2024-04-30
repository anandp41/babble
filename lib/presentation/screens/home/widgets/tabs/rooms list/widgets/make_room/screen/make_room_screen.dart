import 'dart:io';

import 'package:babble/controller/room_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../../../../../../../controller/contacts_controller.dart';
import '../../../../../../../../../core/radii.dart';
import '../../../../../../../../../core/textstyles.dart';
import '../../../../../../../../../utils/utils.dart';
import '../../../../../../../widgets/error_screen.dart';
import '../../../../../../../widgets/loader.dart';
import '../../../../chats list/chat_screen/screen/chat_screen.dart';
import '../../../../chats list/widgets/contacts/widgets/contact_tile.dart';
import '../widget/select_contacts_room.dart';

class MakeRoomScreen extends ConsumerStatefulWidget {
  const MakeRoomScreen({super.key});

  @override
  ConsumerState<MakeRoomScreen> createState() => _MakeRoomScreenState();
}

class _MakeRoomScreenState extends ConsumerState<MakeRoomScreen> {
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

  final roomNameController = TextEditingController();
  File? image;
  Future<void> selectImage() async {
    image = await Utils.pickImageFromGallery();

    setState(() {});
  }

  Future<void> makeRoom() async {
    if (roomNameController.text.trim().isNotEmpty) {
      await ref.read(roomControllerProvider).makeRoom(
          roomNameController.text.trim(),
          image,
          ref.read(selectedRoomContacts));
      Get.back();
      ref.read(selectedRoomContacts.state).update((state) => []);
    }
  }

  @override
  void dispose() {
    super.dispose();
    roomNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  height: 10,
                ),
                Center(
                  child: Stack(
                    children: [
                      image == null
                          ? const CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  AssetImage("assets/images/defRoom.png"),
                            )
                          : CircleAvatar(
                              radius: 64, backgroundImage: FileImage(image!)),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                            onPressed: () async {
                              await selectImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black87,
                            )),
                      )
                    ],
                  ),
                ),
                TextField(
                  controller: roomNameController,
                  decoration: const InputDecoration(
                      hintMaxLines: 1, hintText: "Enter room name"),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "Select contacts",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Hind',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SelectContactsRoom(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await makeRoom(),
        backgroundColor: babbleTitleColor,
        child: const Icon(
          Icons.done_all,
          color: Colors.white,
        ),
      ),
    );
  }
}
