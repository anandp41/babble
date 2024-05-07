import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../core/textstyles.dart';
import '../../select_contacts/repository/contacts_repository.dart';

class RoomOccupantNameTile extends ConsumerWidget {
  final ZegoUIKitUser user;
  const RoomOccupantNameTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(contactsRepositoryProvider)
          .ifSavedContactName(phoneNumberFromServerToCheck: user.name),
      initialData: user.name,
      builder: (context, snapshot) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              user.name == snapshot.data!
                  ? snapshot.data!
                  : "${snapshot.data!}-${user.name}",
              softWrap: true,
              maxLines: 1,
              textWidthBasis: TextWidthBasis.parent,
              overflow: TextOverflow.ellipsis,
              style: roomListTileNameTextStyle,
            ),
          ),
        );
      },
    );
  }
}
