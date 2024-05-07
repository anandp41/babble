import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/misc.dart';
import '../../../core/strings.dart';
import '../../../core/textstyles.dart';
import '../../auth/screens/registration.dart';

class GetStartedButton extends StatelessWidget {
  const GetStartedButton({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width * 0.8,
      child: InkWell(
        onTap: () {
          Get.offAll(() => const RegistrationScreen());
        },
        child: Container(
          width: 200,
          height: 50,
          decoration: const BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(messageBorderRadius)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey]),
          ),
          child: const Center(
            child: Text(
              getStarted,
              style: getStartedTS,
            ),
          ),
        ),
      ),
    );
  }
}
