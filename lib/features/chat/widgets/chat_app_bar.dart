import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/colors.dart';
import '../../../../../core/radii.dart';
import '../../../../../core/strings.dart';
import '../../../../../core/textstyles.dart';
import '../../../common/widgets/appbar_back_button.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../select_contacts/repository/contacts_repository.dart';
import 'profile_pic_viewer.dart';

class ChatAppBar extends ConsumerWidget {
  final String uid;
  final String phoneNumber;
  final String profilePic;
  final String name;
  const ChatAppBar({
    super.key,
    required this.uid,
    required this.phoneNumber,
    required this.profilePic,
    required this.name,
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
              InkWell(
                onTap: () => ProfilePicViewer(
                  imageUrl: profilePic,
                  name: name,
                  isRoom: false,
                  roomId: null,
                ),
                child: profilePic != ''
                    ? CircleAvatar(
                        radius: chatScreenPicRadii,
                        backgroundImage: NetworkImage(profilePic),
                      )
                    : const CircleAvatar(
                        radius: chatScreenPicRadii,
                        backgroundImage: AssetImage(defaultProfilePic),
                      ),
              ),
              StreamBuilder<UserModel>(
                  stream: ref
                      .watch(authControllerProvider)
                      .getAUserDataAsStream(uid: uid),
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
                              backgroundColor: appBarOnlineDotCircleColor,
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
