import 'package:babble/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:babble/features/room/controller/room_controller.dart';

import '../../../core/colors.dart';
import '../../../core/textstyles.dart';

class ProfilePicViewer extends ConsumerStatefulWidget {
  final String imageUrl;
  final String name;
  final bool isRoom;
  final String? roomId;
  final bool own;
  const ProfilePicViewer(
      {super.key,
      required this.imageUrl,
      required this.name,
      this.isRoom = false,
      this.roomId,
      this.own = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfilePicViewerState();
}

class _ProfilePicViewerState extends ConsumerState<ProfilePicViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: appbarBackButtonColor,
            )),
        backgroundColor: Colors.transparent,
        title: Text(
          widget.name,
          style: const TextStyle(color: profilePicViewerTitleColor),
        ),
        actions: [
          if (widget.isRoom || (widget.own && widget.imageUrl != ''))
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context1) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: Text(
                          'Do you want to remove ${widget.isRoom ? "the room" : widget.own ? "your profile" : null} photo ?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            widget.isRoom
                                ? await ref
                                    .read(roomControllerProvider)
                                    .deleteRoomPhoto(
                                        ref: ref, roomId: widget.roomId!)
                                : widget.own
                                    ? await ref
                                        .read(authControllerProvider)
                                        .deleteUserProfilePic(ref: ref)
                                    : null;

                            widget.isRoom
                                ? ref.refresh(roomControllerProvider)
                                : widget.own
                                    ? ref.refresh(userDataAuthProvider)
                                    : null;
                            Get.back();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Yes",
                            style: settingsRedButtonTS,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "No",
                            style: settingsButtonTS,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              color: kWhite,
            )
        ],
      ),
      backgroundColor: profilePicViewerBg,
      body: Center(
        child: widget.imageUrl == ''
            ? Text(
                widget.isRoom ? "No room photo" : "No profile photo",
                style: const TextStyle(color: profilePicViewerNoImageColor),
              )
            : FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.imageUrl,
              ),
      ),
    );
  }
}
