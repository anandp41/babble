import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../core/textstyles.dart';

class RoomControlMemberTile extends StatelessWidget {
  const RoomControlMemberTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundImage: AssetImage("assets/images/r2.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                "Alice",
                style: roomsListTileNameTextStyle,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                  color: roomControlInactiveMuteBg, shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mic_none_outlined),
                iconSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  shape: BoxShape.rectangle,
                  color: roomControlExitIconBg),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 30,
                    color: Colors.black,
                  )),
            ),
          ],
        )
      ],
    );
  }
}
