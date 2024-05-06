import 'package:flutter/material.dart';
import '../../core/strings.dart';
import '../../core/textstyles.dart';

class BabbleTitleWidget extends StatelessWidget {
  const BabbleTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      appTitle,
      style: appTitleTextStyle,
    );
  }
}
