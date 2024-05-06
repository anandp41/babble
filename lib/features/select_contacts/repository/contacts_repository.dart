import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';

final contactsRepositoryProvider = Provider(
  (ref) => ContactsRepository(firestore: FirebaseFirestore.instance),
);

class ContactsRepository {
  final FirebaseFirestore firestore;
  ContactsRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // var result = await checkIfOnBabble(contacts);
    // return result;
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

  Future<List<Map<String, String>>> checkIfOnBabble() async {
    List<Contact> contacts = await getContacts();
    List<Map<String, String>> resultContacts = [];

    var userCollection = await firestore.collection('users').get();

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

  // void selectContact(Contact selectedContact) async {
  //   try {
  //     var userCollection = await firestore.collection('users').get();
  //     bool isFound = false;

  //     List<String> selectedPhoneNums = [];

  //     for (var number in selectedContact.phones) {
  //       selectedPhoneNums.add(number.number.replaceAll(' ', ''));
  //     }
  //     for (int i = 0; i < selectedPhoneNums.length; i++) {
  //       for (var document in userCollection.docs) {
  //         var userData = UserModel.fromMap(document.data());

  //         if (selectedPhoneNums[i] == userData.phoneNumber) {
  //           isFound = true;

  //           Get.to(() => ChatScreen(
  //               name: selectedContact.displayName,
  //               phoneNumber: selectedContact.phones,
  //               uid: userData.uid,
  //               profilePic: userData.profilePic));
  //         }
  //       }
  //     }

  //     if (!isFound) {
  //       Get.showSnackbar(const GetSnackBar(
  //         duration: snackbarDuration,
  //         message: "This number does not exist on Babble",
  //       ));
  //     }
  //   } catch (e) {
  //     Get.showSnackbar(
  //         GetSnackBar(duration: snackbarDuration, message: e.toString()));
  //   }
  // }
}