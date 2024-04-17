import 'dart:async';

import 'package:babble/core/colors.dart';
import 'package:babble/presentation/screens/screen_get_started.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../core/strings.dart';
import '../common/babble_title.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  bool _imageLoaded = false;
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      await _loadImage();
      if (_imageLoaded) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ScreenGetStarted()),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BabbleTitleWidget(),
          LoadingAnimationWidget.staggeredDotsWave(color: titleColor, size: 40),
        ],
      )),
      backgroundColor: bodyBackgroundColor,
    );
  }
}
