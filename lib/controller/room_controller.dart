import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:babble/repositories/room_repository.dart';

import '../models/room_model.dart';

final roomControllerProvider = Provider((ref) {
  final roomRepository = ref.read(roomRepositoryProvider);
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

  Stream<List<RoomModel>> getRooms() {
    return roomRepository.getRooms();
  }
}
