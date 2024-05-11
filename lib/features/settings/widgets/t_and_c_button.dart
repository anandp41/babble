import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/colors.dart';
import '../../../core/strings.dart';
import '../../../core/textstyles.dart';
import '../../auth/controller/privacy_policy_terms_and_conditions_controller.dart';
import 'pp_and_tc_viewer_holder_scaffold.dart';

class TandCButton extends StatelessWidget {
  const TandCButton({
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
        Get.to(() => PrivacyPolicyTermsConditionsViewerHolderScaffold(
            data: pptcData[firebaseTermsAndConditionsDocument]!));
      },
      child: const ListTile(
        leading: Icon(
          Icons.document_scanner_outlined,
          color: babbleTitleColor,
        ),
        title: Text(
          "Terms and Conditions",
          style: settingsButtonsTitleTS,
        ),
      ),
    );
  }
}
