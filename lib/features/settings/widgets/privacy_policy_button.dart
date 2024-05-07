import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../core/colors.dart';
import '../../../core/strings.dart';
import '../../../core/textstyles.dart';
import '../../auth/controller/privacy_policy_terms_and_conditions_controller.dart';
import 'pp_and_tc_viewer_holder_scaffold.dart';

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({
    super.key,
    required this.ref,
    required this.screenSize,
  });

  final WidgetRef ref;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var pptcData = await ref.read(pPTCDataControllerProvider).getData();
        Get.to(
          () => PrivacyPolicyTermsConditionsViewerHolderScaffold(
              data: pptcData[firebasePrivacyPolicyDocument]!),
        );
      },
      child: const ListTile(
        leading: Icon(
          Icons.privacy_tip_outlined,
          color: babbleTitleColor,
        ),
        title: Text(
          "Privacy Policy",
          style: settingsButtonsTitleTS,
        ),
      ),
    );
  }
}
