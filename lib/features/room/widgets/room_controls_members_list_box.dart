import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/list_tile_separator.dart';
import '../../../core/colors.dart';
import '../../../core/radii.dart';
import '../../../models/room_model.dart';
import '../../auth/controller/auth_controller.dart';
import 'room_control_member_tile.dart';

class RoomControlsMembersListBox extends ConsumerWidget {
  const RoomControlsMembersListBox({
    super.key,
    required this.newRoomData,
  });

  final RoomModel? newRoomData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: roomControlMembersListBgColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: ListView.separated(
            separatorBuilder: (context, index) => const ListTileSeparator(),
            shrinkWrap: true,
            itemCount: newRoomData!.membersUid.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: ref
                      .read(authControllerProvider)
                      .getAUserData(uid: newRoomData!.membersUid[index])
                      .last,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        height: 2 * chatListImageRadii,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: babbleTitleColor,
                        )),
                      );
                    }
                    var userData = snapshot.data;
                    return RoomControlMemberTile(
                        roomData: newRoomData!, userData: userData!);
                  });
            },
          ),
        ),
      ),
    );
  }
}
