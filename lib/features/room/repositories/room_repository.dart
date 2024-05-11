import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/functions/functions.dart';
import '../../../common/repositories/common_firebase_repository.dart';
import '../../../core/strings.dart';
import '../../../models/room_model.dart';
import '../../auth/controller/auth_controller.dart';

final roomRepositoryProvider = Provider(
  (ref) => RoomRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class RoomRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  RoomRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });
  Future<List<String>> listRoomsOfUid(String uid) async {
    var userData =
        await ref.read(authControllerProvider).getAUserData(uid: uid).last;
    return userData.roomId;
  }

  Future<void> makeRoom(
      {required String name,
      required File? roomPic,
      required List<Map<String, String>> selectedContacts}) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        uids.add(selectedContacts[i]['uid']!);
      }
      var roomId = const Uuid().v1();
      List<String> membersUids = [auth.currentUser!.uid, ...uids];
      String roomPicUrl = roomPic != null
          ? await ref
              .read(commonFirebaseStorageRepositoryProvider)
              .storeFileToFirebase(
                  serverFilePath: 'room/$roomId', file: roomPic)
          : "";
      RoomModel room = RoomModel(
          name: name,
          creatorUid: auth.currentUser!.uid,
          creatorNumber: auth.currentUser!.phoneNumber!,
          hostUid: auth.currentUser!.uid,
          roomId: roomId,
          roomPic: roomPicUrl,
          speakingPhoneNumbers: [],
          membersUid: membersUids,
          isRoomClosed: false);
      await firestore
          .collection(firebaseRoomsCollection)
          .doc(roomId)
          .set(room.toMap());
      for (int i = 0; i < membersUids.length; i++) {
        var currentListOfRooms = await listRoomsOfUid(membersUids[i]);
        await firestore
            .collection(firebaseUsersCollection)
            .doc(membersUids[i])
            .update({
          'roomId': [roomId, ...currentListOfRooms]
        });
      }
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Future<void> updateRoomPhoto(
      {required File roomPic,
      required String roomId,
      required WidgetRef ref}) async {
    String newRoomPicUrl = await ref
        .read(commonFirebaseStorageRepositoryProvider)
        .storeFileToFirebase(serverFilePath: 'room/$roomId', file: roomPic);

    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'roomPic': newRoomPicUrl});
  }

  Future<void> updateRoomName(
      {required WidgetRef ref,
      required String name,
      required String roomId}) async {
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'name': name});
  }

  Future<void> deleteRoomPhoto(
      {required String roomId, required WidgetRef ref}) async {
    await ref
        .read(commonFirebaseStorageRepositoryProvider)
        .deleteFile(serverFilePath: 'room/$roomId');
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'roomPic': ''});
  }

  Future<void> makeMemberAsHost(
      {required String roomId, required String memberId}) async {
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'hostUid': memberId});
  }

  Future<void> closeRoom({required String roomId}) async {
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'isRoomClosed': true});
  }

  Future<void> addPhoneNumberAsSpeaking(
      {required String roomId, required String phoneNumber}) async {
    var roomData = await getDetailsOfRoom(roomId);
    var speakingNumbers = roomData.speakingPhoneNumbers;
    speakingNumbers.add(phoneNumber);
    speakingNumbers = speakingNumbers.toSet().toList();
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'speakingPhoneNumbers': speakingNumbers});
  }

  Future<void> removePhoneNumberAsSpeaking(
      {required String roomId, required String phoneNumber}) async {
    var roomData = await getDetailsOfRoom(roomId);
    var speakingNumbers = roomData.speakingPhoneNumbers.toSet().toList();

    speakingNumbers.remove(phoneNumber);

    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'speakingPhoneNumbers': speakingNumbers});
  }

  Future<void> openRoom({required String roomId}) async {
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'isRoomClosed': false});
  }

  Future<void> deleteRoom({required String roomId}) async {
    var roomData = await getDetailsOfRoom(roomId);
    var memberUids = roomData.membersUid;
    // remove the room id from all users
    for (String uid in memberUids) {
      var userData =
          await ref.read(authControllerProvider).getAUserData(uid: uid).last;
      var roomsOfUser = userData.roomId;
      roomsOfUser.remove(roomId);
      await firestore
          .collection(firebaseUsersCollection)
          .doc(uid)
          .update({'roomId': roomsOfUser});
    }

    await firestore.collection(firebaseRoomsCollection).doc(roomId).delete();
  }

  Future<void> removeAMember(
      {required String roomId, required String memberId}) async {
    var roomData = await getDetailsOfRoom(roomId);
    var memberUids = roomData.membersUid;
    memberUids.remove(memberId);
//removing from room's DB
    await firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .update({'membersUid': memberUids});

    ///removing from user's data
    var userData =
        await ref.read(authControllerProvider).getAUserData(uid: memberId).last;
    var usersRoomList = userData.roomId;
    usersRoomList.remove(roomId);
    await firestore
        .collection(firebaseUsersCollection)
        .doc(memberId)
        .update({'roomId': usersRoomList});
  }

  Future<void> addMembersToARoom(
      {required List<String> alreadyMemberUids,
      required List<String> newUids,
      required String roomId}) async {
    try {
      await firestore
          .collection(firebaseRoomsCollection)
          .doc(roomId)
          .update({'membersUid': alreadyMemberUids + newUids});
      // saving to new users database
      for (int i = 0; i < newUids.length; i++) {
        var userData = await ref
            .read(authControllerProvider)
            .getAUserData(uid: newUids[i])
            .last;
        var usersRoomList = userData.roomId;
        usersRoomList.add(roomId);
        await firestore
            .collection(firebaseUsersCollection)
            .doc(newUids[i])
            .update({'roomId': usersRoomList});
      }
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Stream<List<RoomModel>> getRooms() {
    return firestore
        .collection(firebaseRoomsCollection)
        .orderBy('name')
        .snapshots()
        .map((event) {
      List<RoomModel> rooms = [];
      for (var document in event.docs) {
        var room = RoomModel.fromMap(document.data());
        if (room.membersUid.contains(auth.currentUser!.uid)) {
          rooms.add(room);
        }
      }
      return rooms;
    });
  }

  Future<RoomModel> getDetailsOfRoom(String roomId) async {
    var roomDataMap =
        await firestore.collection(firebaseRoomsCollection).doc(roomId).get();
    var roomData = RoomModel.fromMap(roomDataMap.data()!);
    return roomData;
  }

  Stream<List<String>>? getSpeakersStreamOfRoom(String roomId) {
    return firestore
        .collection(firebaseRoomsCollection)
        .doc(roomId)
        .snapshots()
        .asyncMap((event) {
      var room = RoomModel.fromMap(event.data()!);
      List<String> speakers = room.speakingPhoneNumbers;
      return speakers;
    });
  }
}
