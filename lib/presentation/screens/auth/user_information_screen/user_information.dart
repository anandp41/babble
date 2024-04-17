import 'dart:io';
import 'package:babble/controller/auth_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/misc.dart';
import '../../../../core/textstyles.dart';
import '../../../../utils/utils.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> selectImage() async {
    image = await Utils.pickImageFromGallery();

    setState(() {});
  }

  Future<void> storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      await ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(name, image);
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
                          backgroundImage: AssetImage("assets/images/def.png"),
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
                        icon: const Icon(Icons.add_a_photo)),
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
                      decoration:
                          const InputDecoration(hintText: "Enter your name"),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    await storeUserData();
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(babbleTitleColor)),
                  icon: const Icon(
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
