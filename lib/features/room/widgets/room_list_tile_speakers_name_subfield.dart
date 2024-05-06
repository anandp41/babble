import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/textstyles.dart';
import '../../../models/room_model.dart';
import '../../../models/user_model.dart';
import '../../select_contacts/repository/contacts_repository.dart';

class RoomListTileSpeakersNameSubField extends ConsumerWidget {
  const RoomListTileSpeakersNameSubField({
    super.key,
    required this.roomData,
    required this.userData,
  });

  final RoomModel roomData;
  final UserModel? userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var speakingPhoneNumbers = {
      ...roomData.speakingPhoneNumbers.toSet().toList()
        ..remove(userData!.phoneNumber)
    };
    return Expanded(
        flex: 1,
        child: speakingPhoneNumbers.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(
                    Icons.mic,
                    size: 20,
                    color: Color.fromARGB(255, 5, 155, 10),
                  ),
                  FutureBuilder(
                    initialData: speakingPhoneNumbers.join(', '),
                    future: Future(() async {
                      List<String> names = [];
                      for (var number in speakingPhoneNumbers) {
                        String name = await ref
                            .read(contactsRepositoryProvider)
                            .ifSavedContactName(
                                phoneNumberFromServerToCheck: number);
                        names.add(name.split(' ').first);
                      }
                      return names.join(', ');
                    }),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data!,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: roomsListTileSpeakingTitleTextStyle,
                      );
                    },
                  )
                ],
              )
            : const SizedBox.shrink());
  }
}
