import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/strings.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';

final contactsRepositoryProvider = Provider(
  (ref) => ContactsRepository(firestore: FirebaseFirestore.instance),
);

class ContactsRepository {
  final FirebaseFirestore firestore;
  ContactsRepository({required this.firestore});
  List<Map<String, String>> savedContacts = [];

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  Future<String> ifSavedContactName(
      {required String phoneNumberFromServerToCheck}) async {
    String name = phoneNumberFromServerToCheck;
    List<Contact> contacts = await getContacts();
    bool found = false;
    for (var contact in contacts) {
      if (contact.phones.isEmpty) {
        continue;
      }
      for (var eachPhoneOfAContact in contact.phones) {
        if (phoneNumberFromServerToCheck
            .replaceAll(' ', '')
            .contains(eachPhoneOfAContact.number.replaceAll(' ', ''))) {
          name = contact.displayName;
          found = true;
          break;
        }
      }
      if (found) {
        break;
      }
    }

    return name;
  }

  Future<List<Map<String, String>>> savedContactsOnBabble() async {
    List<Map<String, String>> resultContacts = [];
    List<Contact> contacts = await getContacts();
    var userCollection =
        await firestore.collection(firebaseUsersCollection).get();

    for (var contact in contacts) {
      if (contact.phones.isEmpty) {
        continue;
      } //move to next iteration if contact does not contain any phone number
      List<String> phoneNums = [];

      for (var phone in contact.phones) {
        phoneNums.add(phone.number);
      } //added phone numbers  of the current contact into a list called "phoneNums"

      //Checking each number for an account in Babble
      bool isInUsers = false;
      for (int i = 0; i < phoneNums.length; i++) {
        isInUsers = false;
        for (var document in userCollection.docs) {
          var userData = UserModel.fromMap(document.data());

          if (userData.phoneNumber.contains(phoneNums[i].replaceAll(' ', ''))) {
            Map<String, String> tempContact = {
              'name': contact.displayName,
              'phone_number': phoneNums[i],
              'uid': userData.uid,
              'profile_pic': userData.profilePic
            };
            isInUsers = true;
            resultContacts.add(tempContact);
            savedContacts.add(tempContact);
          }
        }
        if (isInUsers == false) {
          Map<String, String> tempContact = {
            'name': contact.displayName,
            'phone_number': phoneNums[i].replaceAll(" ", ""),
            'uid': '',
            'profile_pic': ''
          };
          resultContacts.add(tempContact);
        }
      }
    }
    return resultContacts;
  }

  Future<void> updateSavedContactsListToServer({required WidgetRef ref}) async {
    if (!kIsWeb) {
      await ref
          .read(authControllerProvider)
          .updateSavedContacts(savedContacts: savedContacts, ref: ref);
    }
  }
}
