import 'package:babble/features/room/controller/room_controller.dart';
import 'package:babble/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/textstyles.dart';
import 'select_contacts_room.dart';

class AddMemberToRoomScreen extends ConsumerStatefulWidget {
  final List<String> alreadyMembers;
  final String roomId;
  const AddMemberToRoomScreen(
      {super.key, required this.alreadyMembers, required this.roomId});

  @override
  ConsumerState<AddMemberToRoomScreen> createState() =>
      _AddMemberToRoomScreenState();
}

class _AddMemberToRoomScreenState extends ConsumerState<AddMemberToRoomScreen> {
  List<String> selectedContactsUid = [];

  Future<void> addMembers() async {
    await ref.read(roomControllerProvider).addMembersToARoom(
        roomId: widget.roomId,
        alreadyMemberUids: widget.alreadyMembers,
        newUids: ref.read(newMembersUids));
    Get.back();
    ref.read(selectedRoomContacts.state).update((state) => []);
    ref.refresh(roomControllerProvider);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    size: 32,
                    color: babbleTitleColor,
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Select contacts",
                  style: selectContactsTitleTS,
                ),
              ),
              Expanded(
                child: SelectContactsRoom(
                  alreadyMembers: widget.alreadyMembers,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await addMembers(),
        backgroundColor: babbleTitleColor,
        child: const Icon(
          Icons.done_all,
          color: Colors.white,
        ),
      ),
    );
  }
}
