class RoomListTileModel {
  final String roomId;
  final List<String> phoneNumbers;
  RoomListTileModel({
    required this.roomId,
    required this.phoneNumbers,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'phoneNumbers': phoneNumbers,
    };
  }

  factory RoomListTileModel.fromMap(Map<String, dynamic> map) {
    return RoomListTileModel(
      roomId: map['roomId'] ?? '',
      phoneNumbers: List<String>.from(map['phoneNumbers']),
    );
  }
}
