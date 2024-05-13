import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../../../../core/misc.dart';
import '../../../../../../core/strings.dart';
import '../../../../../../core/textstyles.dart';
import '../../../common/functions/functions.dart';
import '../../../common/utils/utils.dart';
import '../../../core/colors.dart';
import '../../home/screens/home.dart';
import '../../select_contacts/controller/contacts_controller.dart';
import '../controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? image;
  bool processing = false;
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    image = await Utils.pickImageFromGallery();

    setState(() {});
  }

  void removeSelectedImage() {
    image = null;

    setState(() {});
  }

  Future<void> storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        processing = true;
      });
      await ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(name, image);

      ref.read(savedContactsOnBabbleProvider);
      await ref
          .read(selectContactControllerProvider)
          .updateSavedContactsListToServe(ref: ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: regOtpScreenPadding,
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(defaultProfilePic),
                        )
                      : CircleAvatar(
                          radius: 64, backgroundImage: FileImage(image!)),
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
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: image != null
                        ? IconButton(
                            onPressed: () {
                              removeSelectedImage();
                            },
                            icon: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ))
                        : const SizedBox.shrink(),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    await storeUserData();
                    Get.offAll(() => const Home());
                    showCustomSnackBar(
                      title: snackBarSuccessTitle,
                      message: userAccountCreationSuccessSnackBarMessage,
                      backgroundColor: snackBarSuccessBgColor,
                    );
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(babbleTitleColor)),
                  icon: processing
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                  label: const Text(
                    'Finish',
                    style: roomAppBarLeaveTextStyle,
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
