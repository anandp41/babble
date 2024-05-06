import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:babble/features/chat/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:babble/common/enums/message_enum.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../core/misc.dart';
import '../../../../../core/textstyles.dart';
import '../../../common/widgets/doc_viewer.dart';
import 'video_player_item.dart';

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
                audioplayer
                  ..setSourceUrl(message)
                  ..setPlayerMode(PlayerMode.mediaPlayer)
                  ..setReleaseMode(ReleaseMode.stop);

                return SizedBox(
                    width: 160,
                    height: 120,
                    child: PlayerWidget(
                      player: audioplayer,
                      isMyMessage: isMyMessage,
                    ));
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
                                  // log(message);
                                  _openAndroidExternalFile(path: message);
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
