import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/babble_title.dart';
import '../../../core/colors.dart';
import '../../../core/strings.dart';
import '../widgets/get_started_button.dart';
import '../widgets/privacy_policy_terms_conditons_text.dart';

class ScreenGetStarted extends ConsumerWidget {
  const ScreenGetStarted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              blahBg,
            ),
            const BabbleTitleWidget(),
            PrivacyPolicyTermsConditionsText(screenSize: screenSize),
            GetStartedButton(screenSize: screenSize)
          ],
        ),
      ),
      backgroundColor: getStartedBg,
    );
  }
}
