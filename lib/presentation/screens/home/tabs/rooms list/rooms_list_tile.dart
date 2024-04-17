import 'package:babble/presentation/screens/room/room.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/radii.dart';
import '../../../../../core/textstyles.dart';

class RoomsListTile extends StatelessWidget {
  const RoomsListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => const Room()
          //const ZegoCloudAudioRoom(roomID: 'demo_call_for_test')

          ),
      child: Container(
        height: 2 * chatListImageRadii,
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage(
                'assets/images/r1.jpg',
              ),
              radius: chatListImageRadii,
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint(exception.toString());
              },
            ),
            const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "St.Xavier's School",
                                maxLines: 1,
                                style: roomsListTileNameTextStyle,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.mic,
                                    size: 20,
                                    color: Colors.green,
                                  ),
                                  Icon(
                                    Icons.group,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    "Abhi",
                                    maxLines: 1,
                                    style: roomsListTileSpeakingTitleTextStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
