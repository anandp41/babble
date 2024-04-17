import 'package:babble/core/radii.dart';
import 'package:babble/presentation/screens/home/tabs/rooms%20list/rooms_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../common/list_tile_separator.dart';
import 'rooms_search_bar.dart';

class RoomsListScreen extends StatelessWidget {
  const RoomsListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomRoomsSearchBar(),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const ListTileSeparator(),
            shrinkWrap: true,
            itemCount: 12,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => const RoomsListTile(),
          ),
        ),
        const SizedBox(
          height: 3 * chatListImageRadii,
        )
      ],
    );
  }
}
