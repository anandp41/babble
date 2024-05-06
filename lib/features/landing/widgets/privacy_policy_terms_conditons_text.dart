import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';
import 'package:get/get.dart';

import '../../../core/strings.dart';
import '../../../core/textstyles.dart';
import '../../auth/controller/privacy_policy_terms_and_conditions_controller.dart';

class PrivacyPolicyTermsConditionsText extends ConsumerWidget {
  const PrivacyPolicyTermsConditionsText({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(pPTCDataControllerProvider).getData(),
      builder: (context, snapshot) {
        var data = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: defaultStyle,
                children: <TextSpan>[
                  const TextSpan(text: 'Read our '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => HtmlContentViewer(
                                htmlContent:
                                    data![firebasePrivacyPolicyDocument]!,
                                initialContentHeight: screenSize.height,
                                initialContentWidth: screenSize.width,
                              ));
                        }),
                  const TextSpan(text: '. Tap "Get Started" to accept the '),
                  TextSpan(
                      text: 'Terms and Conditions',
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => HtmlContentViewer(
                                htmlContent:
                                    data![firebaseTermsAndConditionsDocument]!,
                                initialContentHeight: screenSize.height,
                                initialContentWidth: screenSize.width,
                              ));
                        }),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
