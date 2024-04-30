import 'package:babble/core/colors.dart';
import 'package:babble/core/strings.dart';
import 'package:babble/presentation/screens/auth/registration.dart';
import 'package:flutter/material.dart';

import '../common/babble_title.dart';

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
            const BabbleTitleWidget(),
            SizedBox(
              width: width * 0.8,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                        (route) => false);
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
                  child: const Text(
                    getStarted,
                    style: TextStyle(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
            )
          ],
        ),
      ),
      backgroundColor: getStartedBg,
    );
  }
}
