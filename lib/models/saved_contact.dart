class SavedContact {
  final String name;

  final String phoneNumber;

  final String uid;

  final String profilePic;
  SavedContact({
    required this.name,
    required this.phoneNumber,
    required this.uid,
    required this.profilePic,
  });

  factory SavedContact.fromMap(Map<String, dynamic> map) {
    return SavedContact(
      name: map['name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      uid: map['uid'] ?? '',
      profilePic: map['profile_pic'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'uid': uid,
      'profile_pic': profilePic,
    };
  }
}
