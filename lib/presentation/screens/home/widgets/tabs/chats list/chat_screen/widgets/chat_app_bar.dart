import 'package:babble/repositories/contacts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:babble/controller/auth_controller.dart';
import 'package:babble/models/user_model.dart';

import '../../../../../../../../core/colors.dart';
import '../../../../../../../../core/radii.dart';
import '../../../../../../../../core/strings.dart';
import '../../../../../../../../core/textstyles.dart';
import '../../../../../../common/appbar_back_button.dart';

class ChatAppBar extends ConsumerWidget {
  final String uid;
  final String phoneNumber;
  final String profilePic;
  const ChatAppBar({
    super.key,
    required this.uid,
    required this.phoneNumber,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: true,
      leading: const AppBarBackButton(),
      backgroundColor: chatAppBarBg,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              profilePic != ''
                  ? CircleAvatar(
                      radius: chatScreenPicRadii,
                      backgroundImage: NetworkImage(profilePic),
                    )
                  : const CircleAvatar(
                      radius: chatScreenPicRadii,
                      backgroundImage: AssetImage(defaultProfilePic),
                    ),
              StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    return snapshot.data!.isOnline
                        ? const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 6,
                              backgroundColor: Color.fromARGB(255, 11, 223, 18),
                            ))
                        : const SizedBox();
                  })
            ],
          ),
          const SizedBox(width: 14),
          FutureBuilder(
            initialData: phoneNumber,
            future: ref
                .watch(contactsRepositoryProvider)
                .ifSavedContactName(phoneNumberFromServerToCheck: phoneNumber),
            builder: (context, snapshot) => Expanded(
              child: Text(
                snapshot.data!,
                style: chatAppBarTextStyle,
              ),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }
}
