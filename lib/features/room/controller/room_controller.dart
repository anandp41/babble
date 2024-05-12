import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/room_model.dart';
import '../repositories/room_repository.dart';

final roomControllerProvider = Provider((ref) {
  final roomRepository = ref.watch(roomRepositoryProvider);
  return RoomController(roomRepository: roomRepository, ref: ref);
});

class RoomController {
  final RoomRepository roomRepository;
  final ProviderRef ref;
  RoomController({
    required this.roomRepository,
    required this.ref,
  });
  Future<void> makeRoom(String name, File? roomPic,
      List<Map<String, String>> selectedContacts) async {
    await roomRepository.makeRoom(
        name: name, roomPic: roomPic, selectedContacts: selectedContacts);
  }

  Future<void> addMembersToARoom(
      {required List<String> alreadyMemberUids,
      required List<String> newUids,
      required String roomId}) async {
    await roomRepository.addMembersToARoom(
        alreadyMemberUids: alreadyMemberUids, newUids: newUids, roomId: roomId);
  }

  Stream<List<RoomModel>> getRooms() {
    return roomRepository.getRooms();
  }

  Stream<List<String>> getRoomsOfThisUSer() =>
      roomRepository.getRoomsOfThisUSer();
  Stream<RoomModel> getDetailsThisRoomStream({required String roomId}) =>
      roomRepository.getDetailsOfThisRoomStream(roomId);
  Future<void> removeAMember(
          {required String roomId, required String memberId}) async =>
      await roomRepository.removeAMember(roomId: roomId, memberId: memberId);

  Future<RoomModel> getDetailsOfRoom(String roomId) async =>
      await roomRepository.getDetailsOfRoom(roomId);

  Future<void> makeMemberAsHost(
          {required String roomId, required String memberId}) async =>
      await roomRepository.makeMemberAsHost(roomId: roomId, memberId: memberId);

  Future<void> deleteRoom({required String roomId}) async =>
      await roomRepository.deleteRoom(roomId: roomId);

  Future<void> closeRoom({required String roomId}) async =>
      await roomRepository.closeRoom(roomId: roomId);
  Future<void> openRoom({required String roomId}) async =>
      await roomRepository.openRoom(roomId: roomId);
  Future<void> removePhoneNumberAsSpeaking(
          {required String roomId, required String phoneNumber}) async =>
      await roomRepository.removePhoneNumberAsSpeaking(
          roomId: roomId, phoneNumber: phoneNumber);
  Future<void> addPhoneNumberAsSpeaking(
          {required String roomId, required String phoneNumber}) async =>
      await roomRepository.addPhoneNumberAsSpeaking(
          roomId: roomId, phoneNumber: phoneNumber);

  Future<void> updateRoomPhoto(
      {required File roomPic,
      required String roomId,
      required WidgetRef ref}) async {
    await roomRepository.updateRoomPhoto(
        roomPic: roomPic, roomId: roomId, ref: ref);
  }

  Future<void> deleteRoomPhoto(
          {required WidgetRef ref, required String roomId}) async =>
      await roomRepository.deleteRoomPhoto(roomId: roomId, ref: ref);

  Stream<List<String>>? getSpeakersStreamOfRoom({required String roomId}) {
    return roomRepository.getSpeakersStreamOfRoom(roomId);
  }

  Future<void> updateRoomName(
      {required WidgetRef ref,
      required String name,
      required String roomId}) async {
    await roomRepository.updateRoomName(
      name: name,
      ref: ref,
      roomId: roomId,
    );
  }
}
