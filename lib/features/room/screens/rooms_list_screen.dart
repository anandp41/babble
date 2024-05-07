import 'package:babble/features/room/controller/room_controller.dart';
import 'package:babble/core/radii.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/colors.dart';
import '../../../common/widgets/custom_search_bar.dart';
import '../../../common/widgets/error_screen.dart';
import '../../auth/controller/auth_controller.dart';
import '../widgets/rooms_list_tile.dart';

class RoomsListScreen extends ConsumerStatefulWidget {
  const RoomsListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RoomsListScreenState();
}

class _RoomsListScreenState extends ConsumerState<RoomsListScreen> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSearchBar(
          label: "Search rooms",
          onChanged: (value) {
            setState(() {
              name = value;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ref.watch(userDataAuthProvider).when(
              data: (userData) => userData!.roomId.isEmpty
                  ? const ErrorScreen(error: "You are'nt in any room")
                  : ListView.builder(
                      itemCount: userData.roomId.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: ref
                              .watch(roomControllerProvider)
                              .getDetailsOfRoom(userData.roomId[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              var roomData = snapshot.data;
                              if (roomData!.name
                                  .toUpperCase()
                                  .contains(name.trim().toUpperCase())) {
                                return RoomsListTile(
                                  roomData: roomData,
                                  userData: userData,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      },
                    ),
              error: (error, stackTrace) => const ErrorScreen(
                    error: "Error fetching user data",
                  ),
              loading: () => const CircularProgressIndicator(
                    color: babbleTitleColor,
                  )),
        ),
        const SizedBox(
          height: 3 * chatListImageRadii,
        )
      ],
    );
  }
}
