import 'dart:io';
import 'package:babble/common/enums/message_enum.dart';
import 'package:babble/common/providers/message_reply_provider.dart';
import 'package:babble/core/misc.dart';
import 'package:babble/models/chat_contact.dart';
import 'package:babble/models/message.dart';
import 'package:babble/repositories/common_firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore, required this.auth});
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: user.uid,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats ')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubCollection(
      {required UserModel senderUserData,
      required UserModel receiverUserData,
      required String text,
      required DateTime timeSent,
      required String receiverUserId}) async {
    var receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());
    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUsername,
    required String receiverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderUsername
              : receiverUserName,
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats ')
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(receiverUserId)
        .collection('chats ')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
          senderUserData: senderUser,
          receiverUserData: receiverUserData,
          text: text,
          timeSent: timeSent,
          receiverUserId: receiverUserId);
      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: text,
          messageId: messageId,
          messageType: MessageEnum.text,
          timeSent: timeSent,
          receiverUserName: receiverUserData.name,
          username: senderUser.name,
          senderUsername: senderUser.name,
          messageReply: messageReply);
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
  }

  void sendFileMessage({
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              ref:
                  'chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId',
              file: file);
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📽️ Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        case MessageEnum.doc:
          contactMsg = '📄 PDF';
          break;
        default:
          contactMsg = '';
      }

      _saveDataToContactsSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: contactMsg,
          timeSent: timeSent,
          receiverUserId: receiverUserId);
      _saveMessageToMessageSubCollection(
        receiverUserId: receiverUserId,
        text: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        receiverUserName: receiverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUsername: senderUserData.name,
      );
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
  }

  void sendGIFMessage({
    required String gifUrl,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
          senderUserData: senderUser,
          receiverUserData: receiverUserData,
          text: 'GIF',
          timeSent: timeSent,
          receiverUserId: receiverUserId);
      _saveMessageToMessageSubCollection(
          receiverUserId: receiverUserId,
          text: gifUrl,
          messageId: messageId,
          messageType: MessageEnum.gif,
          timeSent: timeSent,
          receiverUserName: receiverUserData.name,
          username: senderUser.name,
          messageReply: messageReply,
          senderUsername: senderUser.name);
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
  }

  void setChatMessageSeen({
    required String receiverUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats ')
          .doc(receiverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(receiverUserId)
          .collection('chats ')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
  }
}
