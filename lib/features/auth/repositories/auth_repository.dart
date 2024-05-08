import 'dart:io';
import 'package:babble/common/repositories/common_firebase_repository.dart';
import 'package:babble/core/strings.dart';
import 'package:babble/features/room/controller/room_controller.dart';
import 'package:babble/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/functions/functions.dart';
import '../../home/screens/home.dart';
import '../screens/otpscreen.dart';
import '../screens/user_information.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});
  // String? userPhoneNumber;

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<UserModel?> getAUserData(String uid) async {
    var userData =
        await firestore.collection(firebaseUsersCollection).doc(uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Future<String> getSmsData() async {
    String data = '';
    var smsSnap =
        await firestore.collection(firebaseSms).doc(firebaseSmsDocId).get();

    if (smsSnap.data() != null) {
      data = smsSnap.data()!['data'];
    }
    return data;
  }

  Future<void> removePhoneFromAllSpeakingList({required WidgetRef ref}) async {
    var userData = await getCurrentUserData();
    var roomsUids = userData!.roomId;
    if (roomsUids.isNotEmpty) {
      for (var roomId in roomsUids) {
        await ref.read(roomControllerProvider).removePhoneNumberAsSpeaking(
            roomId: roomId, phoneNumber: userData.phoneNumber);
      }
    }
  }

  Future<void> deleteAccount({required WidgetRef ref}) async {
    try {
      var userData = await getCurrentUserData();
      var roomsList = userData!.roomId;
      for (int i = 0; i < roomsList.length; i++) {
        var roomData = await ref
            .read(roomControllerProvider)
            .getDetailsOfRoom(roomsList[i]);
        var members = roomData.membersUid;
        members.remove(userData.uid);
        await firestore
            .collection(firebaseRoomsCollection)
            .doc(roomsList[i])
            .update({'membersUid': members});
      }
      await firestore
          .collection(firebaseUsersCollection)
          .doc(auth.currentUser!.uid)
          .delete();

      await ref.read(commonFirebaseStorageRepositoryProvider).deleteFile(
          serverFilePath: 'Profile_Images/${auth.currentUser!.uid}');
      await firestore.terminate();
      await firestore.clearPersistence();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(loggedInSharedPrefsString, false);
      await auth.signOut();
      showCustomSnackBar(message: userAccountDeletionCompleteMessage);
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException ex) {
            throw Exception(ex.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            Get.to(() => const OTPScreen(),
                arguments: [verificationId, phoneNumber]);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          phoneNumber: phoneNumber);
    } on FirebaseException catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Future<void> verifyOTP(
      {required String verificationId,
      required String otp,
      required phoneNumber}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await auth.signInWithCredential(credential);
      // userPhoneNumber = phoneNumber;
      Get.offAll(() => const UserInformationScreen());
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Future<void> saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = defaultProfilePicUrl;
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
                serverFilePath: 'Profile_Images/$uid', file: profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          roomId: []);
      await firestore
          .collection(firebaseUsersCollection)
          .doc(uid)
          .set(user.toMap());
      Get.offAll(() => const Home());
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection(firebaseUsersCollection)
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  Future<void> setUserState(bool isOnline) async {
    await firestore
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }

  Future<void> updateUserProfilePic(File profilePic, WidgetRef ref) async {
    try {
      String photoUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              serverFilePath: 'Profile_Images/${auth.currentUser!.uid}',
              file: profilePic);

      await firestore
          .collection(firebaseUsersCollection)
          .doc(auth.currentUser!.uid)
          .update({'profilePic': photoUrl});
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }

  Future<void> deleteUserProfilePic({required WidgetRef ref}) async {
    await ref
        .read(commonFirebaseStorageRepositoryProvider)
        .deleteFile(serverFilePath: 'Profile_Images/${auth.currentUser!.uid}');
    await firestore
        .collection(firebaseUsersCollection)
        .doc(auth.currentUser!.uid)
        .update({'profilePic': ''});
  }

  Future<void> updateUserName(String name, WidgetRef ref) async {
    try {
      await firestore
          .collection(firebaseUsersCollection)
          .doc(auth.currentUser!.uid)
          .update({'name': name});
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
  }
}
