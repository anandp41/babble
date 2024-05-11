import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../models/user_model.dart';
import '../repositories/auth_repository.dart';

final userDataAuthProvider = FutureProvider<UserModel?>((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});
final smsDataProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider);
  return await authController.getSmsData();
});
final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepository});
  Future<void> signInWithPhone(String phoneNumber) async {
    await authRepository.signInWithPhone(phoneNumber);
  }

  Future<void> updateUserProfilePic(
      {required File profilePic, required WidgetRef ref}) async {
    await authRepository.updateUserProfilePic(profilePic, ref);
  }

  Future<void> updateUserName(
      {required String name, required WidgetRef ref}) async {
    await authRepository.updateUserName(name, ref);
  }

  Future<void> verifyOTP(
      {required String verificationId,
      required String otp,
      required String phoneNumber}) async {
    await authRepository.verifyOTP(
        verificationId: verificationId, otp: otp, phoneNumber: phoneNumber);
  }

  Future<void> updateSavedContacts(
          {required List<Map<String, String>> savedContacts,
          required WidgetRef ref}) async =>
      await authRepository.updateSavedContacts(savedContacts, ref);

  Future<void> saveUserDataToFirebase(String name, File? profilePic) async {
    await authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref);
  }

  Future<UserModel?> getCurrentUserData() async {
    return await authRepository.getCurrentUserData();
    //return user;
  }

  Stream<UserModel> getAUserData({required String uid}) {
    return authRepository.userData(uid);
  }

//  Stream<UserModel> userDataById(String userId) {
//     return authRepository.userData(userId);
  //}
  Future<String> getSmsData() async {
    String data = await authRepository.getSmsData();
    return data;
  }

  Future<void> deleteAccountPermanenlty({required WidgetRef ref}) async {
    await authRepository.deleteAccount(ref: ref);
  }

  Future<void> logOutOfWeb({required WidgetRef ref}) async {
    await authRepository.logOutOfWeb(ref: ref);
  }

  Future<void> setUserState(bool isOnline) async {
    await authRepository.setUserState(isOnline);
  }

  Future<void> removePhoneFromAllSpeakingList({required WidgetRef ref}) async =>
      await authRepository.removePhoneFromAllSpeakingList(ref: ref);

  Future<void> deleteUserProfilePic({required WidgetRef ref}) async =>
      await authRepository.deleteUserProfilePic(ref: ref);

  Future<bool> isThisPhoneRegistered({required String phoneNumber}) async =>
      await authRepository.isThisPhoneRegistered(phoneNumber: phoneNumber);
}
