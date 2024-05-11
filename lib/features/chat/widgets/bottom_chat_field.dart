import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import '../../../../../core/colors.dart';
import '../../../common/enums/message_enum.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../common/utils/utils.dart';
import '../../../core/radii.dart';
import '../../select_contacts/repository/contacts_repository.dart';
import '../controller/chat_controller.dart';
import 'message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String receiverUserId;
  const BottomChatField({
    required this.phoneNumber,
    required this.receiverUserId,
    super.key,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  late String name;
  final _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  bool isRecorderInit = false;
  FocusNode focusNode = FocusNode();
  bool isRecording = false;
  final FlutterSoundRecord _audioRecorder = FlutterSoundRecord();

  @override
  void initState() {
    isRecording = false;
    isRecorderInit = false;
    super.initState();

    openAudio();
  }

  void openAudio() async {
    // bool result = Record.hasPermission;
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception("Mic permission not granted");
    }
    // await _soundRecorder!.openAudioSession();
    isRecorderInit = true;
  }

  void getName() async {
    name = await ref
        .watch(contactsRepositoryProvider)
        .ifSavedContactName(phoneNumberFromServerToCheck: widget.phoneNumber);
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
          _messageController.text.trim(), widget.receiverUserId);
      setState(() {
        _messageController.clear();
      });
    } else {
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        String? path = await _audioRecorder.stop();
        log(path ?? "nyeet");
        sendFileMessage(File(path!), MessageEnum.audio);
      } else {
        _audioRecorder.start();
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

  void selectDocument() async {
    List<PlatformFile>? docs = await Utils.pickDocs();
    if (docs != null) {
      for (var xfile in docs) {
        log(xfile.path!);
        var doc = File(xfile.path!);
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
    _audioRecorder.dispose();
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getName();
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? MessageReplyPreview(name: name) : const SizedBox(),
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
                    width: 100,
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
