import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/textstyles.dart';

class RoomAppBar extends StatelessWidget {
  const RoomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            "assets/images/arrow1.svg",
            height: 50,
            width: 60,
          )),
      centerTitle: true,
      title: Row(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.065,
            backgroundImage: const AssetImage("assets/images/r1.jpg"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "St.Xavier's School",
              style: roomsListTileNameTextStyle,
            ),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
              onPressed: () {},
              style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(84, 36)),
                  backgroundColor: MaterialStatePropertyAll(Color(0xFFBA3B3B))),
              child: const Text(
                "Leave",
                style: roomAppBarLeaveTextStyle,
              )),
        )
      ],
    );
  }
}
