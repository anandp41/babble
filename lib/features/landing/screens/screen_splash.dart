import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/strings.dart';
import '../../../common/widgets/babble_title.dart';
import '../../../core/colors.dart';
import '../../home/screens/home.dart';
import 'screen_get_started.dart';

class ScreenSplash extends ConsumerStatefulWidget {
  const ScreenSplash({super.key});

  @override
  ConsumerState<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends ConsumerState<ScreenSplash> {
  bool _imageLoaded = false;
  @override
  void initState() {
    super.initState();

    timerCumGetStartedImageCacher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BabbleTitleWidget(),
          LoadingAnimationWidget.staggeredDotsWave(color: titleColor, size: 50),
        ],
      )),
      backgroundColor: bodyBackgroundColor,
    );
  }

  Timer timerCumGetStartedImageCacher() {
    return Timer(const Duration(seconds: 2), () async {
      await _loadImage();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        await FlutterContacts.requestPermission();
      }
      if (_imageLoaded) {
        // Get.off
        bool? loggedIn = prefs.getBool(loggedInSharedPrefsString);
        if (FirebaseAuth.instance.currentUser != null ||
            (loggedIn != null && loggedIn == true)) {
          Get.off(() => const Home());
        } else {
          Get.off(() => const ScreenGetStarted());
        }
      }
    });
  }

  Future<void> _loadImage() async {
    try {
      await precacheImage(
          const AssetImage(
            blahBg,
          ),
          context);
      await precacheImage(
          const AssetImage(
            defaultProfilePic,
          ),
          // ignore: use_build_context_synchronously
          context);

      _imageLoaded = true;
    } catch (e) {
      debugPrint('Error loading images for cache: $e');
    }
  }
}
