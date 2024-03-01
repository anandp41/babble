import 'package:babble/core/colors.dart';
import 'package:babble/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            appTitle,
            style:  TextStyle(
                color: const Color.fromARGB(255, 7, 24, 85),
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontFamily: mainFont),
          ),
          LoadingAnimationWidget.staggeredDotsWave(
              color: titleColor, size: 40),
        ],
      )),
      backgroundColor: bodyBackgroundColor,
    );
  }
}
