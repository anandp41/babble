import 'package:flutter/material.dart';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';

import '../../../core/colors.dart';

class PrivacyPolicyTermsConditionsViewerHolderScaffold extends StatelessWidget {
  final String data;
  const PrivacyPolicyTermsConditionsViewerHolderScaffold({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HtmlContentViewer(
                htmlContent: data,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
