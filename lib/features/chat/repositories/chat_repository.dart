import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/strings.dart';
import '../../../../../models/user_model.dart';
import '../../../common/enums/message_enum.dart';
import '../../../common/functions/functions.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../common/repositories/common_firebase_repository.dart';
import '../../../core/misc.dart';
import '../../../models/chat_contact.dart';
import '../../../models/message.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore, required this.auth});

  Future<bool> doesThisUserExistNow({required String uid}) async {
    var data =
        await firestore.collection(firebaseUsersCollection).doc(uid).get();
    if (data.exists) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser!.uid)
        .collection(firebaseChatsCollection)
        .orderBy('timeSent', descending: false)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection(firebaseUsersCollection)
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            phoneNumber: user.phoneNumber,
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
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser!.uid)
        .collection(firebaseChatsCollection)
        .doc(receiverUserId)
        .collection(firebaseMessagesCollection)
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

  Future<String> getProfilePic({required String userId}) async {
    var userDataMap =
        await firestore.collection(firebaseUsersCollection).doc(userId).get();
    var receiverUserData = UserModel.fromMap(userDataMap.data()!);
    return receiverUserData.profilePic;
  }

  void _saveDataToContactsSubCollection(
      {required UserModel senderUserData,
      required UserModel receiverUserData,
      required String text,
      required DateTime timeSent,
      required String receiverUserId}) async {
    var receiverChatContact = ChatContact(
        name: senderUserData.name,
        phoneNumber: senderUserData.phoneNumber,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection(firebaseUsersCollection)
        .doc(receiverUserId)
        .collection(firebaseChatsCollection)
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());
    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        phoneNumber: receiverChatContact.phoneNumber,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: timeSent,
        lastMessage: text);
    await firestore
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser!.uid)
        .collection(firebaseChatsCollection)
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
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser!.uid)
        .collection(firebaseChatsCollection)
        .doc(receiverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection(firebaseUsersCollection)
        .doc(receiverUserId)
        .collection(firebaseChatsCollection)
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
      var userDataMap = await firestore
          .collection(firebaseUsersCollection)
          .doc(receiverUserId)
          .get();
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
              serverFilePath:
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
      var userDataMap = await firestore
          .collection(firebaseUsersCollection)
          .doc(receiverUserId)
          .get();
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
          .collection(firebaseUsersCollection)
          .doc(auth.currentUser!.uid)
          .collection(firebaseChatsCollection)
          .doc(receiverUserId)
          .collection(firebaseMessagesCollection)
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection(firebaseUsersCollection)
          .doc(receiverUserId)
          .collection(firebaseChatsCollection)
          .doc(auth.currentUser!.uid)
          .collection(firebaseMessagesCollection)
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }
}
