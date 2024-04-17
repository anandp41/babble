import 'dart:io';
import 'package:babble/repositories/common_firebase_repository.dart';
import 'package:babble/core/strings.dart';
import 'package:babble/models/user_model.dart';
import 'package:babble/presentation/screens/auth/user_information_screen/user_information.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../presentation/screens/auth/otpscreen.dart';
import '../presentation/screens/home/bottom_nav_bar/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import '../presentation/screens/home/home.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});
  String? userPhoneNumber;

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
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
      Get.showSnackbar(GetSnackBar(
        message: e.message,
      ));
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
      userPhoneNumber = phoneNumber;
      Get.offAll(() => const UserInformationScreen());
    } catch (ex) {
      Get.showSnackbar(GetSnackBar(message: ex.toString()));
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
            .storeFileToFirebase(ref: 'Profile_Images/$uid', file: profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          roomId: []);
      await firestore.collection('users').doc(uid).set(user.toMap());
      Get.offAll(BlocProvider<BottomNavBarBloc>(
          create: (context) => BottomNavBarBloc(), child: const Home()));
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        message: e.toString(),
      ));
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  Stream<UserModel> roomData() {
    return firestore
        .collection('roomData')
        .doc('cndh5vggLhcJmobhUJmH')
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
