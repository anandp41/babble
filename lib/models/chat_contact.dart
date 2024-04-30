class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final String phoneNumber;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.phoneNumber,
      required this.timeSent,
      required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'phoneNumber': phoneNumber,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      contactId: map['contactId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
