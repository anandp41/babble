import 'package:babble/controller/auth_controller.dart';
import 'package:babble/controller/room_controller.dart';
import 'package:babble/core/radii.dart';
import 'package:babble/models/room_model.dart';
import 'package:babble/presentation/screens/home/widgets/tabs/rooms%20list/widgets/rooms_list_tile.dart';
import 'package:babble/presentation/screens/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/colors.dart';
import '../../../../../../common/list_tile_separator.dart';
import '../../../../../common/custom_search_bar.dart';
import '../../../../../widgets/loader.dart';

// class RoomsListScreen extends ConsumerWidget {
//   const RoomsListScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Column(
//       children: [
//         CustomSearchBar(
//           label: "Search rooms",
//           onChanged: (value) {},
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         // Expanded(
//         //   child: ListView.separated(
//         //     separatorBuilder: (context, index) => const ListTileSeparator(),
//         //     shrinkWrap: true,
//         //     itemCount: 12,
//         //     scrollDirection: Axis.vertical,
//         //     itemBuilder: (context, index) => const RoomsListTile(),
//         //   ),
//         // ),

//         Expanded(
//           child: StreamBuilder<List<RoomModel>>(
//               stream: ref.watch(roomControllerProvider).getRooms(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Loader();
//                 }

//                 return ListView.separated(
//                   itemCount: snapshot.data!.length,
//                   separatorBuilder: (context, index) =>
//                       const ListTileSeparator(),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) {
//                     var roomData = snapshot.data![index];

//                     return RoomsListTile(
//                       roomData: roomData,
//                     );
//                   },
//                 );
//               }),
//         ),
//         const SizedBox(
//           height: 3 * chatListImageRadii,
//         )
//       ],
//     );
//   }
// }

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
    // var userData = ref.read(userDataAuthProvider);
    return Column(
      children: [
        CustomSearchBar(
          label: "Search rooms",
          onChanged: (value) {
            name = value;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        // Expanded(
        //   child: ListView.separated(
        //     separatorBuilder: (context, index) => const ListTileSeparator(),
        //     shrinkWrap: true,
        //     itemCount: 12,
        //     scrollDirection: Axis.vertical,
        //     itemBuilder: (context, index) => const RoomsListTile(),
        //   ),
        // ),
        ref.watch(userDataAuthProvider).when(
            data: (userData) => Expanded(
                  child: StreamBuilder<List<RoomModel>>(
                      stream: ref.watch(roomControllerProvider).getRooms(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loader();
                        }

                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) =>
                              const ListTileSeparator(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var roomData = snapshot.data![index];

                            return RoomsListTile(
                              roomData: roomData,
                              userData: userData,
                            );
                          },
                        );
                      }),
                ),
            error: (error, stackTrace) => const ErrorScreen(
                  error: "Error fetching user data",
                ),
            loading: () =>
                // const Loader()
                const CircularProgressIndicator(
                  color: babbleTitleColor,
                )),
        const SizedBox(
          height: 3 * chatListImageRadii,
        )
      ],
    );
  }
}
