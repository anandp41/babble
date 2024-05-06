import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../core/misc.dart';

final commonFirebaseStorageRepositoryProvider = Provider((ref) =>
    CommonFirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance));

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRepository({required this.firebaseStorage});
  Future<String> storeFileToFirebase(
      {required String serverFilePath, required File file}) async {
    UploadTask uploadTask =
        firebaseStorage.ref().child(serverFilePath).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteFile({required String serverFilePath}) async {
    try {
      await firebaseStorage.ref().child(serverFilePath).delete();
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
  }
}
