import 'dart:developer';

import 'package:babble/core/colors.dart';
import 'package:babble/core/constant.dart';
import 'package:flutter/material.dart';

class ScreenGetStarted extends StatelessWidget {
  const ScreenGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    //double height = size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              blahBg,
            ),
            Text(
              appTitle,
              style: TextStyle(
                  color: const Color.fromARGB(255, 7, 24, 85),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: mainFont),
            ),
            SizedBox(
              width: width / 1.1,
              child: ElevatedButton(
                  onPressed: () {
                    log('Get Started Pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: kWhite,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      side: BorderSide(
                        color: buttonBorder,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Text(
                    getStarted,
                    style: const TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                    ),
                  )),
            )
          ],
        ),
      ),
      backgroundColor: getStartedBg,
    );
  }
}
