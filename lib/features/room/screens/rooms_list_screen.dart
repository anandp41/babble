import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/colors.dart';
import '../../../common/widgets/custom_search_bar.dart';
import '../../../common/widgets/error_screen.dart';
import '../../../core/radii.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/room_controller.dart';
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
              data: (userData) => StreamBuilder<List<String>>(
                  stream:
                      ref.watch(roomControllerProvider).getRoomsOfThisUSer(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: babbleTitleColor,
                          ),
                        ],
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return const ErrorScreen(
                          error: "You are'nt in any rooms");
                    }
                    List<String> rooms = snapshot.data!;
                    return ListView.builder(
                      itemCount: rooms.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: ref
                              .watch(roomControllerProvider)
                              .getDetailsThisRoomStream(roomId: rooms[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: babbleTitleColor,
                                  ),
                                ],
                              );
                            }

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
                          },
                        );
                      },
                    );
                  }),
              error: (error, stackTrace) => const ErrorScreen(
                    error: "Error fetching user data",
                  ),
              loading: () => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: babbleTitleColor,
                      ),
                    ],
                  )),
        ),
        const SizedBox(
          height: 3 * chatListImageRadii,
        )
      ],
    );
  }
}
