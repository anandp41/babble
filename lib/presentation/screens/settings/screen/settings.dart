import 'dart:io';

import 'package:babble/core/colors.dart';
import 'package:babble/core/misc.dart';
import 'package:babble/core/strings.dart';
import 'package:babble/models/user_model.dart';
import 'package:babble/presentation/common/list_tile_separator.dart';
import 'package:babble/presentation/screens/common/appbar_back_button.dart';
import 'package:babble/presentation/screens/widgets/error_screen.dart';
import 'package:babble/presentation/screens/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../core/textstyles.dart';
import '../../../../utils/utils.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> selectImage() async {
    File? image = await Utils.pickImageFromGallery();
    if (image != null) {
      await ref
          .read(authControllerProvider)
          .updateUserProfilePic(profilePic: image, ref: ref);
      ref.refresh(userDataAuthProvider);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userDataAuthProvider).when(
          data: (userData) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: chatAppBarBg,
                centerTitle: false,
                leading: const AppBarBackButton(),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Hind',
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
              ),
              body: SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            userData!.profilePic == ''
                                ? const CircleAvatar(
                                    radius: 64,
                                    backgroundImage:
                                        AssetImage(defaultProfilePic),
                                  )
                                : CircleAvatar(
                                    radius: 64,
                                    backgroundImage: NetworkImage(
                                        userData.profilePic,
                                        scale: 16 / 9)),
                            Positioned(
                              bottom: -5,
                              right: -5,
                              child: IconButton(
                                  onPressed: () async {
                                    await selectImage();
                                  },
                                  icon: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: babbleTitleColor,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  )),
                            )
                          ],
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Name",
                                style: TextStyle(
                                    fontFamily: 'Hind',
                                    fontSize: 13,
                                    color: Colors.black87),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userData.name,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: 'Hind',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: babbleTitleColor),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showNameBottomSheet(context, userData);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: babbleTitleColor,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const ListTileSeparator(),
                    InkWell(
                      onTap: () {
                        deleteAccountDialog(context);
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          "Delete account permanently",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontFamily: 'Hind'),
                        ),
                      ),
                    )
                  ],
                ),
              )),
            );
          },
          error: (error, stackTrace) => ErrorScreen(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  Future<dynamic> deleteAccountDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text(
                "Tapping 'Yes' will delete your account permanently"),
            actions: [
              TextButton(
                onPressed: () async {
                  ref
                      .read(authControllerProvider)
                      .deleteAccountPermanenlty(ref: ref);
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
      BuildContext context, UserModel userData) {
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
              const Text(
                "Enter your name",
                style: settingsNameSheetTextStyle,
              ),
              TextField(
                autofocus: true,
                style: settingsNameSheetTextStyle,
                cursorColor: Colors.white,
                maxLength: 25,
                controller: nameController..text = userData.name,
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
                      if (nameController.text != userData.name &&
                          nameController.text != '') {
                        if (nameController.text == '') {
                          Get.showSnackbar(const GetSnackBar(
                            duration: snackbarDuration,
                            message: 'Enter valid name',
                          ));
                        }
                        await ref.read(authControllerProvider).updateUserName(
                            name: nameController.text.trim(), ref: ref);
                        Get.back();
                        ref.refresh(userDataAuthProvider);
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
}
