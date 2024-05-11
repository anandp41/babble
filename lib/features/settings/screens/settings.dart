import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/error_screen.dart';
import '../../../common/widgets/list_tile_separator.dart';
import '../../../common/widgets/loader.dart';
import '../../../core/colors.dart';
import '../../../core/strings.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/controller/privacy_policy_terms_and_conditions_controller.dart';
import '../../chat/widgets/profile_pic_viewer.dart';
import '../widgets/about_babble_button.dart';
import '../widgets/delete_account_button.dart';
import '../widgets/log_out_button.dart';
import '../widgets/privacy_policy_button.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/settings_photo_name.dart';
import '../widgets/t_and_c_button.dart';

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
    ref.read(privacyPolicyTermsAndConditionsControllerProvider);
    var screenSize = MediaQuery.of(context).size;
    return ref.watch(userDataAuthProvider).when(
          data: (userData) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(70), child: SettingsAppBar()),
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
                            InkWell(
                              onTap: () => Get.to(
                                  () => ProfilePicViewer(
                                        imageUrl: userData.profilePic,
                                        name: userData.name,
                                        own: true,
                                      ),
                                  transition: Transition.fadeIn),
                              child: userData!.profilePic == ''
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
                            ),
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
                        SettingsNamePanel(
                          ref: ref,
                          userData: userData,
                        ),
                      ],
                    ),
                    const ListTileSeparator(),
                    PrivacyPolicyButton(ref: ref, screenSize: screenSize),
                    const ListTileSeparator(),
                    TandCButton(ref: ref, screenSize: screenSize),
                    const ListTileSeparator(),
                    kIsWeb
                        ? LogOutButton(ref: ref)
                        : DeleteAccountButton(ref: ref),
                    const ListTileSeparator(),
                    const AboutBabbleButton(),
                  ],
                ),
              )),
            );
          },
          error: (error, stackTrace) => ErrorScreen(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
