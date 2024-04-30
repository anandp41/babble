import 'package:flutter/material.dart';

import '../../../core/colors.dart';
import '../../screens/common/appbar_back_button.dart';

class CustomOTPAppBar extends StatelessWidget {
  final bool backArrow;
  const CustomOTPAppBar({super.key, this.backArrow = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text(
        'Babble',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: babbleTitleColor,
            fontFamily: 'Jua',
            fontSize: 48,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 5),
      ),
      centerTitle: true,
      //automaticallyImplyLeading: false,
      leading: backArrow ? const AppBarBackButton() : null,
    );
  }
}
