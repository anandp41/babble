import 'dart:io';

import 'package:babble/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider);
  return await authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({required this.ref, required this.authRepository});
  Future<void> signInWithPhone(String phoneNumber) async {
    await authRepository.signInWithPhone(phoneNumber);
  }

  Future<void> verifyOTP(
      {required String verificationId,
      required String otp,
      required String phoneNumber}) async {
    await authRepository.verifyOTP(
        verificationId: verificationId, otp: otp, phoneNumber: phoneNumber);
  }

  Future<void> saveUserDataToFirebase(String name, File? profilePic) async {
    await authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) async {
    authRepository.setUserState(isOnline);
  }
}
