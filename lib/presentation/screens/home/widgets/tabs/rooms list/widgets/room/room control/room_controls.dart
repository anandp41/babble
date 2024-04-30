import 'package:babble/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../../../../../../../core/textstyles.dart';
import 'room_control_delete_button.dart';
import 'room_control_member_tile.dart';

class RoomContols extends StatelessWidget {
  const RoomContols({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                          backgroundColor: MaterialStatePropertyAll(
                              roomControlCloseRoomButtonColor)),
                      onPressed: () {},
                      child: const Text(
                        "Close room",
                        style: roomAppBarLeaveTextStyle,
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/r1.jpg",
                        ),
                        radius: 75,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Jude’s Birthday room",
                        style: roomControlRoomNameTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Members",
                            style: roomControlMembersTitleTextStyle,
                          ),
                          FlutterSwitch(
                              padding: 6,
                              showOnOff: true,
                              width: 120,
                              activeColor: roomControlMuteAllBg,
                              inactiveColor: roomControlMuteAllBg,
                              activeText: 'Mute all',
                              inactiveText: 'Unmute all',
                              value: true,
                              activeToggleColor: Colors.green,
                              inactiveToggleColor: Colors.red,
                              onToggle: (value) {
                                // setState(() {
                                //   _isSwitched = value;
                                // });
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          //height: 450,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: roomControlMembersListBgColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12),
                            child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                height: 12,
                                thickness: 2,
                                color: Colors.grey,
                              ),
                              shrinkWrap: true,
                              itemCount: 15,
                              itemBuilder: (context, index) =>
                                  const RoomControlMemberTile(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const RoomControlDeleteButton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
