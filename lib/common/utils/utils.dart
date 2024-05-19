import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/giphy_key.dart';
import '../functions/functions.dart';

class Utils {
  static Future<File?> pickImageFromGallery() async {
    File? image;
    var picker = ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
    return image;
  }

  static Future<List<XFile>> pickMultipleMedia() async {
    List<XFile> media = [];
    try {
      media = await ImagePicker().pickMultipleMedia(requestFullMetadata: true);
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
    return media;
  }

  static Future<List<PlatformFile>?> pickDocs() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    List<PlatformFile>? files;
    try {
      if (result != null) {
        files = result.files;
      }
    } catch (e) {
      showCustomSnackBar(message: e.toString());
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
      showCustomSnackBar(message: e.toString());
    }
    return video;
  }

  static Future<GiphyGif?> pickGIF({required BuildContext context}) async {
    //ESM5K0V8BaiP6AwVov0SuSTRuhgoaGO5
    GiphyGif? gif;
    try {
      gif = await Giphy.getGif(
          context: context, apiKey: giphyAPIKey, showAttribution: false);
    } catch (e) {
      showCustomSnackBar(message: e.toString());
    }
    return gif;
  }
}
