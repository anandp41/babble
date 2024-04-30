import 'dart:io';

import 'package:babble/core/misc.dart';
import 'package:babble/models/room_model.dart';
import 'package:babble/repositories/common_firebase_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

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
        membersUid: [auth.currentUser!.uid, ...uids],
      );
      await firestore.collection('rooms').doc(roomId).set(room.toMap());
    } catch (e) {
      Get.showSnackbar(
          GetSnackBar(duration: snackbarDuration, message: e.toString()));
    }
  }

  Stream<List<RoomModel>> getRooms() {
    return firestore
        .collection('rooms')
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
}
