import 'dart:developer';
import 'dart:io';

import 'package:babble/common/enums/message_enum.dart';
import 'package:babble/common/providers/message_reply_provider.dart';
import 'package:babble/controller/chat_controller.dart';
import 'package:babble/core/radii.dart';
import 'package:babble/presentation/screens/home/tabs/chats%20list/chat_screen/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../core/colors.dart';
import '../../../../../../../utils/utils.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String name;
  final String receiverUserId;
  const BottomChatField({
    required this.name,
    required this.receiverUserId,
    super.key,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  FocusNode focusNode = FocusNode();
  bool isRecording = false;
  FlutterSoundRecorder? _soundRecorder;
  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic permission not granted");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          _messageController.text.trim(), widget.receiverUserId);
      setState(() {
        _messageController.clear();
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      String path = "${tempDir.path}/audio_temp.aac";
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void selectMultipleMedia() async {
    List<XFile> media = await Utils.pickMultipleMedia();
    if (media.isNotEmpty) {
      for (var item in media) {
        if (lookupMimeType(item.path)!.startsWith('image/')) {
          var image = File(item.path);
          sendFileMessage(image, MessageEnum.image);
        } else if (lookupMimeType(item.path)!.startsWith('video/')) {
          var video = File(item.path);
          sendFileMessage(video, MessageEnum.video);
        }
      }
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
        file: file,
        receiverUserId: widget.receiverUserId,
        messageEnum: messageEnum);
  }

  // void selectImage() async {
  //   File? image = await Utils.pickImageFromGallery();
  //   if (image != null) {
  //     sendFileMessage(image, MessageEnum.image);
  //   }
  // }

  void selectDocument() async {
    List<XFile>? docs = await Utils.pickDocs();
    if (docs != null) {
      for (var xfile in docs) {
        log(xfile.path);
        var doc = File(xfile.path);
        sendFileMessage(doc, MessageEnum.doc);
      }
    }
  }

  void selectGIF() async {
    final gif = await Utils.pickGIF(context: context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          // ignore: use_build_context_synchronously
          .sendGIFMessage(
              // ignore: use_build_context_synchronously
              context: context,
              gifUrl: gif.url,
              receiverUserId: widget.receiverUserId);
      gif.url;
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      hideEmojiContainer();
      showKeyboard();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply
            ? MessageReplyPreview(name: widget.name)
            : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextField(
                onTap: () {
                  if (isShowEmojiContainer) {
                    toggleEmojiKeyboardContainer();
                  }
                },
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: chatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              toggleEmojiKeyboardContainer();
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              selectGIF();
                            },
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 150,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            selectMultipleMedia();
                          },
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        // IconButton(
                        //   onPressed: () {
                        //     selectVideo();
                        //   },
                        //   icon: const Icon(
                        //     Icons.video_camera_back,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                        IconButton(
                          onPressed: () {
                            selectDocument();
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                backgroundColor: babbleTitleColor,
                radius: chatListImageRadii,
                child: GestureDetector(
                  onTap: () {
                    sendTextMessage();
                  },
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
