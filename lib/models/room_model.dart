class RoomModel {
  final String name;
  final String creatorUid;
  final String creatorNumber;
  final String hostUid;
  final String roomId;
  final String roomPic;
  final List<String> speakingPhoneNumbers;
  final List<String> membersUid;
  final bool isRoomClosed;
  RoomModel(
      {required this.name,
      required this.creatorUid,
      required this.creatorNumber,
      required this.hostUid,
      required this.roomId,
      required this.roomPic,
      required this.speakingPhoneNumbers,
      required this.membersUid,
      required this.isRoomClosed});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creatorUid': creatorUid,
      'creatorNumber': creatorNumber,
      'hostUid': hostUid,
      'roomId': roomId,
      'roomPic': roomPic,
      'speakingPhoneNumbers': speakingPhoneNumbers,
      'membersUid': membersUid,
      'isRoomClosed': isRoomClosed,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      name: map['name'] ?? '',
      creatorUid: map['creatorUid'] ?? '',
      creatorNumber: map['creatorNumber'] ?? '',
      hostUid: map['hostUid'] ?? '',
      roomId: map['roomId'] ?? '',
      roomPic: map['roomPic'] ?? '',
      speakingPhoneNumbers: List<String>.from(map['speakingPhoneNumbers']),
      membersUid: List<String>.from(map['membersUid']),
      isRoomClosed: map['isRoomClosed'] ?? false,
    );
  }
}
