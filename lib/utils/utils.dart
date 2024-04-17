import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../core/misc.dart';

class Utils {
  static const int appId = 979387205;
  static const String appSign =
      "c9879d6905ff897e47ab576337acb0527be5e6903fc97253e8aa475d9c672cad";
  static Future<File?> pickImageFromGallery() async {
    File? image;
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
    return image;
  }

  static Future<List<XFile>> pickMultipleMedia() async {
    List<XFile> media = [];
    try {
      media = await ImagePicker().pickMultipleMedia(requestFullMetadata: true);
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
    return media;
  }

  static Future<List<XFile>?> pickDocs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    List<XFile>? files;
    try {
      if (result != null) {
        files = result.xFiles;
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }

    return files;
  }

  static Future<File?> pickVideoFromGallery() async {
    File? video;
    try {
      final pickedVideo =
          await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo != null) {
        video = File(pickedVideo.path);
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
    return video;
  }

  static Future<GiphyGif?> pickGIF({required BuildContext context}) async {
    //ESM5K0V8BaiP6AwVov0SuSTRuhgoaGO5
    GiphyGif? gif;
    try {
      gif = await Giphy.getGif(
          context: context,
          apiKey: 'ESM5K0V8BaiP6AwVov0SuSTRuhgoaGO5',
          showAttribution: false);
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: snackbarDuration,
        message: e.toString(),
      ));
    }
    return gif;
  }
}
