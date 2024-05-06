import 'dart:io';

import 'package:babble/common/enums/message_enum.dart';
import 'package:babble/common/providers/message_reply_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../../../../../models/chat_contact.dart';
import '../../../../../models/message.dart';
import '../repositories/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });
  Future<bool> doesThisUserExistNow({required String uid}) async {
    return await chatRepository.doesThisUserExistNow(uid: uid);
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Future<String> getProfilePicOfAUser({required String userId}) async {
    return chatRepository.getProfilePic(userId: userId);
  }

  void sendTextMessage(String text, String receiverUserId) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage({
    required File file,
    required String receiverUserId,
    required MessageEnum messageEnum,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendFileMessage(
            file: file,
            receiverUserId: receiverUserId,
            senderUserData: value!,
            ref: ref,
            messageEnum: messageEnum,
            messageReply: messageReply));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIFMessage(
      {required BuildContext context,
      required String gifUrl,
      required String receiverUserId}) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGIFMessage(
            gifUrl: newGifUrl,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void setChatMessageSeen(
      {required String receiverUserId, required String messageId}) {
    chatRepository.setChatMessageSeen(
        receiverUserId: receiverUserId, messageId: messageId);
  }
}
