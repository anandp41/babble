import 'package:flutter/material.dart';

import '../../../../../../../../../core/textstyles.dart';

class RoomMemberTile extends StatelessWidget {
  const RoomMemberTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/r2.png")),
              borderRadius: BorderRadius.circular(15)),
        ),
        const SizedBox(
          height: 6,
        ),
        const Text(
          "Ron",
          style: roomMemberNameTextStyle,
        )
      ],
    );
  }
}
