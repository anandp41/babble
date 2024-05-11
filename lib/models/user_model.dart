import 'saved_contact.dart';

class UserModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> roomId;
  final List<SavedContact> savedContacts;
  UserModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.roomId,
    required this.savedContacts,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'roomId': roomId,
      'savedContacts': savedContacts.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      roomId: List<String>.from(map['roomId']),
      savedContacts: List<SavedContact>.from(
          map['savedContacts']?.map((x) => SavedContact.fromMap(x))),
    );
  }
}
