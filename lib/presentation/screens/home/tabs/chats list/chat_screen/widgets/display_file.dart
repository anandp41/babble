import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:babble/presentation/screens/home/tabs/chats%20list/chat_screen/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

import 'package:babble/common/enums/message_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../../core/misc.dart';
import '../../../../../../../core/textstyles.dart';
import '../../../../../widgets/doc_viewer.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  final bool isMyMessage;
  const DisplayTextImageGIF({
    super.key,
    required this.isMyMessage,
    required this.message,
    required this.type,
  });
  void _openAndroidExternalFile({required String path}) async {
    //open an external storage file
    if (await Permission.manageExternalStorage.request().isGranted) {
      final result = await OpenFilex.open(path);
      log(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final audioplayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(
            message,
            style: isMyMessage
                ? myMessageCardTextStyle
                : senderMessageCardTextStyle,
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: const BoxConstraints(minWidth: 100),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioplayer.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        setState(() {
                          isPlaying = true;
                        });
                        await audioplayer.play(UrlSource(message),
                            mode: PlayerMode.lowLatency);
                      }
                    },
                    icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle));
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
                    ? Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(messageBorderRadius))),
                        child: CachedNetworkImage(imageUrl: message),
                      )
                    : type == MessageEnum.image
                        ? Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(messageBorderRadius))),
                            child: CachedNetworkImage(imageUrl: message),
                          )
                        : Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(messageBorderRadius))),
                            child: InkWell(
                                onTap: () {
                                  log(message);
                                  //_openAndroidExternalFile(path: message);
                                  Get.to(() => DocViewer(path: message));
                                },
                                child: Text(
                                  "📄  PDF",
                                  style: isMyMessage
                                      ? myMessageCardTextStyle
                                      : senderMessageCardTextStyle,
                                )),
                          );
  }
}
